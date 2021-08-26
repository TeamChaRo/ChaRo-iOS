//
//  HomeVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/01.
//

import UIKit
import SnapKit
import Then

class HomeVC: UIViewController {

    @IBOutlet weak var HomeTableView: UITableView!
    @IBOutlet weak var HomeNavigationView: UIView!
    @IBOutlet weak var homeNavigationLogo: UIImageView!
    @IBOutlet weak var homeNavigationSearchButton: UIButton!
    @IBOutlet weak var homeNavigationNotificationButton: UIButton!
    
    @IBOutlet weak var homeNavigationHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var charoIconImageView: NSLayoutConstraint!
    @IBOutlet weak var bannerScrollView: UIScrollView!
    @IBOutlet weak var carMoveConstraint: NSLayoutConstraint!
    
    
    var isFirstSetData: Bool = true
    
    var homeTableViewHeaderHeight:CGFloat = UIScreen.main.bounds.height * 0.65
    var headerView: UIView!
    var images = [#imageLiteral(resourceName: "nightView") , #imageLiteral(resourceName: "dummyMain") , #imageLiteral(resourceName: "summer"), #imageLiteral(resourceName: "speed")]
    var imageViews = [UIImageView]()
    
    ///배너 데이타
    var bannerData: [Banner] = []
    var todayData: [Drive] = []
    var trendyData: [Drive] = []
    var customData: [Drive] = []
    var localData: [Drive] = []
    var customText: String = ""
    var localText: String = ""

    
    var tableIndex: IndexPath = [0,0]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("겟 데이터 실행")
        getData()
        setTableView()
        setHomeNavigationViewLayout()
        setActionToSearchButton()
        setHeader()
        navigationController?.isNavigationBarHidden = true
        updateHeaderView() // setHeader 안에 이 함수가 들어가서 또 안써도 될듯?
        HomeTableView.separatorStyle = .none
        addContentScrollView()
    }
    
    
     
    func setHomeNavigationViewLayout() {
        HomeNavigationView.backgroundColor = .none
        homeNavigationNotificationButton.addTarget(self, action: #selector(presentOnBoarding), for: .touchUpInside)
        
        self.setMainNavigationViewUI(height: homeNavigationHeightConstraints,
                                 fromTopToImageView: charoIconImageView)
        
    }
    
    func setHeader(){
      
        HomeTableView.rowHeight = UITableView.automaticDimension
        headerView = HomeTableView.tableHeaderView
        HomeTableView.tableHeaderView = nil
        HomeTableView.addSubview(headerView)
        HomeTableView.contentInset = UIEdgeInsets(top: homeTableViewHeaderHeight, left: 0, bottom: 0, right: 0)
        HomeTableView.contentOffset = CGPoint(x: 0, y: -homeTableViewHeaderHeight)
        updateHeaderView()
        setupHeaderViewLayout()
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -homeTableViewHeaderHeight, width: HomeTableView.bounds.width, height: homeTableViewHeaderHeight)
        if HomeTableView.contentOffset.y < homeTableViewHeaderHeight {
            headerRect.origin.y = HomeTableView.contentOffset.y
            headerRect.size.height = -HomeTableView.contentOffset.y
        }
        headerView.frame = headerRect

    }
    
