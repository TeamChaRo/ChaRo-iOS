//
//  OnBoardVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/14.
//

import UIKit

class OnBoardVC: UIViewController {

    static let identifier = "OnBoardVC"
    private var imageList : [UIImage] = []
    private var titleList : [String] = []
    private var subTitleList: [String] = []
    
    private let skipButton : UIButton = {
        let button = UIButton()
        button.setTitle("SKIP", for: .normal)
        button.setTitleColor(.mainBlue, for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 18)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return button
    }()
    
    private var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let rate : CGFloat = UIScreen.getDeviceHeight() / 812
        
        layout.itemSize = CGSize(width: UIScreen.getDeviceWidth(), height: rate * 624)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: true)
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.tintColor = .mainlightBlue
        pageControl.pageIndicatorTintColor = .mainlightBlue
        pageControl.currentPageIndicatorTintColor = .mainBlue
        pageControl.numberOfPages = 3
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.backgroundColor = .mainBlue
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return button
    }()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initContentList()
        setConstraints()
        configureCollectionView()
    }
    
    private func initContentList(){
        imageList.append(contentsOf: [UIImage(named: "onboardingBackground1")!,
                                      UIImage(named: "onboardingBackground2")!,
                                      UIImage(named: "onboardingBackground3")!])
        
        titleList.append(contentsOf: ["구경해요!",
                                      "검색해요!",
                                      "작성해요!"])

        subTitleList.append(contentsOf: ["사람들의 드라이브 경험을\n자유롭게 구경해보세요",
                                         "원하는 지역과 테마로\n맞춤 드라이브 코스를 찾아보세요",
                                         "나만의 드라이브 코스를\n기록하고 공유해보세요"])
    }
    
    
    @objc func dismissAction(){
        dismiss(animated: true, completion: nil)
    }

    private func setConstraints(){
        view.addSubviews([skipButton,
                          collectionView,
                          pageControl,
                          startButton])
        
        view.backgroundColor = UIColor(red: 241.0/255.0, green: 243/255.0, blue: 246/255.0, alpha: 1.0)
        
        skipButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(46)
            $0.width.equalTo(74)
        }
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(skipButton.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-49)
        }
        
        pageControl.snp.makeConstraints{
            $0.centerX.equalTo(view.snp.centerX)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-42)
        }
        
        startButton.snp.makeConstraints{
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-26)
            $0.height.equalTo(48)
        }
        
    }
    
}

extension OnBoardVC{
    
    func configureCollectionView(){
        collectionView.registerCustomXib(xibName: OnBoardCVC.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating = \(scrollView)")
        let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        print("currentPage = \(currentPage)")
        pageControl.currentPage = currentPage

        if(currentPage == 2){
            skipButton.isHidden = true
            startButton.isHidden = false
        }else{
            skipButton.isHidden = false
            startButton.isHidden = true
        }
    }
}

extension OnBoardVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension OnBoardVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardCVC.identifier, for: indexPath) as? OnBoardCVC else {
            return UICollectionViewCell()
        }
        let index = indexPath.row
        
        cell.setContent(image: imageList[index],
                        title: titleList[index],
                        subTitle: subTitleList[index])
        
        return cell
    }
    
}

