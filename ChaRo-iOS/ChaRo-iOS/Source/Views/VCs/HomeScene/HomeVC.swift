//
//  HomeVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/01.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import Lottie
import SwiftUI
import RxSwift

class HomeVC: UIViewController {
    
    //MARK: Var
    @IBOutlet weak var HomeTableView: UITableView!
    @IBOutlet weak var HomeNavigationView: UIView!
    @IBOutlet weak var homeNavigationLogo: UIImageView!
    @IBOutlet weak var homeNavigationSearchButton: UIButton!
    @IBOutlet weak var homeNavigationNotificationButton: UIButton!
    @IBOutlet weak var homeNavigationHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var charoIconImageView: NSLayoutConstraint!
    @IBOutlet weak var bannerScrollView: UIScrollView!
    @IBOutlet weak var carMoveConstraint: NSLayoutConstraint!
    
    
    //배너 관련 변수
    var homeTableViewHeaderHeight: CGFloat = UIScreen.getDeviceWidth() * 517.0 / 375.0
    var headerView: UIView!
    private var bannerImageList: [UIImage] = []
    private var currentNaviIconColorIsWhite: Bool = false
    
    enum BannerContent: String, CaseIterable {
        case seaDriveCource = "강릉 해변 드라이브 코스와 맛집"
        case playList = "드라이브 할 때 좋은 플레이리스트"
        case carDriceCource = "자동차 극장 드라이브 코스"
        case aboutCharo = "About 차로"
    }
    
    
    //데이타
    private var todayData: [DriveElement] = []
    private var trendyData: [DriveElement] = []
    private var customData: [DriveElement] = []
    private var localData: [DriveElement] = []
    private var customText: String = ""
    private var localText: String = ""
    
    private let lottieView = IndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    private var delegate: AnimateIndicatorDelegate?
    private var tableIndex: IndexPath = [0,0]
    
