//
//  CreatePostPhotoTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/12.
//

import UIKit
import Then

protocol CreatePostPhotoTVCActionDelegate: AnyObject {
    func didTapAddImageButton()
    func didTapDeleteImageButton(index: Int)
}

final class CreatePostPhotoTVC: UITableViewCell {

    // MARK: Constants

    private enum Metric {
        static let maxCount: Int = 6
    }


    // MARK: Properties

    private var receiveImageList: [UIImage] = []
    weak var actionDelegate: CreatePostPhotoTVCActionDelegate?


    // MARK: UI

    private let photoBackgroundView = UIView().then {
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = UIColor.mainBlue.withAlphaComponent(0.2)
    }

    private let photoSubBackgroundView = UIView().then {
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = UIColor.white
    }

    private let emptyImageView = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.image = UIImage(named: "photo1")
    }

    private let discriptionText = UILabel().then {
        $0.isUserInteractionEnabled = true
        $0.text = "이번에 다녀오신 드라이브는 어떠셨나요?\n사진을 첨부해 기록으로 남겨보세요  (0/6)"
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = UIColor.gray40
    }
    
    private let collectionView = UICollectionView(
        frame: CGRect.zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(
                width: (UIScreen.getDeviceWidth() - 54.0) / 3,
                height: (UIScreen.getDeviceWidth() - 54.0) / 3
            )
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
            $0.scrollDirection = .vertical
        }
        $0.setCollectionViewLayout(layout, animated: true)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addImageGesture()
        self.configureLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}


// MARK: Functions

extension CreatePostPhotoTVC {

    func configureCollcetionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerCustomXib(xibName: CreatePostPhotosCVC.identifier)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.reloadData()
    }
    
    private func addImageGesture() {
        self.photoBackgroundView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(imageViewDidTap)
        ))
        self.photoSubBackgroundView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(imageViewDidTap)
        ))
        self.discriptionText.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(imageViewDidTap)
        ))
        self.emptyImageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(imageViewDidTap)
        ))
    }

    func receiveImageListfromVC(image: [UIImage]) {
        self.receiveImageList.removeAll()
        self.receiveImageList.append(contentsOf: image)
    }
    
    @objc private func imageViewDidTap() {
        self.actionDelegate?.didTapAddImageButton()
    }

    @objc func deletePhoto(index: Int) {
        guard self.receiveImageList.count > index else { return }
        self.receiveImageList.remove(at: index) //선택한 이미지 삭제
        self.collectionView.reloadData()
    }

    func updateEmptyViewVisible(isHidden: Bool) {
        if isHidden {
            self.photoBackgroundView.isHidden = true
            self.photoSubBackgroundView.isHidden = true
            self.discriptionText.isHidden = true
            self.emptyImageView.isHidden = true
        } else {
            self.photoBackgroundView.isHidden = false
            self.photoSubBackgroundView.isHidden = false
            self.discriptionText.isHidden = false
            self.emptyImageView.isHidden = false
        }
    }
}


// MARK: - Layout

extension CreatePostPhotoTVC {

    private func configureLayout() {
        self.photoBackgroundView.layer.cornerRadius = 12.0
        self.photoSubBackgroundView.layer.borderWidth = 1.0
        self.photoSubBackgroundView.layer.borderColor = UIColor.gray20.cgColor
        self.photoSubBackgroundView.layer.cornerRadius = 10.0
    }

    func emptyConfigureLayout() {

        self.addSubviews([
            self.photoBackgroundView,
            self.photoSubBackgroundView,
            self.discriptionText,
            self.emptyImageView
        ])

        self.photoBackgroundView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.bottom.equalTo(self.snp.bottom).inset(33)
        }
        self.photoSubBackgroundView.snp.makeConstraints {
            $0.top.equalTo(self.photoBackgroundView.snp.top).inset(33)
            $0.width.equalTo(110)
            $0.height.equalTo(self.photoSubBackgroundView.snp.width).multipliedBy(1.0)
            $0.centerX.equalTo(self.photoBackgroundView.snp.centerX)
        }
        self.discriptionText.snp.makeConstraints {
            $0.top.equalTo(self.photoSubBackgroundView.snp.bottom).offset(8)
            $0.height.equalTo(44)
            $0.width.equalTo(240)
            $0.centerX.equalTo(self.photoBackgroundView.snp.centerX)
        }
        self.emptyImageView.snp.makeConstraints {
            $0.top.equalTo(self.photoSubBackgroundView.snp.top).inset(31)
            $0.height.equalTo(48)
            $0.width.equalTo(self.emptyImageView.snp.height).multipliedBy(1)
            $0.centerX.equalTo(self.photoSubBackgroundView.snp.centerX)
        }
    }
    
    func configurePhotoLayout() {
        addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.bottom.equalTo(self.snp.bottom).inset(33)
        }
    }
}


// MARK: - UICollectionViewDelegate

extension CreatePostPhotoTVC: UICollectionViewDelegate {
    
}


// MARK: - UICollectionViewDataSource

extension CreatePostPhotoTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.receiveImageList.count >= Metric.maxCount {
            return Metric.maxCount
        } else {
            return self.receiveImageList.count+1 // TODO: VC에 이미지 배열에서 받아와야함
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CreatePostPhotosCVC.identifier, for: indexPath
        ) as? CreatePostPhotosCVC else { return UICollectionViewCell() }

        cell.actionDelegate = self

        if self.receiveImageList.count >= Metric.maxCount { // image가 6개면 일반 셀만
            cell.configureLayout()
            cell.updateimageViewVisible(isHidden: false)
            cell.setImageView(
                data: CreatePostPhotosCVC.PostImage(
                    image: self.receiveImageList[indexPath.row],
                    index: indexPath.row
                )
            )
        } else if self.receiveImageList.isEmpty {
            self.emptyConfigureLayout()
            self.updateEmptyViewVisible(isHidden: false)
            cell.updateplusViewVisible(isHidden: true)
            cell.updateimageViewVisible(isHidden: true)
        } else {
            if indexPath.row == self.receiveImageList.count { // 마지막 셀은 플러스 버튼
                cell.plusViewConfigureLayout()
                cell.updateplusViewVisible(isHidden: false)
            } else {
                cell.configureLayout()
                cell.updateimageViewVisible(isHidden: false)
                cell.setImageView(
                    data: CreatePostPhotosCVC.PostImage(
                        image: self.receiveImageList[indexPath.row],
                        index: indexPath.row
                    )
                )
            }
        }
        
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension CreatePostPhotoTVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsize: CGFloat = (UIScreen.getDeviceWidth() - 54.0) / 3
        return CGSize(width: cellsize, height: cellsize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


// MARK: - CreatePostPhotosCVCActionDelegate

extension CreatePostPhotoTVC: CreatePostPhotosCVCActionDelegate {

    func didTapAddButton() {
        self.imageViewDidTap()
    }

    func didTapDeleteButton(index: Int) {
        self.actionDelegate?.didTapDeleteImageButton(index: index)
        self.deletePhoto(index: index)
    }
}