    func setupHeaderViewLayout(){
        //여기 서버 연동할때 변수로 바꾸겠습니다.
        let firstBannerTitleLabel = UILabel().then{
            $0.font = .notoSansBoldFont(ofSize: 28)
            $0.textColor = .white
            $0.text = "차로와 함께\n즐기는\n드라이브 코스"
            $0.numberOfLines = 0
        }
        let firstHashLabel = UILabel().then{
            $0.font = .notoSansRegularFont(ofSize: 13)
            $0.textColor = .white
            $0.text = "#날씨도좋은데#바다와함께라면"
            $0.numberOfLines = 0
        }
        
        let secondBannerTitleLabel = UILabel().then {
            $0.font = .notoSansBoldFont(ofSize: 28)
            $0.textColor = .white
            $0.text = "박익범\n힘들다\n살려줘"
            $0.numberOfLines = 0
        }
        let secondHashLabel = UILabel().then{
            $0.font = .notoSansRegularFont(ofSize: 13)
            $0.textColor = .white
            $0.text = "#코딩할때별거아닌걸로 어? 금지"
            $0.numberOfLines = 0
        }
        
        let thirdBannerTitleLabel = UILabel().then {
            $0.font = .notoSansBoldFont(ofSize: 28)
            $0.textColor = .white
            $0.text = "눈물이\n차올라서\n고갤들어"
            $0.numberOfLines = 0
        }
        let thirdHashLabel = UILabel().then{
            $0.font = .notoSansRegularFont(ofSize: 13)
            $0.textColor = .white
            $0.text = "#ㄴr는 ㄱr끔 눈물을 흘린ㄷr"
            $0.numberOfLines = 0
        }
        
        let fourthBannerTitleLabel = UILabel().then {
            $0.font = .notoSansBoldFont(ofSize: 28)
            $0.textColor = .white
            $0.text = "짱혜령\n갓혜령\n오늘도외쳐~"
            $0.numberOfLines = 0
        }
        let fourthHashLabel = UILabel().then{
            $0.font = .notoSansRegularFont(ofSize: 13)
            $0.textColor = .white
            $0.text = "#음악은 ㄴrㄹrㄱr 허락한 유일한 ㅁr약"
            $0.numberOfLines = 0
        }
        
        headerView.addSubview(firstBannerTitleLabel)
        headerView.addSubview(secondBannerTitleLabel)
        headerView.addSubview(thirdBannerTitleLabel)
        headerView.addSubview(fourthBannerTitleLabel)
        headerView.addSubview(firstHashLabel)
        headerView.addSubview(secondHashLabel)
        headerView.addSubview(thirdHashLabel)
        headerView.addSubview(fourthHashLabel)
        
        
        
//이거 일단 언래핑 해놨는데 나중에 서버에서 이미지 느리게 가져올때 대비만 해놓으면 될듯????! 아니면 앱 강종날듯;;;;
        firstBannerTitleLabel.snp.makeConstraints{
            $0.leading.equalTo(bannerScrollView.viewWithTag(1)!).offset(24)
            $0.bottom.equalToSuperview().inset(114)
        }
        firstHashLabel.snp.makeConstraints{
            $0.leading.equalTo(bannerScrollView.viewWithTag(1)!).offset(24)
            $0.top.equalTo(firstBannerTitleLabel.snp.bottom).offset(5)
        }
        
        secondBannerTitleLabel.snp.makeConstraints{
            $0.leading.equalTo(bannerScrollView.viewWithTag(2)!).offset(24)
            $0.bottom.equalToSuperview().inset(114)
        }
        secondHashLabel.snp.makeConstraints{
            $0.leading.equalTo(bannerScrollView.viewWithTag(2)!).offset(24)
            $0.top.equalTo(firstBannerTitleLabel.snp.bottom).offset(5)
        }
        
        thirdBannerTitleLabel.snp.makeConstraints{
            $0.leading.equalTo(bannerScrollView.viewWithTag(3)!).offset(24)
            $0.bottom.equalToSuperview().inset(114)
        }
        thirdHashLabel.snp.makeConstraints{
            $0.leading.equalTo(bannerScrollView.viewWithTag(3)!).offset(24)
            $0.top.equalTo(firstBannerTitleLabel.snp.bottom).offset(5)
        }
        
        fourthBannerTitleLabel.snp.makeConstraints{
            $0.leading.equalTo(bannerScrollView.viewWithTag(4)!).offset(24)
            $0.bottom.equalToSuperview().inset(114)
        }
        fourthHashLabel.snp.makeConstraints{
            $0.leading.equalTo(bannerScrollView.viewWithTag(4)!).offset(24)
            $0.top.equalTo(firstBannerTitleLabel.snp.bottom).offset(5)
        }
        
    }
    