    private let navigationBottomView = UIView().then {
        $0.backgroundColor = UIColor.gray20
    }
    private var notificationListData = BehaviorSubject<[NotificationListModel]>(value: [])
    private let bag = DisposeBag()
    private var notificationActivate: Bool?
    private var isLogin: Bool = UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.isLogin)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationViewBottomLayout()
        getServerData()
        setTableView()
        setActionToSearchButton()
        navigationController?.isNavigationBarHidden = true
        HomeTableView.separatorStyle = .none
        bindNotificationData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNotificationListData()
    }
    
    //navigationView
    func setNavigationViewBottomLayout() {
        HomeNavigationView.addSubview(navigationBottomView)
        navigationBottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(1)
        }
        navigationBottomView.isHidden = true
    }
    //헤더뷰
    func setBannerInHeaderView() {
        initBannerImageList()
        HomeTableView.rowHeight = UITableView.automaticDimension
        headerView = HomeTableView.tableHeaderView
        HomeTableView.tableHeaderView = nil
        HomeTableView.addSubview(headerView)
        HomeTableView.contentInset = UIEdgeInsets(top: homeTableViewHeaderHeight, left: 0, bottom: 0, right: 0)
        HomeTableView.contentOffset = CGPoint(x: 0, y: -homeTableViewHeaderHeight)
        updateHeaderView()
    }
    
    private func initBannerImageList() {
        bannerImageList.append(contentsOf: [ ImageLiterals.imgHomeBannerGangneung,
                                             ImageLiterals.imgHomeBannerPlaylist,
                                             ImageLiterals.imgHomeBannerCarTheater,
                                             ImageLiterals.imgHomeBannerAboutCharo ])
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -homeTableViewHeaderHeight, width: HomeTableView.bounds.width, height: homeTableViewHeaderHeight)
        if HomeTableView.contentOffset.y < homeTableViewHeaderHeight {
            headerRect.origin.y = HomeTableView.contentOffset.y
            headerRect.size.height = -HomeTableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    
    //서버 데이터 받아오는 부분
    func getServerData() {
        //lottieview
        delegate = self
        delegate?.startIndicator()
        GetHomeDataService.HomeData.getRecommendInfo{ (response) in
            switch response
            {
            case .success(let data) :
                if let response = data as? HomeDataModel {
                    print("겟 데이터 실행")
                    DispatchQueue.global().sync {
                        let data = response.data
                        self.setBannerInHeaderView()
                        
                        //today 차로
                        if let today = data.todayCharoDrive.drive as? [DriveElement] {
                            self.todayData = today
                            print(self.todayData)
                        }
                        
                        //trendy 차로
                        if let trendy = data.trendDrive.drive as? [DriveElement] {
                            self.trendyData = trendy
                        }
                        
                        //custom 차로 & 텍스트
                        if let custom = data.customDrive.drive as? [DriveElement] {
                            self.customData = custom
                            self.customText = data.customTitle
                        }
                        
                        
                        //local 차로
                        if let local = data.localDrive.drive as? [DriveElement] {
                            self.localData = local
                            self.localText = data.localTitle
                            print(data.localTitle)
                            
                        }
                        self.delegate?.endIndicator()
                    }
                    self.HomeTableView.reloadData()
                    
                }
            case .requestErr(let message):
                print("requestERR")
            case .pathErr:
                print("pathERR")
                print("한번 더 실행ㅋ")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                print("networkFail")
            }
            //shot out to 'Jang PARTZZANG'
            DispatchQueue.main.async { [weak self] in
                self?.addContentScrollView()
                self?.HomeTableView.reloadData()
            }
        }
    }
    func setTableView() {
        HomeTableView.delegate = self
        HomeTableView.dataSource = self
        HomeTableView.registerCustomXib(xibName: "HomeAnimationTVC")
        HomeTableView.registerCustomXib(xibName: "HomeTodayDriveTVC")
        HomeTableView.registerCustomXib(xibName: "HomeThemeTVC")
        HomeTableView.registerCustomXib(xibName: "HomeSquareTVC")
        HomeTableView.registerCustomXib(xibName: "HomeSeasonRecommandTVC")
        HomeTableView.registerCustomXib(xibName: "HomeAreaRecommandTVC")
    }
    
    func setActionToSearchButton() {
        homeNavigationSearchButton.addTarget(self, action: #selector(presentSearchPost), for: .touchUpInside)
    }
    
    @objc func presentSearchPost() {
        if isLogin {
            let nextVC = SearchPostVC()
            let navigation = UINavigationController(rootViewController: nextVC)
            navigation.modalPresentationStyle = .fullScreen
            present(navigation, animated: true, completion: nil)
        } else {
            // 로그인을 하지 않았을 때 - 둘러보기
            makeRequestAlert(title: "로그인이 필요해요", message: "", okTitle: "로그인하기", okAction: { [weak self] _ in
                self?.presentToSignNC()
            }, cancelTitle: "취소")
        }
    }
    
    @IBAction func notificationButtonClicked(_ sender: Any) {
        if isLogin {
            guard let notiVC = UIStoryboard(name: "Notification", bundle: nil).instantiateViewController(identifier: "NotificationVC") as? NotificationVC else {return}
            
            self.navigationController?.pushViewController(notiVC, animated: true)
        } else {
            // 로그인을 하지 않았을 때 - 둘러보기
            makeRequestAlert(title: "로그인이 필요해요", message: "", okTitle: "로그인하기", okAction: { [weak self] _ in
                self?.presentToSignNC()
            }, cancelTitle: "취소")
        }
    }
    
    private func bindNotificationData() {
        notificationListData.subscribe(onNext: { [weak self] data in
            var isActivate: Bool = false
            
            for i in data {
                if i.isRead == 0 {
                    isActivate = true
                }
            }
            
            self?.notificationActivate = isActivate
            self?.setNaviBarNotificationItem(isActive: isActivate, isWhite: self?.currentNaviIconColorIsWhite ?? false)
        }).disposed(by: bag)
    }
    
    private func setNaviBarNotificationItem(isActive: Bool, isWhite: Bool) {
        if isActive {
            homeNavigationNotificationButton.setBackgroundImage(isWhite ? ImageLiterals.icAlarmActiveWhite : ImageLiterals.icAlarmActiveBlack, for: .normal)
        } else {
            homeNavigationNotificationButton.setBackgroundImage(isWhite ? ImageLiterals.icAlarmWhite : ImageLiterals.icAlarmBlack, for: .normal)
        }
    }
}

extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indextPath: IndexPath) -> CGFloat {
        
        let factor = UIScreen.main.bounds.width / 375
        switch indextPath.row {
            
            //배너
        case 0:
            return 365 * factor
            //테마
        case 1:
            return 178 * factor
            //트렌드
        case 2:
            if trendyData.count <= 2 {
                return 318 * factor
            } else {
                return 570 * factor
            }
            //커스텀테마
        case 3:
            if customData.count <= 2 {
                return 318 * factor
            } else {
                return 570 * factor
            }
            //지역
        case 4:
            if localData.count <= 2 {
                return 318 * factor
            } else {
                return 570 * factor
            }
            //아무것도아닌거
        case 999:
            return 100
            //그 외 섹션
        default:
            print("default")
            return 570 * factor
        }
    }
    
    func addContentScrollView() {
        bannerScrollView.delegate = self
        bannerScrollView.bounces = false
        if bannerScrollView.subviews.count > 3 {
            bannerScrollView.viewWithTag(0)?.frame.size.height = -HomeTableView.contentOffset.y
            bannerScrollView.viewWithTag(1)?.frame.size.height = -HomeTableView.contentOffset.y
            bannerScrollView.viewWithTag(2)?.frame.size.height = -HomeTableView.contentOffset.y
            bannerScrollView.viewWithTag(3)?.frame.size.height = -HomeTableView.contentOffset.y
        }  else if !bannerImageList.isEmpty {
            for index in 0..<bannerImageList.count {
                let xPos = self.view.frame.width * CGFloat(index)
                let imageView = UIImageView(image: bannerImageList[index])
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: xPos, y: 0, width: UIScreen.getDeviceWidth(), height: homeTableViewHeaderHeight)
                imageView.tag = index
                bannerScrollView.addSubview(imageView)
                bannerScrollView.contentSize = CGSize(width: UIScreen.getDeviceWidth() * 4, height: homeTableViewHeaderHeight)
                addTapGestrue(in: imageView)
            }
        }
    }
    
    func addTapGestrue(in imageView: UIImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentToBanner(_:)))
        tapGesture.cancelsTouchesInView = false
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func presentToBanner(_ sender: UITapGestureRecognizer) {
        guard let currentTag = sender.view?.tag else { return }
        var nextVC: BannerVC?
        switch currentTag {
        case 0:
            nextVC = FirstBannerVC(title: BannerContent.seaDriveCource.rawValue)
        case 1:
            nextVC = SecondBannerVC(title: BannerContent.playList.rawValue)
        case 2:
            nextVC = ThirdBannerVC(title: BannerContent.carDriceCource.rawValue)
        case 3:
            nextVC = FourthBannerVC(title: BannerContent.aboutCharo.rawValue)
        default: print("잘못된 경우")
        }
        if let nextVC = nextVC {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    //MARK: ScrollViewDidScroll
    private func configureLogoImage(isWhite: Bool) {
        if isWhite {
            currentNaviIconColorIsWhite = true
            homeNavigationLogo.image = ImageLiterals.icCharoLogoWhite
            homeNavigationSearchButton.setBackgroundImage(ImageLiterals.icSearchWhite, for: .normal)
            homeNavigationNotificationButton.setBackgroundImage(notificationActivate ?? false ? ImageLiterals.icAlarmActiveWhite :ImageLiterals.icAlarmWhite, for: .normal)
            navigationBottomView.isHidden = true
        } else {
            currentNaviIconColorIsWhite = false
            homeNavigationLogo.image = ImageLiterals.icCharoLogo
            homeNavigationSearchButton.setBackgroundImage(ImageLiterals.icSearchBlack, for: .normal)
            homeNavigationNotificationButton.setBackgroundImage(notificationActivate ?? false ? ImageLiterals.icAlarmActiveBlack : ImageLiterals.icAlarmBlack, for: .normal)
            
            navigationBottomView.isHidden = false
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNavigationAlpah()
        setMoveCar()
    }
    func setNavigationAlpah() {
        let currentWidth = HomeTableView.contentOffset.x
        let currentHeight = HomeTableView.contentOffset.y
        
        if currentHeight > -homeTableViewHeaderHeight && currentWidth == 0 {
            if currentHeight > -homeTableViewHeaderHeight {
                HomeNavigationView.backgroundColor = UIColor(white: 1, alpha: 0 + (homeTableViewHeaderHeight / (-currentHeight * 3)))
                if currentHeight >= -CGFloat(homeTableViewHeaderHeight/3) {
                    if currentWidth == 0 && currentHeight == 0 {
                        configureLogoImage(isWhite: true)
                    }  else {
                        if HomeTableView.contentOffset.y <= -47 && currentHeight == -47 {
                            configureLogoImage(isWhite: true)
                        } else {
                            configureLogoImage(isWhite: false)
                        }
                    }
                } else if currentHeight <= -CGFloat(homeTableViewHeaderHeight/3) {
                    configureLogoImage(isWhite: true)
                }
                if currentHeight > 0{
                    HomeNavigationView.backgroundColor = UIColor.white
                } else if currentHeight < -homeTableViewHeaderHeight {
                    HomeNavigationView.backgroundColor = .none
                }
            }
        } else {
            //updateHeaderView()
            //addContentScrollView()
            HomeNavigationView.backgroundColor = .none
        }
        
    }
    func setMoveCar() {
        let originalCarConstant = carMoveConstraint.constant
        let sideMargin: CGFloat = 24
        let pageCount: Int = 4
        let currentWidth = bannerScrollView.contentOffset.x
        if bannerScrollView.contentOffset.x > 0{
            if currentWidth < 10000 {
                carMoveConstraint.constant = (currentWidth - sideMargin)/CGFloat(pageCount)
            } else {
                carMoveConstraint.constant = originalCarConstant
            }
        } else {
            carMoveConstraint.constant = originalCarConstant
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //섹션 갯수
        let sectionNum: Int = 5;
        return sectionNum
    }
    
    //MARK: 내용 구현 부
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableIndex = indexPath
        
        //MARK: 배너부분 구현
        switch indexPath.row {
            //MARK: 오늘의 드라이브
        case 0:
            let cell: HomeTodayDriveTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.postDelegate = self
            print(todayData)
            if todayData.count == 0 {
                return cell
            } else {
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
            } else {
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
            } else {
                cell.customList = customData
                return cell
                
            }
            
            //MARK: 로컬 테마
        case 4:
            
            let cell: HomeAreaRecommandTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.buttonDelegate = self
            cell.postDelegate = self
            
            print("fsdgsfdg", localText)
            cell.headerText = localText
            cell.localList = localData
            
            return cell
            
            
        default:
            print("Error")
        }
        return UITableViewCell()
        
    }
}

extension HomeVC: UITableViewDataSource {
}

//extension HomeVC: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}

extension HomeVC: IsSelectedCVCDelegate {
    func isSelectedCVC(indexPath: IndexPath) {
        //tableview indexPath에 따라ㅏ 받아오고, 나중에 서버랑 연결되면 거기서 또 테이블 뷰 셀이랑 연동하면 될듯~!
        print(tableIndex.row)
    }
}

extension HomeVC: SeeMorePushDelegate {
    func seeMorePushDelegate(data: Int) {
        guard let smVC = UIStoryboard(name: "HomePost", bundle: nil).instantiateViewController(identifier: "HomePostVC") as? HomePostVC else {return}
        
        switch data {
        case 3:
            smVC.topText = "요즘 뜨는 드라이브 코스"
            GetDetailDataService.value = "0"
            GetNewDetailDataService.value = "0"
            GetInfinityDetailDataService.identifier = "0"
        case 4:
            smVC.topText = customText
            GetDetailDataService.value = "1?value=lake"
            GetNewDetailDataService.value = "1?value=lake"
            GetInfinityDetailDataService.identifier = "1"
            GetInfinityDetailDataService.value = "?value=lake"
        case 5:
            smVC.topText = localText
            GetDetailDataService.value = "2?value=busan"
            GetNewDetailDataService.value = "2?value=busan"
            GetInfinityDetailDataService.identifier = "2"
            GetInfinityDetailDataService.value = "?value=busan"
        default:
            print("Error")
        }
        self.navigationController?.pushViewController(smVC, animated: true)
    }
    
    
}

extension HomeVC: CollectionViewCellDelegate {
    func collectionView(collectionviewcell: HomeThemeCVC?, index: Int, didTappedInTableViewCell: HomeThemeTVC) {
        let storyboard = UIStoryboard(name: "ThemePost", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "ThemePostVC") as? ThemePostVC else { return }
        vc.setSelectedTheme(name: (collectionviewcell?.themeLabel.text)!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//postID 넘기기 위한 Delegate 구현
extension HomeVC: PostIdDelegate {
    func sendPostDetail(with postId: Int) {
        if isLogin {
            let nextVC = PostDetailVC(postId: postId)
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            makeRequestAlert(title: "로그인이 필요해요", message: "", okTitle: "로그인하기", okAction: { [weak self] _ in
                self?.presentToSignNC()
            }, cancelTitle: "취소")
        }
    }
}

extension HomeVC: AnimateIndicatorDelegate {
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

// MARK: - Networking
extension HomeVC {
    private func getNotificationListData() {
        NotificationService.shared.getNotificationList { [weak self] response in
            switch(response) {
            case .success(let resultData):
                if let data =  resultData as? [NotificationListModel]{
                    self?.notificationListData.onNext(data)
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
