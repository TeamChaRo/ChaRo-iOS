//
//  OtherMyPageVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/12/22.
//

import UIKit
import SnapKit
import Then

class OtherMyPageVC: UIViewController {
    
    private var userProfileData: [UserInformation] = []
    private var writenPostDriveData: [MyPageDrive] = []
    
    let userWidth = UIScreen.main.bounds.width
    let userheight = UIScreen.main.bounds.height
    
    var currentState: String = "인기순"
    var isFollow: Bool = false
    var followerNum: Int = 0
    var followingNum: Int = 0
    var updateFollowNum: Bool = false
    
    let myId = UserDefaults.standard.string(forKey: "userId") ?? "ios@gmail.com"
    var otherUserID: String = "and@naver.com"
    
    var lastId: Int = 0
    var lastFavorite: Int = 0
    var isLast: Bool = false
    var scrollTriger: Bool = false
    var lottieView = IndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var delegate: AnimateIndicatorDelegate?

    //헤더뷰 유아이
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 3
        $0.image = ImageLiterals.imgMypageDefaultProfile
        $0.layer.cornerRadius = 32
    }
    private let headerBackgroundView = UIView().then {
        $0.backgroundColor = UIColor.mainBlue
    }

    private let headerTitleLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = UIFont.notoSansMediumFont(ofSize: 17)
        $0.text = "MY PAGE"
    }
    
    private var isFollowButton = UIButton()
    
    private let userNameLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = UIFont.notoSansBoldFont(ofSize: 18)
        $0.textAlignment = .left
        $0.text = "none 드라이버님"
    }
    
    private let followerButton = UIButton().then {
        $0.backgroundColor = .none
        $0.setTitle("팔로워", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
        $0.titleLabel?.textColor = UIColor.white
        $0.contentHorizontalAlignment = .left
    }
    
    private let followerNumButton = UIButton().then {
        $0.backgroundColor = .none
        $0.setTitle("0", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
        $0.titleLabel?.textColor = UIColor.white
        $0.contentHorizontalAlignment = .left
    }
    
    private let followButton = UIButton().then {
        $0.backgroundColor = .none
        $0.setTitle("팔로잉", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
        $0.titleLabel?.textColor = UIColor.white
        $0.contentHorizontalAlignment = .left
    }
    
    private let followNumButton = UIButton().then {
        $0.backgroundColor = .none
        $0.setTitle("0", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
        $0.titleLabel?.textColor = UIColor.white
        $0.contentHorizontalAlignment = .left
    }
    private let backButton = UIButton().then {
        $0.setBackgroundImage(ImageLiterals.icBackWhite, for: .normal)
        $0.addTarget(self, action: #selector(backButtonClicked(_:)), for: .touchUpInside)
    }
    //컬렉션 뷰
    private let collectionBackgroundView = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    private let noDataImageView = UIImageView().then{
        $0.image = ImageLiterals.imgMypageEmpty
    }
    private var collectionview: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.backgroundColor = .none
        collectionView.bounces = true
        return collectionView
    }()
    //인기순 최신순 필터
    private let filterView = FilterView()

    
    
    //MARK: viewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderViewLayout()
        setCollectionviewLayout()
        setFilterViewLayout()
        setFilterViewCompletion()
        getMypageData()
        getFollowData()
        isFollowButtonAddTarget()
        setFollowButtonUI()
        self.dismissDropDownWhenTappedAround()
        setButtonTarget()
    }
    
    func isFollowButtonAddTarget() {
        isFollowButton.addTarget(self, action: #selector(doFollowButtonClicked(_:)), for: .touchUpInside)
    }
    
    func setButtonTarget() {
        followerButton.addTarget(self, action: #selector(followerButtonClicked(_:)), for: .touchUpInside)
        followButton.addTarget(self, action: #selector(followingButtonClicked(_:)), for: .touchUpInside)
    }
    //MARK: setUI
    
    func setCollectionviewLayout() {
        self.view.addSubview(collectionBackgroundView)
        collectionBackgroundView.addSubview(collectionview)
        collectionview.delegate = self
        collectionview.dataSource = self
        
        collectionview.registerCustomXib(xibName: "MyPagePostCVC")
        collectionview.registerCustomXib(xibName: "HomePostDetailCVC")
        
        collectionBackgroundView.snp.makeConstraints {
            $0.top.equalTo(headerBackgroundView.snp.bottom).offset(0)
            $0.leading.trailing.bottom.equalToSuperview().offset(0)
        }
        
        collectionview.snp.makeConstraints{
            $0.top.equalToSuperview().offset(0)
            $0.leading.trailing.bottom.equalToSuperview().offset(0)
        }
    }
    
    func setHeaderViewLayout() {
        self.view.addSubview(headerBackgroundView)
        headerBackgroundView.addSubviews([profileImageView,headerTitleLabel,userNameLabel, isFollowButton, followButton, followNumButton, followerButton, followerNumButton, backButton])
        
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
        //isFollowButton
        isFollowButton.snp.makeConstraints{
            $0.width.equalTo(60)
            $0.height.equalTo(25)
            $0.top.equalTo(headerTitleLabel.snp.bottom).offset(34)
            $0.centerY.equalTo(userNameLabel)
            $0.leading.equalTo(userNameLabel.snp.trailing).offset(12)
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
        //뒤로가기 버튼
        backButton.snp.makeConstraints{
            $0.width.height.equalTo(48)
            $0.leading.equalToSuperview().offset(0)
            $0.centerY.equalTo(headerTitleLabel)
        }
    
    }
//MARK: filterTableView
        func setFilterViewLayout() {
            self.view.addSubview(filterView)
            filterView.isHidden = true
            filterView.snp.makeConstraints{
                $0.top.equalTo(headerBackgroundView.snp.bottom).offset(49)
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
                    GetMyPageDataService.URL = Constants.myPageLikeURL
                case 1:
                    self.currentState = "최신순"
                    GetMyPageDataService.URL = Constants.myPageNewURL
                default:
                    print("Error")
                }
                self.writenPostDriveData = []
                self.getMypageData()
                self.collectionview.reloadData()
                self.filterView.isHidden = true
                return index
            }
        }
    //MARK: function
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let writeContentHeight = collectionview.contentSize.height
        
        if(collectionview.contentOffset.y > writeContentHeight - collectionview.frame.height) {
            let lastcount = writenPostDriveData.count
            var likeOrNew = ""
            var addURL = ""
            if lastcount > 0 && scrollTriger == false {
            scrollTriger = true
            lastId = writenPostDriveData[lastcount-1].postID
            lastFavorite = writenPostDriveData[lastcount-1].favoriteNum
            
            if currentState == "인기순"{
                //print(lastId , "라스트 아이디", lastFavorite, "라스트 페이브릿" , "인기순")
                likeOrNew = "like/"
                addURL = "/write/\(lastId)/\(lastFavorite)"
                //이거 릴리즈전에는 지울건데 지금은 더미가 부족해서 테스트 용으로 잠시 주석처리해놨슴니당 무한으로 즐기는 스크롤
                //MypageInfinityService.addURL = "/write/11/0"
                getInfinityData(addUrl: addURL, LikeOrNew: likeOrNew)

            } else if currentState == "최신순"{
                //print(lastId , "라스트 아이디", lastFavorite, "라스트 페이브릿", "최신순")
                likeOrNew = "new/"
                addURL = "/write/\(lastId)"
                //MypageInfinityService.addURL = "/write/5/0"
                getInfinityData(addUrl: addURL, LikeOrNew: likeOrNew)
            }
                
            }
        }
        
        if(collectionview.contentOffset.y < writeContentHeight - collectionview.frame.height) {scrollTriger = false
        }
    }
    
    func setOtherUserID(userID: String) {
        otherUserID = userID
    }
    func setFollowButtonUI() {
        isFollowButton.backgroundColor = isFollowButton.isSelected ? UIColor.white : .clear
        isFollowButton.layer.cornerRadius = 13
        isFollowButton.layer.borderColor = UIColor.white.cgColor
        isFollowButton.layer.borderWidth = 1
        isFollowButton.setTitleColor(isFollowButton.isSelected ? UIColor.mainBlue : UIColor.white, for: .normal)
        isFollowButton.setTitle(isFollowButton.isSelected ? "팔로잉" : "팔로우", for: .normal)
        isFollowButton.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 13)
    }
    func setHeaderData(){
        followerNum = userProfileData[0].follower
        followingNum = userProfileData[0].following
        guard let url = URL(string: userProfileData[0].profileImage) else { return }
        userNameLabel.text = userProfileData[0].nickname
        profileImageView.kf.setImage(with: url)
        followerNumButton.setTitle(String(followerNum), for: .normal)
        followNumButton.setTitle(String(followingNum), for: .normal)
    }
    func isNoData() {
        collectionBackgroundView.addSubview(noDataImageView)
        
        noDataImageView.isHidden = true
        
        noDataImageView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview().offset(0)
            $0.width.equalTo(userWidth)
            $0.height.equalTo(259)
        }
      
        if writenPostDriveData.isEmpty == true {
            noDataImageView.isHidden = false
        }
      
    }
    
    @objc private func doFollowButtonClicked(_ sender: UIButton) {
        postFollowUser()
    }
    
    @objc private func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func followerButtonClicked(_ sender: UIButton) {
        guard let followVC = UIStoryboard(name: "FollowFollowing", bundle: nil).instantiateViewController(withIdentifier: "FollowFollwingVC") as? FollowFollwingVC else {return}
        followVC.setData(userName: userProfileData[0].nickname, isFollower: true, userID: otherUserID)
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(followVC, animated: true)
     }
    
    @objc private func followingButtonClicked(_ sender: UIButton) {
        guard let followVC = UIStoryboard(name: "FollowFollowing", bundle: nil).instantiateViewController(withIdentifier: "FollowFollwingVC") as? FollowFollwingVC else {return}
            followVC.setData(userName: userProfileData[0].nickname, isFollower: false, userID: otherUserID)
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(followVC, animated: true)
     }
    
    //MARK: Server
    //마이페이지 데이터 받아오는 함수
        func getMypageData() {
            GetMyPageDataService.URL = Constants.otherMyPageURL + otherUserID
            GetMyPageDataService.MyPageData.getRecommendInfo{ (response) in
                       switch response
                       {
                       case .success(let data) :
                           if let response = data as? MyPageDataModel {
                               self.userProfileData = []
                               //팔로우 수만 업데이트 할때
                               if self.updateFollowNum == false {self.writenPostDriveData = []}
                               self.userProfileData.append(response.data.userInformation)
                               self.writenPostDriveData.append(contentsOf: response.data.writtenPost.drive)
                               if self.updateFollowNum == false {self.collectionview.reloadData()}
                               self.setHeaderData()
                               
                               if self.writenPostDriveData.isEmpty == true {
                                   self.isNoData()
                                   
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
    func getFollowData() {
        FollowCheckService.followData.getRecommendInfo(userId: myId, otherId: otherUserID) { (response) in
                   switch response
                   {
                   case .success(let data):
                       if let response = data as? DoFollowDataModel {
                           self.isFollow = response.data.isFollow
                           if self.isFollow == true {
                               self.isFollowButton.isSelected = true
                               self.setFollowButtonUI()
                           } else {
                               self.isFollowButton.isSelected = false
                               self.setFollowButtonUI()
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
    
    
    func getInfinityData(addUrl: String, LikeOrNew: String) {
        updateFollowNum = false
        delegate = self
        self.delegate?.startIndicator()
        MypageInfinityService.MyPageInfinityData.getRecommendInfo(userID: otherUserID, addURL: addUrl,likeOrNew: LikeOrNew) { (response) in
                   switch response
                   {
                   case .success(let data) :
                       if let response = data as? MypageInfinityModel {
                           if response.data.lastID == 0{
                               self.isLast = true
                               self.delegate?.endIndicator()
                           } else {
                               self.isLast = false
                           }
                           if self.isLast == false {
                               self.writenPostDriveData.append(contentsOf: response.data.drive)
                               self.collectionview.reloadData()
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
        self.delegate?.endIndicator()
    }
    func postFollowUser() {
        self.updateFollowNum = true
        delegate = self
        self.delegate?.startIndicator()
        DoFollowService.shared.followService(follower: myId, followed: otherUserID) { result in
            switch result {
            case .success(let data):
                if let response = data as? DoFollowDataModel {
                    self.isFollow = response.data.isFollow
                    if self.isFollow == false{
                        self.isFollowButton.isSelected = false
                        self.setFollowButtonUI()
                        self.getMypageData()
                    } else {
                        self.isFollowButton.isSelected = true
                        self.setFollowButtonUI()
                        self.getMypageData()
                    }
                    
                }
            case .requestErr(let message):
                print(message)
            case .serverErr:
                print("서버에러")
            case .networkFail:
                print("네트워크에러")
            default:
                print("에러임니다")
            }
        }
        self.delegate?.endIndicator()
    }
}


//MARK: Extension
extension OtherMyPageVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellCount = 0
        
        if(writenPostDriveData.count == 0) {
            cellCount = 0
        }
        else {
            cellCount = writenPostDriveData.count + 1
        }
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPagePostCVC.identifier, for: indexPath) as! MyPagePostCVC
        let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier:HomePostDetailCVC.identifier , for: indexPath) as! HomePostDetailCVC
        detailCell.delegate = self
        detailCell.setSelectName(name: currentState)
    
        if(indexPath.row == 0){
            return detailCell
        } else {
            let writenElement = writenPostDriveData[indexPath.row-1]
            var writenTags = [writenElement.region, writenElement.theme,
                        writenElement.warning ?? ""] as [String]
        cell.setData(image: writenPostDriveData[indexPath.row-1].image,
                     title: writenPostDriveData[indexPath.row-1].title,
                     tagCount:writenTags.count, tagArr: writenTags,
                     heart:writenPostDriveData[indexPath.row-1].favoriteNum,
                     save: writenPostDriveData[indexPath.row-1].saveNum,
                     year: writenPostDriveData[indexPath.row-1].year,
                     month: writenPostDriveData[indexPath.row-1].month,
                     day: writenPostDriveData[indexPath.row-1].day,
                     postID: writenPostDriveData[indexPath.row-1].postID)
        return cell
        
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = PostDetailVC()
        if indexPath.row > 0{
            //detailVC.setPostId(id: writenPostDriveData[indexPath.row-1].postID)
            detailVC.setAdditionalDataOfPost(data: DriveElement.init(
                postID: writenPostDriveData[indexPath.row-1].postID,
                title: writenPostDriveData[indexPath.row-1].title,
                image: writenPostDriveData[indexPath.row-1].image,
                region: writenPostDriveData[indexPath.row-1].region,
                theme: writenPostDriveData[indexPath.row-1].theme,
                warning: writenPostDriveData[indexPath.row-1].warning,
                year: writenPostDriveData[indexPath.row-1].year,
                month: writenPostDriveData[indexPath.row-1].month,
                day: writenPostDriveData[indexPath.row-1].day,
                isFavorite: writenPostDriveData[indexPath.row-1].isFavorite))
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
    
}
extension OtherMyPageVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0{
            return CGSize(width: userWidth-35, height: 42)
        } else {
        return CGSize(width: collectionView.frame.width, height: 100)
        }
    }
    
}
extension OtherMyPageVC: UICollectionViewDelegateFlowLayout {
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
extension OtherMyPageVC{
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
extension OtherMyPageVC: MenuClickedDelegate{
    func menuClicked(){
        filterView.isHidden = false
    }
}
extension OtherMyPageVC: AnimateIndicatorDelegate {
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
