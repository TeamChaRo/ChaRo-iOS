//
//  SearchResultVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/11.
//

import UIKit

class SearchResultVC: UIViewController {

    static let identifier = "SearchResultVC"
    
    //MARK: Result Data
    public var postCount: Int = 0
    public var postData : [DetailDrive] = []
    public var filterResultList: [String] = []
    var myCellIsFirstLoaded: Bool = true
    
    var topCVCCell: HomePostDetailCVC?
    
    //MARK: UIComponent
    private let navigationView = UIView()
    @IBOutlet weak var dropDownTableView: UITableView!
    private lazy var backButton = LeftBackButton(toPop: self)
    private let navigationTitleLabel = NavigationTitleLabel(title: "드라이브 맞춤 검색 결과",
                                                            color: .mainBlack)
    
    private var collectionView : UICollectionView = {
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
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 17)
        button.setTitleColor(.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: Result non view
    private let searchNoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "searchNoImage"))
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let searchNoLabel :UILabel = {
        let label = UILabel()
        label.text = "검색하신 드라이브 코스가 아직 없습니다\n직접 나만의 드라이브 코스를\n만들어보는 것은 어떠신가요?"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .notoSansRegularFont(ofSize: 14)
        label.textColor = .gray50
        return label
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("드라이브 코스 작성하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .notoSansBoldFont(ofSize: 16)
        button.layer.cornerRadius = 8
        button.backgroundColor = .mainBlue
        button.addTarget(self, action: #selector(presentToCreatePostVC), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postSearchPost(type: "like")
        setConstraint()
        configureCollectionView()
        setShadowInNavigationView()
        configureDropDown()
        
    }
    
    public func setFilterTagList(list: [String]){
        filterResultList = list
    }

    
    @objc func dismissAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func presentToCreatePostVC(){
        let tabbar = presentingViewController as! TabbarVC
        let createStoryboard = UIStoryboard(name: "CreatePost", bundle: nil)
        let createVC = createStoryboard.instantiateViewController(identifier: CreatePostVC.identifier)
        let createTab = UINavigationController(rootViewController: createVC)
        createTab.modalPresentationStyle = .fullScreen
        dismiss(animated: false){
            tabbar.present(createTab, animated: true, completion: nil)
        }
    }
    
    
    func configureCollectionView(){
        collectionView.register(UINib(nibName: PostResultHeaderCVC.identifier, bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PostResultHeaderCVC.identifier)

        collectionView.registerCustomXib(xibName: CommonCVC.identifier)
        collectionView.registerCustomXib(xibName: HomePostDetailCVC.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        
       
    }
    func configureDropDown(){
        dropDownTableView.registerCustomXib(xibName: HotDropDownTVC.identifier)
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        dropDownTableView.isHidden = true
        dropDownTableView.separatorStyle = .none
        dropDownTableView.clipsToBounds = true
        dropDownTableView.layer.cornerRadius = 20

    }
    
}

extension SearchResultVC: UICollectionViewDelegate{
    
}

extension SearchResultVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postData.count + 1

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: indexPath) as? CommonCVC
        let dropDownCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostDetailCVC.identifier, for: indexPath) as? HomePostDetailCVC
        dropDownCell?.delegate = self
        cell?.clickedPostCell = { postid in
            let storyboard = UIStoryboard(name: "PostDetail", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: PostDetailVC.identifier) as! PostDetailVC
            
            nextVC.setPostId(id: postid)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        if indexPath.row == 0{
            if myCellIsFirstLoaded {
                myCellIsFirstLoaded = false
                topCVCCell = dropDownCell
                topCVCCell?.postCount = postCount
                topCVCCell?.setLabel()
            }
            return topCVCCell as! UICollectionViewCell
        }
        cell?.titleLabel.font = UIFont.notoSansBoldFont(ofSize: 14)
        cell?.setData(image: postData[indexPath.row-1].image, title: postData[indexPath.row-1].title, tagCount: postData[indexPath.row-1].tags.count, tagArr: postData[indexPath.row-1].tags, isFavorite: postData[indexPath.row-1].isFavorite, postID: postData[indexPath.row-1].postID)
        
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PostResultHeaderCVC.identifier, for: indexPath) as? PostResultHeaderCVC else {
            return UICollectionReusableView()
        }
        header.setStackViewData(list: filterResultList)
        return header
        
    }

}

