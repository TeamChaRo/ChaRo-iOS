//
//  CreatePostPhotoTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/12.
//

import UIKit
import Then

class CreatePostPhotoTVC: UITableViewCell {
    
    static let identifier: String = "CreatePostPhotoTVC"
    var receiveImageList: [UIImage] = [] {
        didSet {
            print("receiveImageList")
            print(receiveImageList)
        }
    }
    
    private let maxPhotoCount: Int = 6
    
    // MARK: UI Components

    private let photoBackgroundView: UIView = UIView().then {
        $0.backgroundColor = UIColor.mainBlue.withAlphaComponent(0.2)
    }

    private let photoSubBackgroundView: UIView = UIView().then {
        $0.backgroundColor = UIColor.white
    }

    private let emptyImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "photo1")
    }

    private let discriptionText: UILabel = UILabel().then {
        $0.text = "이번에 다녀오신 드라이브는 어떠셨나요?\n사진을 첨부해 기록으로 남겨보세요  (0/6)"
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = UIColor.gray40
    }
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let heigthRatio: CGFloat = 222/335
        let width: CGFloat = UIScreen.getDeviceWidth()-40
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: width, height: width*heigthRatio), collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setNotificationCenter()
        self.setImageGesture()
        self.setLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
}

extension CreatePostPhotoTVC {
    
    // MARK:- Functions

    func setCollcetionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerCustomXib(xibName: CreatePostPhotosCVC.identifier)
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.collectionView.reloadData()
    }
    
    private func setImageGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap))
        self.emptyImageView.addGestureRecognizer(tapGesture)
        self.emptyImageView.isUserInteractionEnabled = true
    }

    private func setLayout() {
        self.photoBackgroundView.layer.cornerRadius = 12.0
        self.photoSubBackgroundView.layer.borderWidth = 1.0
        self.photoSubBackgroundView.layer.borderColor = UIColor.gray20.cgColor
        self.photoSubBackgroundView.layer.cornerRadius = 10.0
    }
    

    func receiveImageListfromVC(image: [UIImage]){
        self.receiveImageList.removeAll()
        self.receiveImageList.append(contentsOf: image)
    }
    
    @objc
    func imageViewDidTap(){
        NotificationCenter.default.post(name: .callPhotoPicker, object: nil)
    }

    func setNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(imageViewDidTap), name: .createPostAddPhotoClicked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deletePhoto), name: .createPostDeletePhotoClicked, object: nil)
    
    }
    
    func removeObservers(){ // TODO: 얘를 어디서 호출할지..?
        NotificationCenter.default.removeObserver(self, name: .createPostAddPhotoClicked, object: nil)
        NotificationCenter.default.removeObserver(self, name: .createPostDeletePhotoClicked, object: nil)
    }

    @objc
    func deletePhoto(_ notification: Notification){
        print("====delete====")
        self.receiveImageList.remove(at: notification.object as! Int) //선택한 이미지 삭제
        collectionView.reloadData()
    }
    
    // MARK:- Layout
    func emptyConfigureLayout(){

        addSubviews([
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
    
    func photoConfigureLayout(){
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.bottom.equalTo(self.snp.bottom).inset(33)
        }
    }
    
   
}

extension CreatePostPhotoTVC : UICollectionViewDelegate {
    
}

extension CreatePostPhotoTVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if receiveImageList.count >= maxPhotoCount {
            return maxPhotoCount
        } else {
            return receiveImageList.count+1 // TODO: VC에 이미지 배열에서 받아와야함
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatePostPhotosCVC.identifier, for: indexPath) as? CreatePostPhotosCVC else {return UICollectionViewCell() }

        
        cell.deleteButton.tag = indexPath.row
        
        if receiveImageList.count >= maxPhotoCount { // image가 6개면 일반 셀만
            cell.configureLayout()
            cell.setImageView(image: receiveImageList[indexPath.row])
        } else {
            if indexPath.row == receiveImageList.count { // 마지막 셀은 플러스 버튼
                cell.plusViewConfigureLayout()
            } else {
                cell.configureLayout()
                cell.setImageView(image: receiveImageList[indexPath.row])
            }
        }
        
        return cell
    }
    
}

extension CreatePostPhotoTVC : UICollectionViewDelegateFlowLayout {
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
