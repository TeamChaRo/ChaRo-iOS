//
//  MyPageVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/10.
//

import UIKit
import Lottie
import SnapKit
import Then
import Kingfisher

class MyPageVC: UIViewController {
//MARK: VAR
    //var
    let userWidth = UIScreen.main.bounds.width
    let userheight = UIScreen.main.bounds.height
    var tabbarBottomConstraint: Int = 0
    
    private var userProfileData: [UserInformation] = []
    //var writenPostData: [MyPagePost] = []
    private var writenPostDriveData: [MyPageDrive] = []
    private var savePostDriveData: [MyPageDrive] = []
    
    
    let filterTableView = NewHotFilterView(frame: CGRect(x: 0, y: 0, width: 180, height: 97))
    var currentState: String = "인기순"
    
    //무한스크롤을 위함
    var myId: String = UserDefaults.standard.string(forKey: "userId") ?? "ios@gmail.com"
    var lastId: Int = 0
    var lastFavorite: Int = 0
    var isLast: Bool = false
    var scrollTriger: Bool = false
    var lottieView = IndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var delegate: AnimateIndicatorDelegate?
    
    //headerView
    private let profileImageView = UIImageView().then{
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 3
        $0.image = UIImage(named: "myimage")
        $0.layer.cornerRadius = 32
    }
    private let headerBackgroundView = UIView().then{
        $0.backgroundColor = UIColor.mainBlue
    }
    //팔로우 버튼하나 추가 하고, 밑에 컬뷰 하나 넣고 끝 내일 마무리 치기


    private let headerTitleLabel = UILabel().then{
        $0.textColor = UIColor.white
        $0.font = UIFont.notoSansMediumFont(ofSize: 17)
        $0.text = "MY PAGE"
    }
    