extension SearchResultVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.getDeviceWidth(), height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0{
            return CGSize(width: collectionView.frame.size.width-40, height: 30)
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


extension SearchResultVC{
    
    private func setConstraint(){
        view.addSubview(navigationView)
    
        navigationView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view)
            $0.height.equalTo(UIScreen.getNotchHeight() + 58)
        }
        
        setShadowInNavigationView()
        setConstraintsInNavigaitionView()
    }
    
    
    private func setConstraintsInNavigaitionView(){
        navigationView.addSubviews([backButton,
                                    navigationTitleLabel
                                    ,closeButton])
        
        backButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(UIScreen.getNotchHeight() + 1)
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
    
    private func setContentViewConstraint(){
        if postData.isEmpty{
            setEmptyViewConstraint()
        }else{
            setResultViewConstraint()
        }
    }
    
    private func setEmptyViewConstraint(){
        view.addSubviews([searchNoImageView,
                          searchNoLabel,
                          searchButton])
        
        searchNoImageView.snp.makeConstraints{
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(navigationView.snp.bottom).offset(28)
        }
        
        searchNoLabel.snp.makeConstraints{
            $0.top.equalTo(searchNoImageView.snp.bottom).offset(19)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        searchButton.snp.makeConstraints{
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(48)
        }
    }
    
    private func setResultViewConstraint(){
        view.addSubview(collectionView)
        view.addSubview(dropDownTableView)
        collectionView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    

    func setShadowInNavigationView(){
        navigationView.backgroundColor = .white

        navigationView.layer.shadowOpacity = 0.05
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 0)
        navigationView.layer.shadowRadius = 6
        navigationView.layer.masksToBounds = false
        navigationView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0,
                                                                           width: UIScreen.getDeviceWidth(),
                                                                           height: UIScreen.getNotchHeight()+58),
                                                       cornerRadius: navigationView.layer.cornerRadius).cgPath
    }
}


//MARK: Network
extension SearchResultVC{
    
    func refinePostResultData(data: DetailDataClass, type: String){
        postData = data.drive
        dump(postData)
        setContentViewConstraint()
    }
    
    func postSearchPost(type: String){
        PostResultService.shared.postSearchKeywords(userId: "jieun1211",
                                                    region: filterResultList[1],
                                                    theme: filterResultList[2],
                                                    warning: filterResultList[3],
                                                    type: type){ response in
            
            switch(response){
            case .success(let resultData):
                if let data =  resultData as? DetailModel{
                    DispatchQueue.global().sync {
                    self.refinePostResultData(data: data.data, type: type)
                    self.postCount = data.data.totalCourse
                    }
                    print(self.postData)
                        self.collectionView.reloadData()
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



extension SearchResultVC: UITableViewDelegate{
    
}
extension SearchResultVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: HotDropDownTVC = tableView.dequeueReusableCell(for: indexPath)
            var bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.mainBlue.withAlphaComponent(0.2)
            cell.selectedBackgroundView = bgColorView
            cell.setLabel()
            cell.setCellName(name: "인기순")
            print("실행됨")
            cell.delegate = self
            return cell

        case 1:
            let cell: HotDropDownTVC = tableView.dequeueReusableCell(for: indexPath)
            var bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.mainBlue.withAlphaComponent(0.2)
            cell.selectedBackgroundView = bgColorView
            print("실행됨")
            cell.setLabel()
            cell.setCellName(name: "최신순")
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}
    
extension SearchResultVC: SetTitleDelegate{
    func setTitle(cell: HotDropDownTVC) {
        if cell.name == "인기순"{
            print("인기순 실행")
            GetMyPageDataService.URL = Constants.myPageLikeURL
            postSearchPost(type: "like")
            postCount = postData.count
            self.dropDownTableView.isHidden = true
            topCVCCell?.setTitle(data: "인기순")
        }
        
        else if cell.name == "최신순"{
            print("최신순 실행")
            GetMyPageDataService.URL = Constants.myPageNewURL
            postSearchPost(type: "new")
            postCount = postData.count
            self.dropDownTableView.isHidden = true
            topCVCCell?.setTitle(data: "최신순")
            
        }
    }
}
extension SearchResultVC: MenuClickedDelegate {
    func menuClicked(){
        print("딜리게이트 실행됨?")
        dropDownTableView.isHidden = false
    }
}
