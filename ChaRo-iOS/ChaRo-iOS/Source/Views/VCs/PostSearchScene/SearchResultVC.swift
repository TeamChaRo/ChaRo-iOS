//
//  SearchResultVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/11.
//

import UIKit

import SnapKit
import Then

final class SearchResultVC: UIViewController {
    
    //MARK: Result Data
    public var lastPostId: Int = 0
    public var postCount: Int = 0
    public var postData: [DriveElement] = []
    public var filterResultList: [String] = []
    var myCellIsFirstLoaded: Bool = true
    
    var currentState: String = "인기순"
    
    var topCVCCell: HomePostDetailCVC?
    
    //MARK: UIComponent
    private let navigationView = UIView()
    private let filterView = FilterView()
    private lazy var backButton = LeftBackButton(toPop: self)
    private let navigationTitleLabel = NavigationTitleLabel(title: "드라이브 맞춤 검색 결과",
                                                            color: .mainBlack)
    private let separateLineView = UIView().then {
        $0.backgroundColor = .gray20
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: UICollectionViewFlowLayout() ).then {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.getDeviceWidth(), height: 624)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        $0.isPagingEnabled = false
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.setCollectionViewLayout(layout, animated: true)
        $0.delegate = self
        $0.dataSource = self
        $0.registerCustomXib(xibName: CommonCVC.identifier)
        $0.registerCustomXib(xibName: HomePostDetailCVC.identifier)
    }
    
    private lazy var closeButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.titleLabel?.font = .notoSansMediumFont(ofSize: 17)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    }
    private let searchNoImageView = UIImageView().then {
        $0.image = ImageLiterals.imgSearchNoImage
        $0.contentMode = .scaleAspectFit
    }
    private let searchNoLabel = UILabel().then {
        $0.text = "검색하신 드라이브 코스가 아직 없습니다\n직접 나만의 드라이브 코스를\n만들어보는 것은 어떠신가요?"
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.textColor = .gray50
    }
    
    private lazy var searchButton = UIButton().then {
        $0.setTitle("드라이브 코스 작성하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .notoSansBoldFont(ofSize: 16)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .mainBlue
        $0.addTarget(self, action: #selector(presentToCreatePostVC), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postSearchPost(type: "like")
        setupConstraint()
        configureUI()
        setFilterViewCompletion()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    public func setFilterTagList(list: [String]) {
        filterResultList = list
    }
    
    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func presentToCreatePostVC() {
        let tabbar = presentingViewController as! TabbarVC
        let createStoryboard = UIStoryboard(name: "CreatePost", bundle: nil)
        let createVC = createStoryboard.instantiateViewController(identifier: CreatePostVC.className)
        let createTab = UINavigationController(rootViewController: createVC)
        createTab.modalPresentationStyle = .fullScreen
        dismiss(animated: false) {
            tabbar.present(createTab, animated: true, completion: nil)
        }
    }
    
    private func setFilterViewLayout() {
        self.view.addSubview(filterView)
        filterView.isHidden = true
        filterView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(119)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(97)
            $0.width.equalTo(180)
        }
    }
    
    private func setFilterViewCompletion() {
        filterView.touchCellCompletion = { index in
            switch index {
            case 0:
                self.currentState = "인기순"
                self.postSearchPost(type: "new")
                self.collectionView.reloadData()
                self.filterView.isHidden = true
            case 1:
                self.currentState = "최신순"
                self.postSearchPost(type: "like")
                self.collectionView.reloadData()
                self.filterView.isHidden = true
            default:
                print("Error")
            }
            return index
        }
    }
}

// MARK: collection view
extension SearchResultVC: UICollectionViewDelegate {
    
}

extension SearchResultVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: indexPath) as? CommonCVC
        let dropDownCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostDetailCVC.identifier, for: indexPath) as? HomePostDetailCVC
        dropDownCell?.delegate = self
        topCVCCell?.delegate = self
        cell?.clickedPostCell = { [weak self] postId in
            let nextVC = PostDetailVC(postId: postId)
            self?.navigationController?.pushViewController(nextVC, animated: true)
        }
        if indexPath.row == 0 {
            if myCellIsFirstLoaded {
                myCellIsFirstLoaded = false
                topCVCCell = dropDownCell
            }
            topCVCCell?.setTitle(data: currentState)
            return topCVCCell ?? UICollectionViewCell()
        }
        cell?.titleLabel.font = UIFont.notoSansBoldFont(ofSize: 14)
        let post = postData[indexPath.row-1]
        
        cell?.setData(viewModel: CommonCVC.ViewModel(image: post.image,
                                                     title: post.title,
                                                     tagCount: 3,
                                                     tagArr: [post.region, post.theme, post.warning ?? ""],
                                                     isFavorite: post.isFavorite,
                                                     postID: post.postID,
                                                     height: 0))
        return cell!
    }

}