    private let settingButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "setting2_white"), for: .normal)
        $0.addTarget(self, action: #selector(settingButtonClicked(_:)), for: .touchUpInside)

    }
    
    private let userNameLabel = UILabel().then{
        $0.textColor = UIColor.white
        $0.font = UIFont.notoSansBoldFont(ofSize: 18)
        $0.textAlignment = .left
        $0.text = "none 드라이버님"
    }
    
    private let followerButton = UIButton().then{
        $0.backgroundColor = .none
        $0.setTitle("팔로워", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
        $0.titleLabel?.textColor = UIColor.white
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(followerButtonClicked(_:)), for: .touchUpInside)
    }
    
    private let followerNumButton = UIButton().then{
        $0.backgroundColor = .none
        $0.setTitle("0", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
        $0.titleLabel?.textColor = UIColor.white
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(followerButtonClicked(_:)), for: .touchUpInside)
    }
    
    private let followButton = UIButton().then{
        $0.backgroundColor = .none
        $0.setTitle("팔로잉", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
        $0.titleLabel?.textColor = UIColor.white
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(followingButtonClicked(_:)), for: .touchUpInside)
    }
    
    private let followNumButton = UIButton().then{
        $0.backgroundColor = .none
        $0.setTitle("0", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
        $0.titleLabel?.textColor = UIColor.white
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(followingButtonClicked(_:)), for: .touchUpInside)
    }

    
    //tabbarUI
    private let tabbarBackgroundView = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    private let tabbarWriteButton = UIButton().then{
        $0.setImage(UIImage(named: "write_active"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.addTarget(self, action: #selector(saveButtonClicked(_:)), for: .touchUpInside)
    }
    private let tabbarSaveButton = UIButton().then{
        $0.setImage(UIImage(named: "save_inactive"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.addTarget(self, action: #selector(writeButtonClicked(_:)), for: .touchUpInside)
    }
    private let tabbarBottomView = UIView().then{
        $0.backgroundColor = UIColor.gray20
    }
    private let tabbarWriteBottomView = UIView().then{
        $0.backgroundColor = UIColor.mainBlue
    }
    private let tabbarSaveBottomView = UIView().then{
        $0.backgroundColor = .none
    }
    
    
    //collectionView
    private let collectionScrollView = UIScrollView().then{
        
        let userHeigth = UIScreen.main.bounds.height
        
        $0.tag = 1
        $0.isPagingEnabled = true
        $0.bounces = false
        $0.contentSize.width = UIScreen.main.bounds.width
        
        //아무튼 아이폰 12에서는 잘 돌아가는데 이거 기기마다 테스트 매우 필요한 항목일듯요,, 스크롤뷰랑 컬렉션뷰의 설정된 heigth가 조금이라도 다르면 화면 지혼자 휙휙 돌아감...이걸 우짠담..제발 다른기기에서도 잘 돌아갔으면 좋겟다 제발 제발 제발 제발 제발 제발
        $0.contentSize = CGSize(width: UIScreen.main.bounds.width*2, height: userHeigth - (userHeigth * 0.27 + 151))
        $0.backgroundColor = UIColor.white
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
    }
    private let writeView = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    private let saveView = UIView().then{
        $0.backgroundColor = UIColor.white
    }

    private var writeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.backgroundColor = UIColor.white
        collectionView.bounces = true
        return collectionView
    }()
    private var saveCollectioinView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.backgroundColor = UIColor.white
        collectionView.bounces = true
        return collectionView
    }()
    
//MARK: ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderLayout()
        setTabbarLayout()
        setCollectionViewLayout()
//        getMypageData()
        filterTableViewLayout()
        self.dismissDropDownWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMypageData()
    }
    
//MARK: function
    //탭바 쉬트 이동 및 버튼클릭시 애니메이션
    func setTabbarBottomViewMove(){
        var contentOffsetX = collectionScrollView.contentOffset.x
        tabbarWriteBottomView.snp.remakeConstraints{
            $0.leading.equalTo(collectionScrollView.contentOffset.x / 2)
            $0.bottom.equalTo(tabbarBottomView.snp.top).offset(0)
            $0.width.equalTo(userWidth/2)
            $0.height.equalTo(2)
        }
        if contentOffsetX > userWidth/3{
            tabbarWriteButton.setImage(UIImage(named: "write_inactive"), for: .normal)
            tabbarSaveButton.setImage(UIImage(named: "save_active"), for: .normal)
        }
        else{
            tabbarWriteButton.setImage(UIImage(named: "write_active"), for: .normal)
            tabbarSaveButton.setImage(UIImage(named: "save_inactive"), for: .normal)
        }
    }
    
    func setHeaderData(){
        guard let url = URL(string: userProfileData[0].profileImage) else { return }
        userNameLabel.text = userProfileData[0].nickname
        profileImageView.kf.setImage(with: url)
        followerNumButton.setTitle(String(userProfileData[0].follower), for: .normal)
        followNumButton.setTitle(String(userProfileData[0].following), for: .normal)
    }
//MARK: Server
//마이페이지 데이터 받아오는 함수
    func getMypageData(){
        GetMyPageDataService.URL = Constants.myPageLikeURL
        GetMyPageDataService.MyPageData.getRecommendInfo{ (response) in
                   switch response
                   {
                   case .success(let data) :
                       if let response = data as? MyPageDataModel{
                           self.userProfileData = []
                           self.writenPostDriveData = []
                           self.savePostDriveData = []
                           self.userProfileData.append(response.data.userInformation)
                           self.writenPostDriveData.append(contentsOf: response.data.writtenPost.drive)
                           self.savePostDriveData.append(contentsOf: response.data.savedPost.drive)
                           self.setHeaderData()
                           self.writeCollectionView.reloadData()
                           self.saveCollectioinView.reloadData()
                       }
                   case .requestErr(let message) :
                       print("requestERR")
                   case .pathErr :
                       print("pathERR")
                   case .serverErr:
                       print("serverERR")
                   case .networkFail:
                       print("networkFail")
                   }
               }
    }
    
    func getInfinityData(addUrl: String, LikeOrNew: String){
        delegate = self
        self.delegate?.startIndicator()
        MypageInfinityService.MyPageInfinityData.getRecommendInfo(userID: myId, addURL: addUrl,likeOrNew: LikeOrNew){ (response) in
                   switch response
                   {
                   case .success(let data) :
                       if let response = data as? MypageInfinityModel{
                           if response.data.lastID == 0{
                               self.isLast = true
                               self.delegate?.endIndicator()
                           }
                           else{
                               self.isLast = false
                           }
                           if self.isLast == false{
                               self.writenPostDriveData.append(contentsOf: response.data.drive)
                               self.writeCollectionView.reloadData()
                               self.saveCollectioinView.reloadData()
                               self.delegate?.endIndicator()
                           }

                       }
                   case .requestErr(let message) :
                       print("requestERR")
                   case .pathErr :
                       print("pathERR")
                   case .serverErr:
                       print("serverERR")
                   case .networkFail:
                       print("networkFail")
                   }
               }
    }



//MARK: buttonClicked
   @objc private func saveButtonClicked(_ sender: UIButton){
       collectionScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
       tabbarWriteButton.setImage(UIImage(named: "write_active"), for: .normal)
       tabbarSaveButton.setImage(UIImage(named: "save_inactive"), for: .normal)
    }
    @objc private func writeButtonClicked(_ sender: UIButton){
        collectionScrollView.setContentOffset(CGPoint(x: userWidth, y: 0), animated: true)
        tabbarWriteButton.setImage(UIImage(named: "write_inactive"), for: .normal)
        tabbarSaveButton.setImage(UIImage(named: "save_active"), for: .normal)
     }
    @objc private func settingButtonClicked(_ sender: UIButton){
        guard let setVC = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as? SettingVC else {return}
        
        self.navigationController?.pushViewController(setVC, animated: true)
     }
    @objc private func followerButtonClicked(_ sender: UIButton){
        guard let followVC = UIStoryboard(name: "FollowFollowing", bundle: nil).instantiateViewController(withIdentifier: "FollowFollwingVC") as? FollowFollwingVC else {return}
        followVC.setData(userName: userProfileData[0].nickname, isFollower: true, userID: myId)
        self.navigationController?.pushViewController(followVC, animated: true)
        
     }
    @objc private func followingButtonClicked(_ sender: UIButton){
        guard let followVC = UIStoryboard(name: "FollowFollowing", bundle: nil).instantiateViewController(withIdentifier: "FollowFollwingVC") as? FollowFollwingVC else {return}
        followVC.setData(userName: userProfileData[0].nickname, isFollower: false, userID: myId)
        self.navigationController?.pushViewController(followVC, animated: true)
     }
//MARK: ScrollViewdidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let writeContentHeigth = writeCollectionView.contentSize.height
        let saveContentHeigth = saveCollectioinView.contentSize.height
        
        if(collectionScrollView.contentOffset.x > 0 && collectionScrollView.contentOffset.y < 0){
            collectionScrollView.contentOffset.y = 0
        }
        //바텀뷰 이동
        setTabbarBottomViewMove()
        //아래 스크롤 방지
        if collectionScrollView.contentOffset.y > 0{
            collectionScrollView.contentOffset.y = 0
        }
        //위스크롤 방지
        if collectionScrollView.contentOffset.y > writeCollectionView.contentSize.height
        {
            collectionScrollView.contentOffset.y = 0;
        }
        //옆스크롤 방지
        if collectionScrollView.contentOffset.x < 0{
            collectionScrollView.contentOffset.x = 0;
        }
        //작성글 무한스크롤
        if(writeCollectionView.contentOffset.y > writeContentHeigth - writeCollectionView.frame.height){
            let lastcount = writenPostDriveData.count
            var likeOrNew = ""
            var addURL = ""
            if lastcount > 0 && scrollTriger == false{
            scrollTriger = true
            lastId =  writenPostDriveData[lastcount-1].postID
            lastFavorite = writenPostDriveData[lastcount-1].favoriteNum
            
            if currentState == "인기순"{
                //print(lastId , "라스트 아이디", lastFavorite, "라스트 페이브릿" , "인기순")
                likeOrNew = "like/"
                addURL = "/write/\(lastId)/\(lastFavorite)"
                //이거 릴리즈전에는 지울건데 지금은 더미가 부족해서 테스트 용으로 잠시 주석처리해놨슴니당 무한으로 즐기는 스크롤
                //MypageInfinityService.addURL = "/write/11/0"
                getInfinityData(addUrl: addURL, LikeOrNew: likeOrNew)

            }
            else if currentState == "최신순"{
                //print(lastId , "라스트 아이디", lastFavorite, "라스트 페이브릿", "최신순")
                likeOrNew = "new/"
                addURL = "/write/\(lastId)"
                //MypageInfinityService.addURL = "/write/5/0"
                getInfinityData(addUrl: addURL, LikeOrNew: likeOrNew)
            }
                
            }
        }
        //저장글 무한스크롤
        else if(saveCollectioinView.contentOffset.y > saveContentHeigth - saveCollectioinView.frame.height){
            let lastcount = savePostDriveData.count
            var likeOrNew = ""
            var addURL = ""
            
            if lastcount > 0 && scrollTriger == false{
                scrollTriger = true
            lastId =  savePostDriveData[lastcount-1].postID
            lastFavorite = savePostDriveData[lastcount-1].favoriteNum
            
            if currentState == "인기순"{
                //print(lastId , "라스트 아이디", lastFavorite, "라스트 페이브릿" , "인기순")
                likeOrNew = "like/"
                addURL = "/write/\(lastId)/\(lastFavorite)"
                //이거 릴리즈전에는 지울건데 지금은 더미가 부족해서 테스트 용으로 잠시 주석처리해놨슴니당 무한으로 즐기는 스크롤
                //MypageInfinityService.addURL = "/write/5/0"
                getInfinityData(addUrl: addURL, LikeOrNew: likeOrNew)
            }
            else if currentState == "최신순"{
                //print(lastId , "라스트 아이디", lastFavorite, "라스트 페이브릿", "최신순")
                likeOrNew = "new/"
                addURL = "/write/\(lastId)"
                //MypageInfinityService.addURL = "/write/5/0"
                getInfinityData(addUrl: addURL, LikeOrNew: likeOrNew)
            }
            
        }
        }
        
        if(writeCollectionView.contentOffset.y < writeContentHeigth - writeCollectionView.frame.height){scrollTriger = false}
        if(saveCollectioinView.contentOffset.y < saveContentHeigth - saveCollectioinView.frame.height){scrollTriger = false}
        
        
    }
//MARK: filterTableView
    func filterTableViewLayout(){
        filterTableView.delegate = self
        filterTableView.clickDelegate = self
        filterTableView.isHidden = true
        self.view.addSubview(filterTableView)
        filterTableView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(310)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(97)
            $0.width.equalTo(180)
        }
    }
//MARK: CollectionViewLayout
    func setCollectionViewLayout(){
        
        let collectionviewHeight  = userheight - (userheight * 0.27 + 130)
                
        collectionScrollView.delegate = self
        writeCollectionView.delegate = self
        writeCollectionView.dataSource = self
        saveCollectioinView.delegate = self
        saveCollectioinView.dataSource = self
        
        writeCollectionView.tag = 1
        saveCollectioinView.tag = 2
        
        writeCollectionView.registerCustomXib(xibName: "MyPagePostCVC")
        saveCollectioinView.registerCustomXib(xibName: "MyPagePostCVC")
        writeCollectionView.registerCustomXib(xibName: "HomePostDetailCVC")
        saveCollectioinView.registerCustomXib(xibName: "HomePostDetailCVC")
             
        
        self.view.addSubview(collectionScrollView)
        collectionScrollView.addSubview(writeView)
        collectionScrollView.addSubview(saveView)
        writeView.addSubview(writeCollectionView)
        saveView.addSubview(saveCollectioinView)
        
       
        collectionScrollView.snp.makeConstraints{
            $0.top.equalTo(tabbarBottomView.snp.bottom).offset(0)
            $0.trailing.equalTo(view).offset(0)
            $0.leading.equalTo(view).offset(0)
            $0.bottom.equalTo(view).offset(0)
        }
        writeView.snp.makeConstraints{
            $0.top.equalTo(collectionScrollView.snp.top).offset(0)
            $0.leading.equalTo(collectionScrollView.snp.leading).offset(0)
            $0.width.equalTo(userWidth)
            $0.height.equalTo(collectionviewHeight)
        }
        writeCollectionView.snp.makeConstraints{
            $0.top.equalTo(writeView.snp.top).offset(0)
            $0.bottom.equalTo(writeView.snp.bottom).offset(0)
            $0.leading.equalTo(writeView.snp.leading).offset(0)
            $0.trailing.equalTo(writeView.snp.trailing).offset(0)
        }
        saveView.snp.makeConstraints{
            $0.top.equalTo(collectionScrollView.snp.top).offset(0)
            $0.leading.equalTo(writeView.snp.trailing).offset(0)
            $0.width.equalTo(userWidth)
            $0.height.equalTo(collectionviewHeight)
        }
        saveCollectioinView.snp.makeConstraints{
            $0.top.equalTo(saveView.snp.top).offset(0)
            $0.bottom.equalTo(saveView.snp.bottom).offset(0)
            $0.leading.equalTo(saveView.snp.leading).offset(0)
            $0.trailing.equalTo(saveView.snp.trailing).offset(0)
        }
       
    }
//MARK: TabbarLayout
    func setTabbarLayout(){
        self.view.addSubview(tabbarBackgroundView)
        tabbarBackgroundView.addSubview(tabbarSaveButton)
        tabbarBackgroundView.addSubview(tabbarWriteButton)
        tabbarBackgroundView.addSubview(tabbarBottomView)
        tabbarBackgroundView.addSubview(tabbarWriteBottomView)
        tabbarBackgroundView.addSubview(tabbarSaveBottomView)
        
        tabbarBackgroundView.snp.makeConstraints{
            $0.top.equalTo(headerBackgroundView.snp.bottom).offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(50)
        }
        tabbarWriteButton.snp.makeConstraints{
            $0.top.equalTo(tabbarBackgroundView).offset(0)
            $0.leading.equalTo(tabbarBackgroundView).offset(0)
            $0.bottom.equalTo(tabbarBackgroundView).offset(0)
            $0.width.equalTo(userWidth/2)
        }
        tabbarSaveButton.snp.makeConstraints{
            $0.top.equalTo(tabbarBackgroundView).offset(0)
            $0.trailing.equalTo(tabbarBackgroundView).offset(0)
            $0.bottom.equalTo(tabbarBackgroundView).offset(0)
            $0.width.equalTo(userWidth/2)
        }
        tabbarBottomView.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(0)
            $0.width.equalTo(userWidth)
            $0.height.equalTo(1)
        }
        tabbarWriteBottomView.snp.makeConstraints{
            $0.bottom.equalTo(tabbarBottomView.snp.top).offset(0)
            $0.leading.equalToSuperview().offset(tabbarBottomConstraint)
            $0.width.equalTo(userWidth/2)
            $0.height.equalTo(2)
        }
        tabbarSaveBottomView.snp.makeConstraints{
            $0.bottom.equalTo(tabbarBottomView.snp.top).offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.width.equalTo(userWidth/2)
            $0.height.equalTo(2)
        }
        
        
    }
