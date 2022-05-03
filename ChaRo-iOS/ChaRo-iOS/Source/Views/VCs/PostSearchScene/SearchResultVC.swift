//
//  SearchResultVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/11.
//

import UIKit
import SnapKit
import Then

class SearchResultVC: UIViewController {
    static let identifier = "SearchResultVC"
    
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
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.getDeviceWidth(), height: 624)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.registerCustomXib(xibName: PostResultHeaderCVC.identifier)
        collectionView.registerCustomXib(xibName: CommonCVC.identifier)
        
        return collectionView
    }()
    
    private let closeButton = UIButton().then {
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
    
    private let searchButton = UIButton().then {
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
        setFilterViewCompletion()
        configureCollectionView()
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
    
    func configureCollectionView() {
        collectionView.register(UINib(nibName: PostResultHeaderCVC.identifier, bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PostResultHeaderCVC.identifier)

        collectionView.registerCustomXib(xibName: CommonCVC.identifier)
        collectionView.registerCustomXib(xibName: HomePostDetailCVC.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
    }
    
    func setFilterViewLayout() {
        self.view.addSubview(filterView)
        filterView.isHidden = true
        filterView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(119)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(97)
            $0.width.equalTo(180)
        }
    }
    
    func setFilterViewCompletion(){
        filterView.touchCellCompletion = { index in
            switch index{
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
        cell?.clickedPostCell = { postid in
            let nextVC = PostDetailVC()
            nextVC.setPostId(id: postid)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        if indexPath.row == 0{
            if myCellIsFirstLoaded {
                myCellIsFirstLoaded = false
                topCVCCell = dropDownCell
            }
            topCVCCell?.setTitle(data: currentState)
            return topCVCCell ?? UICollectionViewCell()
        }
        cell?.titleLabel.font = UIFont.notoSansBoldFont(ofSize: 14)
        let post = postData[indexPath.row-1]
        
        cell?.setData(image: post.image,
                      title: post.title,
                      tagCount: 3, tagArr: ["배열이","있는데","개수를왜"],
                      isFavorite: post.isFavorite,
                      postID: post.postID)
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PostResultHeaderCVC.identifier, for: indexPath) as? PostResultHeaderCVC else {
            return UICollectionReusableView()
        }
        header.setStackViewData(list: filterResultList)
        header.addSubview(separateLineView)
        separateLineView.snp.makeConstraints{
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        return header
    }

}

extension SearchResultVC: UICollectionViewDelegateFlowLayout { 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.getDeviceWidth(), height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.size.width-40, height: 57)
        }
        
        return CGSize(width: collectionView.frame.size.width-40, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

extension SearchResultVC {
    
    private func setupConstraint() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(58)
        }
        
        navigationView.addSubviews([backButton,navigationTitleLabel,closeButton])
        backButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(1)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-9)
        }
        
        navigationTitleLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
        closeButton.snp.makeConstraints{
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
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.top.equalTo(self.navigationView.snp.bottom).offset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}


//MARK: Network
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
        print("themeEng =\(themeEng), warningEng = \(warningEng)")
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