extension SearchResultVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = indexPath.row == 0 ? 57 : 260
        return CGSize(width: UIScreen.getDeviceWidth() - 40.0, height: height)
    }
}

// MARK: - UI
extension SearchResultVC {
    
    private func setupConstraint() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(58)
        }
        
        navigationView.addSubviews([backButton,navigationTitleLabel,closeButton])
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(1)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-9)
        }
        
        navigationTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(backButton.snp.centerY)
        }
    }
    
    private func setContentViewConstraint() {
        if postData.isEmpty{
            setEmptyViewConstraint()
        } else {
            setResultViewConstraint()
            setFilterViewLayout()
        }
    }
    
    private func setEmptyViewConstraint() {
        view.addSubviews([separateLineView, searchNoImageView, searchNoLabel, searchButton])
        separateLineView.snp.makeConstraints{
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(navigationView.snp.bottom)
            $0.height.equalTo(1)
        }
        
        searchNoImageView.snp.makeConstraints{
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(navigationView.snp.bottom).offset(28)
        }
        
        searchNoLabel.snp.makeConstraints{
            $0.top.equalTo(searchNoImageView.snp.bottom).offset(19)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        searchButton.snp.makeConstraints{
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(48)
        }
    }
    
    private func setResultViewConstraint() {
        let tagHeaderView = initTagHearderView()
        view.addSubviews([collectionView, separateLineView, tagHeaderView])
        tagHeaderView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(65)
        }
        
        separateLineView.snp.makeConstraints {
            $0.top.equalTo(tagHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(separateLineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - 상단 tag header view
extension SearchResultVC {
    private func initTagHearderView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0,
                                        width: UIScreen.getDeviceWidth(),
                                        height: 65))
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: makeTagLabelList())
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(13)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.bottom.equalToSuperview().inset(15)
            $0.height.equalTo(34)
        }
        return view
    }
    
    private func makeTagLabelList() -> [UIButton] {
        var list: [UIButton] = []
        for index in 0..<filterResultList.count {
            if filterResultList[index] == "" || filterResultList[index] == "선택안함" { continue }
            let isWarningIndex = index == 3
            let buttonTitle = isWarningIndex ? "    \(filterResultList[index])X    " : "    \(filterResultList[index])    "
            let button = UIButton().then {
                $0.titleLabel?.font = .notoSansRegularFont(ofSize: 12)
                $0.layer.cornerRadius = 15
                $0.layer.borderWidth = 1
                $0.setTitle(buttonTitle, for: .normal)
                $0.setTitleColor(isWarningIndex ? .gray30 : .mainBlue, for: .normal)
                $0.layer.borderColor = isWarningIndex ? UIColor.gray30.cgColor : UIColor.mainLightBlue.cgColor
            }
            list.append(button)
        }
        return list
    }
}


// MARK: Network
extension SearchResultVC{
    func refinePostResultData(data: Drive?) {
        postData = data?.drive ?? []
        print("post data = \(postData)")
        setContentViewConstraint()
        self.collectionView.reloadData()
    }
    
    func postSearchPost(type: String) {
        let themeEng = CommonData.themeDict[filterResultList[2]] ?? ""
        let warningEng = CommonData.warningDataDict[filterResultList[3]] ?? ""
        PostResultService.shared.postSearchKeywords(region: filterResultList[1],
                                                    theme: themeEng,
                                                    warning: warningEng,
                                                    type: type) { response in
            switch(response) {
            case .success(let resultData):
                if let data = resultData as? Drive {
                    self.refinePostResultData(data: data)
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}

extension SearchResultVC: MenuClickedDelegate {
    func menuClicked(){
        filterView.isHidden = false
    }
}
extension SearchResultVC{
func dismissDropDownWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(dismissDropDown))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    @objc func dismissDropDown() {
        self.filterView.isHidden = true
    }
}