//MARK: HeaderViewLayout
    
    func setHeaderLayout(){
        self.view.addSubview(headerBackgroundView)
        headerBackgroundView.addSubview(profileImageView)
        headerBackgroundView.addSubview(headerTitleLabel)
        headerBackgroundView.addSubview(userNameLabel)
        headerBackgroundView.addSubview(settingButton)
        headerBackgroundView.addSubview(followButton)
        headerBackgroundView.addSubview(followNumButton)
        headerBackgroundView.addSubview(followerButton)
        headerBackgroundView.addSubview(followerNumButton)
        
        let headerViewHeight = userheight * 0.27
        
        //backgroundView
        headerBackgroundView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(headerViewHeight)
        }
        //MYPAGELabel
        headerTitleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(58)
            $0.centerX.equalToSuperview()
        }
        //settingButton
        settingButton.snp.makeConstraints{
            $0.width.equalTo(48)
            $0.height.equalTo(48)
            $0.top.equalToSuperview().offset(58)
            $0.centerY.equalTo(headerTitleLabel)
            $0.trailing.equalToSuperview().offset(-6)
        }
        //profileImage
        profileImageView.snp.makeConstraints{
            $0.width.equalTo(62)
            $0.height.equalTo(62)
            $0.leading.equalToSuperview().offset(27)
            $0.top.equalTo(headerTitleLabel.snp.bottom).offset(29)
        }
        //userName
        userNameLabel.snp.makeConstraints{
            $0.leading.equalTo(profileImageView.snp.trailing).offset(27)
            $0.top.equalTo(headerTitleLabel.snp.bottom).offset(34)
            $0.width.equalTo(180)
        }
        //followerButton
        followerButton.snp.makeConstraints{
            $0.top.equalTo(userNameLabel.snp.bottom).offset(11)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(27)
            $0.width.equalTo(45)
        }
        //followerNumButton
        followerNumButton.snp.makeConstraints{
            $0.centerY.equalTo(followerButton)
            $0.leading.equalTo(followerButton.snp.trailing).offset(3)
            $0.width.equalTo(25)
        }
        //followButton
        followButton.snp.makeConstraints{
            $0.centerY.equalTo(followerButton)
            $0.leading.equalTo(followerNumButton.snp.trailing).offset(21)
            $0.width.equalTo(45)
        }
        //followNumButton
        followNumButton.snp.makeConstraints{
            $0.centerY.equalTo(followButton)
            $0.leading.equalTo(followButton.snp.trailing).offset(3)
            $0.width.equalTo(25)
        }
    }
    
}


