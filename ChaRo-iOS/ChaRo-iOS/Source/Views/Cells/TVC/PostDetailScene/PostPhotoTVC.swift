//
//  PostImagesTVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/16.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class PostPhotoTVC: UITableViewCell{
    
    // MARK: - properties
    
    private let disposeBag = DisposeBag()
    private let photoSubject = PublishSubject<[String]>()
    private var imageList: [String] = []
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: screenWidth, height: screenWidth * (222.0 / 375.0))
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        $0.setCollectionViewLayout(layout, animated: true)
        $0.tintColor = .clear
        $0.register(cell: PostPhotoCVC.self)
        $0.rx.setDelegate(self)
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    
    private let photoNumberButton = UIButton().then{
        $0.titleLabel?.font = .notoSansRegularFont(ofSize: 11)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .gray30.withAlphaComponent(0.8)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        configureUI()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        contentView.addSubviews([collectionView, photoNumberButton])
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.getDeviceWidth() * (222.0 / 375.0) )
        }
        
        photoNumberButton.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.top).offset(16)
            $0.trailing.equalTo(collectionView.snp.trailing).offset(-15)
            $0.width.equalTo(44)
            $0.height.equalTo(18)
        }
    }
    
    private func configureUI() {
        selectionStyle = .none
    }
    
    private func bind() {
        photoSubject
            .bind(to: collectionView.rx.items(cellIdentifier: PostPhotoCVC.className,
                                                     cellType: PostPhotoCVC.self)) { row, element, cell in
                cell.setImage(to: element)
        }.disposed(by: disposeBag)
    }
    
    func setContent(imageList: [String]) {
        self.imageList = imageList
        photoNumberButton.setTitle("1 / \(imageList.count)", for: .normal)
        photoSubject.onNext(imageList)
    }
}

// MARK: - UICollectionViewDelegate
extension PostPhotoTVC: UICollectionViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        photoNumberButton.setTitle("\(currentPage + 1) / \(imageList.count)", for: .normal)
    }
}