    @objc func presentOnBoarding(){
//        let storyboard = UIStoryboard(name: "OnBoard", bundle: nil)
//        let nextVC = storyboard.instantiateViewController(identifier: OnBoardVC.identifier)
        
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//        let nextVC = storyboard.instantiateViewController(identifier: LoginVC.identifier)
//        nextVC.modalPresentationStyle = .fullScreen
//        present(nextVC, animated: true, completion: nil)
    }
    
    func getData() {
        GetHomeDataService.HomeData.getRecommendInfo{ (response) in
            switch response
            {
            case .success(let data) :
                if let response = data as? HomeDataModel {
                    print("겟 데이터 실행")
                    DispatchQueue.global().sync {
                        let data = response.data
                        
                    //배너 타이틀
                    if let banner = data.banner as? [Banner] {
                        self.bannerData = banner
                    }
                    
                    //today 차로
                    if let today = data.todayCharoDrive as? [Drive] {
                        self.todayData = today
                    }
                    
                    //trendy 차로
                    if let trendy = data.trendDrive as? [Drive] {
                        self.trendyData = trendy
                    }
        
                    //custom 차로 & 텍스트
                    if let custom = data.customThemeDrive as? [Drive] {
                        self.customData = custom
                        self.customText = data.customThemeTitle
                    }

                    
                    //local 차로
                    if let local = data.localDrive as? [Drive] {
                        self.localData = local
                        self.localText = data.localTitle
                    }

                    }
                    self.HomeTableView.reloadData()
                   
                }
            case .requestErr(let message) :
                print("requestERR")
            case .pathErr :
                print("pathERR")
                print("한번 더 실행ㅋ")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    func setTableView(){
        
        HomeTableView.delegate = self
        HomeTableView.dataSource = self
        
        HomeTableView.registerCustomXib(xibName: "HomeAnimationTVC")
        HomeTableView.registerCustomXib(xibName: "HomeTodayDriveTVC")
        HomeTableView.registerCustomXib(xibName: "HomeThemeTVC")
        HomeTableView.registerCustomXib(xibName: "HomeSquareTVC")
        HomeTableView.registerCustomXib(xibName: "HomeSeasonRecommandTVC")
        HomeTableView.registerCustomXib(xibName: "HomeAreaRecommandTVC")
    }
    
    func setActionToSearchButton(){
        homeNavigationSearchButton.addTarget(self, action: #selector(presentSearchPost), for: .touchUpInside)
    }
    
    @objc func presentSearchPost(){
        let storyboard = UIStoryboard(name: "SearchPost", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: SearchPostVC.identifier) as! SearchPostVC
        let navigation = UINavigationController(rootViewController: nextVC)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true, completion: nil)
    }
    
    @IBAction func notificationButtonClicked(_ sender: Any) {
        
        guard let notiVC = UIStoryboard(name: "Notification", bundle: nil).instantiateViewController(identifier: "NotificationVC") as? NotificationVC else {return}
        
        self.navigationController?.pushViewController(notiVC, animated: true)
    }
    

}

extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView : UITableView, heightForRowAt indextPath: IndexPath) -> CGFloat{
        
        let factor = UIScreen.main.bounds.width / 375
        switch indextPath.row {
        case 0:
            return 365 * factor
        case 1:
            return 178 * factor
        case 2, 3, 4:
            return 570 * factor
        default:
            return 100
        }
        
    }
    
  
    func setNavigationViewShadow(){
        //shadowExtension 예제
        HomeNavigationView.getShadowView(color: UIColor.black.cgColor, masksToBounds: false, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8, shadowOpacity: 0.3)
    }
    func addContentScrollView() {
        if bannerScrollView.subviews.count > 3{
            print(bannerScrollView.subviews)
            bannerScrollView.viewWithTag(1)?.frame.size.height = -HomeTableView.contentOffset.y
            bannerScrollView.viewWithTag(2)?.frame.size.height = -HomeTableView.contentOffset.y
            bannerScrollView.viewWithTag(3)?.frame.size.height = -HomeTableView.contentOffset.y
            bannerScrollView.viewWithTag(4)?.frame.size.height = -HomeTableView.contentOffset.y

        }
        else{
            for i in 1..<images.count + 1 {
                let xPos = self.view.frame.width * CGFloat(i-1)
                let imageView = UIImageView()
                imageView.frame = CGRect(x: xPos, y: 0, width: UIScreen.main.bounds.width, height: homeTableViewHeaderHeight)
                //여기도 서버 연결할때 이미지 바로 따오겠슴뉘다..
                imageView.image = images[i-1]
                imageView.tag = i
                bannerScrollView.addSubview(imageView)
                bannerScrollView.contentSize.width = imageView.frame.width * CGFloat(i)
                bannerScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 4, height: homeTableViewHeaderHeight)
                
            }
        }
        }
   
    
//MARK: ScrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let originalCarConstant = carMoveConstraint.constant
        let sideMargin : CGFloat = 24
        let pageCount : Int = 4
        bannerScrollView.delegate = self
// 배너 자동차 부릉부릉
        let userHeight = HomeNavigationView.getDeviceHeight()
        let standardHeight = userHeight/2
        let currentHeight = scrollView.contentOffset.y
        if bannerScrollView.contentOffset.x > 0{
            print("실행중")
               if bannerScrollView.contentOffset.x < 10000 {
                carMoveConstraint.constant = (bannerScrollView.contentOffset.x - sideMargin)/CGFloat(pageCount)
               } else {
                carMoveConstraint.constant = originalCarConstant
               }
           }
        else{
            carMoveConstraint.constant = originalCarConstant
           }
        
// 네비게이션바 알파값 조정
        print(scrollView.contentOffset.y, homeTableViewHeaderHeight, standardHeight, currentHeight)
        if scrollView.contentOffset.y > -homeTableViewHeaderHeight{

            //수정중
               if scrollView.contentOffset.y < 0 {
                HomeNavigationView.backgroundColor = UIColor(white: 1, alpha: 0.01 + (homeTableViewHeaderHeight*4 / -scrollView.contentOffset.y))
                
                if currentHeight >= CGFloat(homeTableViewHeaderHeight/2){
                    homeNavigationLogo.image = UIImage(named: "logo.png")
                    homeNavigationSearchButton.setBackgroundImage(UIImage(named: "iconSearchBlack.png"), for: .normal)
                    homeNavigationNotificationButton.setBackgroundImage(UIImage(named: "iconAlarmBlack.png"), for: .normal)
                    setNavigationViewShadow()
                }
                else if currentHeight <= CGFloat(homeTableViewHeaderHeight/2){
                    homeNavigationLogo.image = UIImage(named: "logoWhite.png")
                    homeNavigationSearchButton.setBackgroundImage(UIImage(named: "icSearchWhite.png"), for: .normal)
                    homeNavigationNotificationButton.setBackgroundImage(UIImage(named: "icAlarmWhite.png"), for: .normal)
                    HomeNavigationView.removeShadowView()
 
                }
                
               }
               else {
                HomeNavigationView.backgroundColor = .none
               }
        }else{
            updateHeaderView()
            addContentScrollView()
            HomeNavigationView.backgroundColor = .none
           }

       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
//MARK: 내용 구현 부
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableview indexPath
        tableIndex = indexPath
//MARK: 배너부분 구현
        switch indexPath.row {
        
//
//        case 0:
//            let cell: HomeAnimationTVC = tableView.dequeueReusableCell(for: indexPath)
//            cell.setDelegate()
//
//            if bannerData.count == 0 {
//                return cell
//            }
//
//            else {
//
//                //여기서 isFirstSetData 이게 필요한 걸까 ? 혹시 이게 계속 호출되서 그런걸까? 헷갈리다 ....
//                if isFirstSetData {
//                    for i in 0 ... 3 {
//                        cell.setBannerList(inputList: bannerData)
//                    }
//                    isFirstSetData = false
//                    return cell
//                }
//
//
//            }
            
//MARK: 오늘의 드라이브
        case 0:

            let cell: HomeTodayDriveTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.postDelegate = self
            //image
            if todayData.count == 0 {
                return cell
            }
            else {
                cell.todayDriveList = todayData

                
            return cell
            
        }
        
        case 1:

            let cell: HomeThemeTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.cellDelegate = self
            return cell
            
            
//MARK: 트렌드
        case 2:

            let cell: HomeSquareTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.ButtonDelegate = self
            cell.postDelegate = self
            

            if trendyData.count == 0 {
                return cell
            }
            else {
                cell.trendyDriveList = trendyData

                
            return cell
                
            }

            
//MARK: 커스텀 테마
        case 3:

            let cell: HomeSeasonRecommandTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.buttonDelegate = self
            cell.postDelegate = self
            
            cell.headerText = customText
            
            if customData.count == 0 {
                return cell
            }
            
            else {
                cell.customList = customData
                
            return cell
                
            }
           
//MARK: 로컬 테마
        case 4:

            let cell: HomeAreaRecommandTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.buttonDelegate = self
            cell.postDelegate = self
            
            cell.headerText = localText
            
            cell.LocelList = localData
            
            return cell
        
        
        default:
            print("Error")
        }
        return UITableViewCell()
        
    }
    

}
extension HomeVC : IsSelectedCVCDelegate {
    func isSelectedCVC(indexPath: IndexPath) {
        //tableview indexPath에 따라ㅏ 받아오고, 나중에 서버랑 연결되면 거기서 또 테이블 뷰 셀이랑 연동하면 될듯~!
        print(tableIndex.row)
        
       
    }
}