extension MyPageVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0{
            return CGSize(width: userWidth-35, height: 42)
        }
        else{
        return CGSize(width: collectionView.frame.width, height: 100)
        }
    }
    

    
}
//MARK: Extension
extension MyPageVC: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard(name: "PostDetail", bundle: nil).instantiateViewController(withIdentifier: PostDetailVC.identifier) as? PostDetailVC else {return}
        var driveData = MyPageDrive()
        //내가 작성한 글 태그 = 1 / 저장한 글 컬렉션 뷰 태그 = 2
        if indexPath.row > 0{
        if collectionView.tag == 1{
            detailVC.setPostId(id: writenPostDriveData[indexPath.row-1].postID)
            driveData = writenPostDriveData[indexPath.row-1]
        }
        else{
            detailVC.setPostId(id: savePostDriveData[indexPath.row-1].postID)
                driveData = savePostDriveData[indexPath.row-1]
        }
        detailVC.setAdditionalDataOfPost(data: DriveElement(
                                    postID: driveData.postID,
                                    title: driveData.title,
                                    image: driveData.image,
                                    region: driveData.region,
                                    theme: driveData.theme,
                                    warning: driveData.warning,
                                    year: driveData.year,
                                    month: driveData.month,
                                    day: driveData.day,
                                    isFavorite: driveData.isFavorite))
        }
        if indexPath.row > 0{
        self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var writeCellCount = 0
        var saveCellCount = 0
        
        if(writenPostDriveData.count == 0){
            writeCellCount = 1
        }
        else{
            writeCellCount = writenPostDriveData.count + 1
        }
        
        if(savePostDriveData.count == 0){
            saveCellCount = 1
        }
        else{
            saveCellCount = savePostDriveData.count + 1
        }
        
        switch collectionView.tag{
        case 1:
            return writeCellCount
        case 2:
            return saveCellCount
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: MyPagePostCVC.identifier, for: indexPath) as! MyPagePostCVC
        let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier:HomePostDetailCVC.identifier , for: indexPath) as! HomePostDetailCVC
        detailCell.delegate = self
        detailCell.setSelectName(name: currentState)
        switch collectionView.tag{
            
        case 1:
            if(indexPath.row == 0){
                detailCell.postCountLabel.text = ""
                return detailCell
            }
            else{
                let writenElement = writenPostDriveData[indexPath.row-1]
                var writenTags = [writenElement.region, writenElement.theme,
                            writenElement.warning ?? ""] as [String]
                print(writenPostDriveData, "왜 안뜨냐?")
            cell.setData(image: writenPostDriveData[indexPath.row-1].image, title: writenPostDriveData[indexPath.row-1].title, tagCount:writenTags.count, tagArr: writenTags, heart:writenPostDriveData[indexPath.row-1].favoriteNum, save: writenPostDriveData[indexPath.row-1].saveNum, year: writenPostDriveData[indexPath.row-1].year, month: writenPostDriveData[indexPath.row-1].month, day: writenPostDriveData[indexPath.row-1].day, postID: writenPostDriveData[indexPath.row-1].postID)
            return cell
            }
        case 2:
            if(indexPath.row == 0){
                detailCell.postCountLabel.text = ""
                return detailCell
            }
            
            else{
                let saveElement = savePostDriveData[indexPath.row-1]
                var saveTags = [saveElement.region, saveElement.theme, saveElement.warning ?? ""] as [String]
                
            cell.setData(image: savePostDriveData[indexPath.row-1].image, title: savePostDriveData[indexPath.row-1].title, tagCount:saveTags.count, tagArr: saveTags, heart:savePostDriveData[indexPath.row].favoriteNum, save: savePostDriveData[indexPath.row].saveNum, year: savePostDriveData[indexPath.row].year, month: savePostDriveData[indexPath.row].month, day: savePostDriveData[indexPath.row].day, postID: savePostDriveData[indexPath.row].postID)
            return cell
            }
        default:
            return UICollectionViewCell()
            
        }
    }
    
    
}
extension MyPageVC: UICollectionViewDelegateFlowLayout{
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


extension MyPageVC: MenuClickedDelegate{
    func menuClicked(){
        filterTableView.isHidden = false
    }
    
    
}
extension MyPageVC{
func dismissDropDownWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(dismissDropDown))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissDropDown() {
        self.filterTableView.isHidden = true
    }
}

extension MyPageVC: NewHotFilterClickedDelegate{
    func filterClicked(row: Int) {
        switch row {
        case 0:
            GetMyPageDataService.URL = Constants.myPageLikeURL
            getMypageData()
            currentState = "인기순"
            writeCollectionView.reloadData()
            saveCollectioinView.reloadData()
        default:
            GetMyPageDataService.URL = Constants.myPageNewURL
            getMypageData()
            currentState = "최신순"
            writeCollectionView.reloadData()
            saveCollectioinView.reloadData()
        }
    }
    

}
extension MyPageVC: AnimateIndicatorDelegate{
    func startIndicator() {
        view.addSubview(lottieView)
        lottieView.isHidden = false
        lottieView.lottieView.play()
    }

    func endIndicator() {
        lottieView.lottieView.stop()
        lottieView.isHidden = true
    }
}

