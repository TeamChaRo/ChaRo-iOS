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
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: screenWidth, height: screenWidth * (202.0 / 375.0))
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        $0.setCollectionViewLayout(layout, animated: true)
        $0.tintColor = .clear
        $0.register(cell: PostPhotoCVC.self)
        $0.delegate = self
        $0.dataSource = self
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    
    private let photoSubject = PublishSubject<[String]>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
    }
    
    private func configureUI() {
        selectionStyle = .none
    }
    
    private func bind(){
        photoSubject.bind(to: collectionView.rx.items(cellIdentifier: PostPhotoCVC.className,
                                                     cellType: PostPhotoCVC.self))  { row, element, cell in
        }.disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegate
extension PostPhotoTVC: UICollectionViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
       // photoNumberButton.setTitle("\(currentPage + 1) / 6", for: .normal)
    }
}

// MARK: - UICollectionViewDataSource
extension PostPhotoTVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PostPhotoCVC
        return cell
    }
}