extension HomeVC: SeeMorePushDelegate{
    func seeMorePushDelegate(data: Int) {
        guard let smVC = UIStoryboard(name: "HomePost", bundle: nil).instantiateViewController(identifier: "HomePostVC") as? HomePostVC else {return}
        
        switch data {
        case 3:
            smVC.topText = "요즘 뜨는 드라이브 코스"
            GetDetailDataService.value = "0"
            GetNewDetailDataService.value = "0"
        case 4:
            smVC.topText = customText
            GetDetailDataService.value = "1?value=summer"
            GetNewDetailDataService.value = "1?value=summer"
        case 5:
            smVC.topText = localText
            GetDetailDataService.value = "2?value=busan"
            GetNewDetailDataService.value = "2?value=busan"
        default:
            print("Error")
        }
        self.navigationController?.pushViewController(smVC, animated: true)
    }
    

}

extension HomeVC : CollectionViewCellDelegate {
    
    func collectionView(collectionviewcell: HomeThemeCVC?, index: Int, didTappedInTableViewCell: HomeThemeTVC) {
        
        let storyboard = UIStoryboard(name: "ThemePost", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(identifier: "ThemePostVC") as? ThemePostVC else { return }
        
        vc.setSelectedTheme(name: (collectionviewcell?.themeLabel.text)!)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        }
    
}


//postID 넘기기 위한 Delegate 구현
extension HomeVC: PostIdDelegate {
    
    func sendPostID(data: Int) {
        print("이거임 ~~~~\(data)")
        
        let storyboard = UIStoryboard(name: "PostDetail", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: PostDetailVC.identifier) as! PostDetailVC
        
        nextVC.setPostId(id: data)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
