//
//  FollowFollwingVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/12/24.
//

import UIKit
import SnapKit
import Then

class FollowFollwingVC: UIViewController {
//MARK: VAR
    //var
    let userWidth = UIScreen.main.bounds.width
    let userheight = UIScreen.main.bounds.height
    var tabbarBottomConstraint: Int = 0
    
    let myId = UserDefaults.standard.string(forKey: "userId") ?? "ios@gmail.com"
    var otherUserID: String = "and@naver.com"

    var followerNum: Int = 0
    var followingNum: Int = 0
    
    var checkIsFollow: Bool = false
    var titleName: String = "none"
    var followDataList: [followData] = []
        
    //무한스크롤을 위함
    var lastId: Int = 0
    var lastFavorite: Int = 0
    var isLast: Bool = false
    var scrollTriger: Bool = false
    var lottieView = IndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var delegate: AnimateIndicatorDelegate?
    
    //headerView
    private let headerBackgroundView = UIView().then{
        $0.backgroundColor = UIColor.white
    }

    private let headerTitleLabel = UILabel().then{
        $0.textColor = UIColor.black
        $0.font = UIFont.notoSansMediumFont(ofSize: 17)
        $0.text = "none"
    }
    
    private let backButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "backIcon"), for: .normal)
        $0.addTarget(self, action: #selector(backButtonClicked(_:)), for: .touchUpInside)
    }

    //tabbarUI
    private let tabbarBackgroundView = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    private let followerButton = UIButton().then{
        $0.setTitle("팔로워", for: .normal)
        $0.setTitleColor(UIColor.mainBlue, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        $0.addTarget(self, action: #selector(followerButtonClicked(_:)), for: .touchUpInside)
    }
    private let followingButton = UIButton().then{
        $0.setTitle("팔로잉", for: .normal)
        $0.setTitleColor(UIColor.gray40, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        $0.addTarget(self, action: #selector(followingButtonClicked(_:)), for: .touchUpInside)
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

    //TableView
    private let tableScrollView = UIScrollView().then{
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
    private let followerTableView = UITableView()
    private let followingTableView = UITableView()

    private let followerView = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    private let followingView = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    
//MARK: viewDidLoad
    override func viewDidLoad(){
        setHeaderLayout()
        setTabbarLayout()
        setTableViewLayout()
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        getFollowData()
    }
//MARK: Func
    //데이터 삽입과, 팔로우 팔로잉 뷰 어떤거 띄워줄지 결정
    func setData(userName: String, isFollower: Bool, userID: String){
        otherUserID = userID
        headerTitleLabel.text = userName
        checkIsFollow = isFollower
        if isFollower == false {
            tableScrollView.setContentOffset(CGPoint(x: userWidth, y: 0), animated: true)
            followerButton.setTitleColor(UIColor.gray40, for: .normal)
            followingButton.setTitleColor(UIColor.mainBlue, for: .normal)
            tabbarBottomConstraint = Int(userWidth)
            tabbarSaveBottomView.backgroundColor = UIColor.mainBlue
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setTabbarBottomViewMove()
    }
    func setTabbarBottomViewMove(){
        var contentOffsetX = tableScrollView.contentOffset.x
        tabbarWriteBottomView.snp.remakeConstraints{
            tabbarSaveBottomView.backgroundColor = .none
            $0.leading.equalTo(tableScrollView.contentOffset.x / 2)
            $0.bottom.equalTo(tabbarBottomView.snp.top).offset(0)
            $0.width.equalTo(userWidth/2)
            $0.height.equalTo(2)
        }
        if contentOffsetX > userWidth/3{
            followerButton.setTitleColor(UIColor.gray40, for: .normal)
            followingButton.setTitleColor(UIColor.mainBlue, for: .normal)
        }
        else{
            followerButton.setTitleColor(UIColor.mainBlue, for: .normal)
            followingButton.setTitleColor(UIColor.gray40, for: .normal)
        }
        
    }
 
   @objc private func followerButtonClicked(_ sender: UIButton){
       tableScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
       followerButton.setTitleColor(UIColor.mainBlue, for: .normal)
       followingButton.setTitleColor(UIColor.gray40, for: .normal)
    }
    @objc private func followingButtonClicked(_ sender: UIButton){
        tableScrollView.setContentOffset(CGPoint(x: userWidth, y: 0), animated: true)
        followerButton.setTitleColor(UIColor.gray40, for: .normal)
        followingButton.setTitleColor(UIColor.mainBlue, for: .normal)
     }
    @objc private func backButtonClicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
     }
//MARK: ServerFunction
    func getFollowData(){
        GetFollowDataService.followData.getRecommendInfo(userId: myId, otherId: otherUserID){ (response) in
                   switch response
                   {
                   case .success(let data):
                       if let response = data as? GetFollowDataModel{
                           self.followDataList = []
                           self.followDataList.append(response.data)
                           self.followerButton.setTitle(String(response.data.follower.count) + " 팔로워", for: .normal)
                           self.followingButton.setTitle(String(response.data.following.count) + " 팔로잉", for: .normal)
                           self.followerTableView.reloadData()
                           self.followingTableView.reloadData()
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
   

//MARK: layoutFunction
    func setTableViewLayout(){
        
        let tableViewHeight  = userheight - (userheight * 0.15 + 130)
        
        tableScrollView.delegate = self
        followerTableView.delegate = self
        followerTableView.dataSource = self
        followingTableView.delegate = self
        followingTableView.dataSource = self
        followerTableView.separatorStyle = .none
        followingTableView.separatorStyle = .none

        followerTableView.tag = 1
        followingTableView.tag = 2
        
        followerTableView.registerCustomXib(xibName: "FollowFollowingTVC")
        followingTableView.registerCustomXib(xibName: "FollowFollowingTVC")
        
        self.view.addSubview(tableScrollView)
        tableScrollView.addSubviews([followerView, followingView])
        followerView.addSubview(followerTableView)
        followingView.addSubview(followingTableView)
        
        tableScrollView.snp.makeConstraints{
            $0.top.equalTo(tabbarBottomView.snp.bottom).offset(0)
            $0.trailing.equalTo(view).offset(0)
            $0.leading.equalTo(view).offset(0)
            $0.bottom.equalTo(view).offset(0)
        }
        followerView.snp.makeConstraints{
            $0.top.equalTo(tableScrollView.snp.top).offset(0)
            $0.leading.equalTo(tableScrollView.snp.leading).offset(0)
            $0.width.equalTo(userWidth)
            $0.height.equalTo(tableViewHeight)
        }
        followerTableView.snp.makeConstraints{
            $0.top.equalTo(followerView.snp.top).offset(0)
            $0.bottom.equalTo(followerView.snp.bottom).offset(0)
            $0.leading.equalTo(followerView.snp.leading).offset(0)
            $0.trailing.equalTo(followerView.snp.trailing).offset(0)
        }
        followingView.snp.makeConstraints{
            $0.top.equalTo(tableScrollView.snp.top).offset(0)
            $0.leading.equalTo(followerView.snp.trailing).offset(0)
            $0.width.equalTo(userWidth)
            $0.height.equalTo(tableViewHeight)
        }
        followingTableView.snp.makeConstraints{
            $0.top.equalTo(followingView.snp.top).offset(0)
            $0.bottom.equalTo(followingView.snp.bottom).offset(0)
            $0.leading.equalTo(followingView.snp.leading).offset(0)
            $0.trailing.equalTo(followingView.snp.trailing).offset(0)
        }
    }
    
    func setHeaderLayout(){
        self.view.addSubview(headerBackgroundView)
        headerBackgroundView.addSubview(headerTitleLabel)
        headerBackgroundView.addSubview(backButton)
        
        let headerViewHeight = userheight * 0.15
        
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
        backButton.snp.makeConstraints{
            $0.width.equalTo(48)
            $0.height.equalTo(48)
            $0.top.equalToSuperview().offset(58)
            $0.centerY.equalTo(headerTitleLabel)
            $0.leading.equalToSuperview().offset(0)
        }

    }
    func setTabbarLayout(){
        self.view.addSubview(tabbarBackgroundView)
        tabbarBackgroundView.addSubview(followingButton)
        tabbarBackgroundView.addSubview(followerButton)
        tabbarBackgroundView.addSubview(tabbarBottomView)
        tabbarBackgroundView.addSubview(tabbarWriteBottomView)
        tabbarBackgroundView.addSubview(tabbarSaveBottomView)
        
        tabbarBackgroundView.snp.makeConstraints{
            $0.top.equalTo(headerBackgroundView.snp.bottom).offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(50)
        }
        followerButton.snp.makeConstraints{
            $0.top.equalTo(tabbarBackgroundView).offset(0)
            $0.leading.equalTo(tabbarBackgroundView).offset(0)
            $0.bottom.equalTo(tabbarBackgroundView).offset(0)
            $0.width.equalTo(userWidth/2)
        }
        followingButton.snp.makeConstraints{
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
}

extension FollowFollwingVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    
}
extension FollowFollwingVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(followDataList.count == 0){
            return 0
        }
        else{
            if tableView.tag == 1{
                return followDataList[0].follower.count
            }
            else{
                return followDataList[0].following.count
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowFollowingTVC.identifier) as? FollowFollowingTVC else {return UITableViewCell()}
        cell.delegate = self
        if tableView.tag == 1{
            cell.setData(image: followDataList[0].follower[indexPath.row].image,
                         userName: followDataList[0].follower[indexPath.row].nickname,
                         isFollow: followDataList[0].follower[indexPath.row].isFollow,
                         userEmail: followDataList[0].follower[indexPath.row].userEmail
            )
            return cell
        }
        else{
            cell.setData(image: followDataList[0].following[indexPath.row].image,
                         userName: followDataList[0].following[indexPath.row].nickname,
                         isFollow: followDataList[0].following[indexPath.row].isFollow,
                         userEmail: followDataList[0].following[indexPath.row].userEmail
            )
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let otherVC = UIStoryboard(name: "OtherMyPage", bundle: nil).instantiateViewController(withIdentifier: "OtherMyPageVC") as? OtherMyPageVC else {return}
        
        if tableView.tag == 1 {
            otherVC.setOtherUserID(userID: followDataList[0].follower[indexPath.row].userEmail)
        }
        else{
            otherVC.setOtherUserID(userID: followDataList[0].following[indexPath.row].userEmail)
        }
        self.navigationController?.pushViewController(otherVC, animated: true)
    }
    
    
}

extension FollowFollwingVC: isFollowButtonClickedDelegate{
    func isFollowButtonClicked(){
        getFollowData()
        print("딜리게이트 실행")
    }
    

}
