//
//  FourthBannerVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/05/10.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class FourthBannerVC: BannerVC {
    
    private var aboutCharoIamgeViewList: [UIImageView] = []
    private var contentList: [ContentModel] = []
    
    struct ContentModel {
        let image: UIImage?
        let title: String
        let subTitle: String
    }
    
    private let pageControl = UIPageControl().then {
        $0.numberOfPages = 3
        $0.currentPageIndicatorTintColor = .gray
        $0.pageIndicatorTintColor = .lightGray
        $0.isUserInteractionEnabled = false
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 522 * viewRetio)
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
            $0.scrollDirection = .horizontal
        }
        $0.setCollectionViewLayout(layout, animated: true)
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.tintColor = .clear
        $0.backgroundColor = .white
        $0.register(cell: BannerAboutCell.self)
        $0.rx.setDelegate(self)
        $0.layer.cornerRadius = 20
    }
    
    private lazy var shadowView = UIView().then {
        $0.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0,
                                                        width: UIScreen.main.bounds.width - 40,
                                                        height: 527 * viewRetio)).cgPath
        $0.layer.cornerRadius = 20
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowRadius = 7
        $0.layer.shadowColor = UIColor.mainBlue.cgColor
        $0.layer.masksToBounds = false
    }
    
    override func setConstraints() {
        super.setConstraints()
        initAboutImageView()
        guard aboutCharoIamgeViewList.count == 3 else { return }
        scrollView.addSubviews(aboutCharoIamgeViewList)
        scrollView.addSubviews([shadowView, collectionView, pageControl])
        
        aboutCharoIamgeViewList[0].snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(aboutCharoIamgeViewList[0].frame.height * viewRetio)
        }
        
        aboutCharoIamgeViewList[1].snp.makeConstraints {
            $0.top.equalTo(aboutCharoIamgeViewList[0].snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(aboutCharoIamgeViewList[1].frame.height * viewRetio)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(aboutCharoIamgeViewList[1].snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(522 * viewRetio)
        }
        
        shadowView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(collectionView)
        }
        
        pageControl.snp.makeConstraints {
            $0.bottom.equalTo(collectionView.snp.bottom).inset(30)
            $0.centerX.equalToSuperview()
        }
        
        aboutCharoIamgeViewList[2].snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(30)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(aboutCharoIamgeViewList[2].frame.height * viewRetio)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        contentList.append(contentsOf: [ ContentModel(image: ImageLiterals.imgAboutBanner1,
                                                      title: "구경하고", subTitle: "사람들의 드라이브 경험을\n자유롭게 구경해보세요."),
                                         ContentModel(image: ImageLiterals.imgAboutBanner2,
                                                      title: "검색하고", subTitle: "원하는 지역과 테마로\n맞춤 드라이브 코스를 찾아보세요."),
                                         ContentModel(image: ImageLiterals.imgAboutBanner3,
                                                      title: "작성하고", subTitle: "나만의 드라이브 코스를\n기록하고 공유해보세요.")])
    }
    
    override func bind() {
        super.bind()
        Observable.just(contentList)
            .bind(to: collectionView.rx.items(cellIdentifier: BannerAboutCell.className,
                                                  cellType: BannerAboutCell.self)) { [weak self] row, element, cell in
                guard let content = self?.contentList[row] else { return }
                cell.setContent(image: content.image, title: content.title, subTitle: content.subTitle)
            }.disposed(by: disposeBag)
    }
    
    private func initAboutImageView() {
        aboutCharoIamgeViewList.append(contentsOf: [ UIImageView(image: ImageLiterals.imgAboutCharo1),
                                                     UIImageView(image: ImageLiterals.imgAboutCharo2),
                                                     UIImageView(image: ImageLiterals.imgAboutCharo4)])
        aboutCharoIamgeViewList.forEach {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
    }
}

extension FourthBannerVC: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        pageControl.currentPage = currentPage
    }
}
