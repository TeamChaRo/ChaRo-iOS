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

class HomeVC: UIViewController{

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
    var homeTableViewHeaderHeight:CGFloat = UIScreen.main.bounds.height * 0.65
    var headerView: UIView!
    var images: [UIImage] = [#imageLiteral(resourceName: "dummyMain"),#imageLiteral(resourceName: "dummyMain"),#imageLiteral(resourceName: "dummyMain"),#imageLiteral(resourceName: "dummyMain")]
    var imageViews = [UIImageView]()
    var bannerTitleLableList: [UILabel] = []
    var bannerSubtTtleLabelList: [UILabel] = []
    
    
    //데이타
    var bannerData: [Banner] = []
    var todayData: [DriveElement] = []
    var trendyData: [DriveElement] = []
    var customData: [DriveElement] = []
    var localData: [DriveElement] = []
    var customText: String = ""
    var localText: String = ""

    let lottieView = IndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var delegate: AnimateIndicatorDelegate?

    
    var tableIndex: IndexPath = [0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getServerData()
        setTableView()
        setActionToSearchButton()
        navigationController?.isNavigationBarHidden = true
        HomeTableView.separatorStyle = .none
    }
    //헤더뷰
    func setHeader() {
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
    
    func setupHeaderViewUI() {
        var titleList: [String] = []
        var subTitleList: [String] = []
            
            var titleLabelList: [UILabel] = []
            var subTitleLabelList: [UILabel] = []
        for i in 0...3
        {
            titleList.append(bannerData[i].bannerTitle)
            subTitleList.append(bannerData[i].bannerTag)
        }
        
            for index in 0..<titleList.count {
                let titleLabel = UILabel().then{
                    $0.font = .notoSansBoldFont(ofSize: 28)
                    $0.textColor = .white
                    $0.text = titleList[index]
                    $0.numberOfLines = 3
                }
                
                let subTitleLabel = UILabel().then{
                    $0.font = .notoSansRegularFont(ofSize: 13)
                    $0.textColor = .white
                    $0.text = subTitleList[index]
                    $0.numberOfLines = 3
                }
                
                titleLabelList.append(titleLabel)
                subTitleLabelList.append(subTitleLabel)
            }
            
            bannerTitleLableList = titleLabelList
            bannerSubtTtleLabelList = subTitleLabelList
            headerView.addSubviews(bannerTitleLableList + bannerSubtTtleLabelList)
            
        }
        
        func setupHeaderViewLayout() {
            for index in 0..<bannerTitleLableList.count {
                bannerTitleLableList[index].snp.makeConstraints{
                    $0.leading.equalTo(bannerScrollView.viewWithTag(index+1)!).offset(24)
                    $0.bottom.equalToSuperview().inset(114)
                    $0.width.equalTo(180)
                }
                
                bannerSubtTtleLabelList[index].snp.makeConstraints{
                    $0.leading.equalTo(bannerTitleLableList[index].snp.leading)
                    $0.top.equalTo(bannerTitleLableList[index].snp.bottom).offset(5)
                }
            }
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
                    //배너 타이틀
                        if let banner = data.banner as? [Banner] {
                        self.bannerData = banner
                        self.setHeader()
                        self.setupHeaderViewUI()
                    }
                    
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
                self?.setupHeaderViewLayout()
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

extension HomeVC : UITableViewDelegate {
    
    func tableView(_ tableView : UITableView, heightForRowAt indextPath: IndexPath) -> CGFloat{
        
        let factor = UIScreen.main.bounds.width / 375
        switch indextPath.row {
        
        //배너
        case 0:
            return 365 * factor
        //테마
        case 1:
            return 178 * factor
        //아무것도 아닌거
        case 999:
            return 100
        //그 외 섹션
        default:
            return 570 * factor
        }
        
    }
    
    func setNavigationViewShadow() {
        //shadowExtension 예제
        HomeNavigationView.getShadowView(color: UIColor.black.cgColor, masksToBounds: false, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8, shadowOpacity: 0.3)
    }
    func addContentScrollView() {
        bannerScrollView.delegate = self
        bannerScrollView.bounces = false
        if bannerScrollView.subviews.count > 3{
            print(bannerScrollView.subviews)
            bannerScrollView.viewWithTag(1)?.frame.size.height = -HomeTableView.contentOffset.y
            bannerScrollView.viewWithTag(2)?.frame.size.height = -HomeTableView.contentOffset.y
            bannerScrollView.viewWithTag(3)?.frame.size.height = -HomeTableView.contentOffset.y
            bannerScrollView.viewWithTag(4)?.frame.size.height = -HomeTableView.contentOffset.y

        }
        else{
            if bannerData.count != 0{
                for i in 1..<images.count + 1 {
                    let xPos = self.view.frame.width * CGFloat(i-1)
                    let imageView = UIImageView()
                    imageView.frame = CGRect(x: xPos, y: 0, width: UIScreen.main.bounds.width, height: homeTableViewHeaderHeight)
                    print(bannerData.count)
                        guard let url = URL(string: bannerData[i-1].bannerImage ) else { return }
                        imageView.kf.setImage(with: url)
                    imageView.tag = i
                    bannerScrollView.addSubview(imageView)
                    bannerScrollView.contentSize.width = imageView.frame.width * CGFloat(i)
                    bannerScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 4, height: homeTableViewHeaderHeight)
                }
            }

        }
        }
//MARK: ScrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNavigationAlpah()
        setMoveCar()
       }
    func setNavigationAlpah() {
        let currentWidth = HomeTableView.contentOffset.x
        let currentHeight = HomeTableView.contentOffset.y
        print(HomeTableView.contentOffset.y,-homeTableViewHeaderHeight, currentHeight)
        if currentHeight > -homeTableViewHeaderHeight && currentWidth == 0{
               if currentHeight > -homeTableViewHeaderHeight{
                HomeNavigationView.backgroundColor = UIColor(white: 1, alpha: 0 + (homeTableViewHeaderHeight / (-currentHeight * 3)))
                if currentHeight >= -CGFloat(homeTableViewHeaderHeight/3) {
                    if currentWidth == 0 && currentHeight == 0{
                        homeNavigationLogo.image = UIImage(named: "logoWhite.png")
                        homeNavigationSearchButton.setBackgroundImage(UIImage(named: "icSearchWhite.png"), for: .normal)
                        homeNavigationNotificationButton.setBackgroundImage(UIImage(named: "icAlarmWhite.png"), for: .normal)
                        HomeNavigationView.removeShadowView()
                    }
                    else {
                        if HomeTableView.contentOffset.y <= -47 && currentHeight == -47{
                            homeNavigationLogo.image = UIImage(named: "logoWhite.png")
                            homeNavigationSearchButton.setBackgroundImage(UIImage(named: "icSearchWhite.png"), for: .normal)
                            homeNavigationNotificationButton.setBackgroundImage(UIImage(named: "icAlarmWhite.png"), for: .normal)
                        }
                        else{
                            homeNavigationLogo.image = UIImage(named: "logo.png")
                            homeNavigationSearchButton.setBackgroundImage(UIImage(named: "iconSearchBlack.png"), for: .normal)
                            homeNavigationNotificationButton.setBackgroundImage(UIImage(named: "iconAlarmBlack.png"), for: .normal)
                            setNavigationViewShadow()
                        }
                    }
                }
                else if currentHeight <= -CGFloat(homeTableViewHeaderHeight/3) {
                    homeNavigationLogo.image = UIImage(named: "logoWhite.png")
                    homeNavigationSearchButton.setBackgroundImage(UIImage(named: "icSearchWhite.png"), for: .normal)
                    homeNavigationNotificationButton.setBackgroundImage(UIImage(named: "icAlarmWhite.png"), for: .normal)
                    HomeNavigationView.removeShadowView()
 
                }
                if currentHeight > 0{
                    HomeNavigationView.backgroundColor = UIColor.white
                }
                else if currentHeight < -homeTableViewHeaderHeight{
                    HomeNavigationView.backgroundColor = .none
                }
                
               }
        }
        else{
            updateHeaderView()
            addContentScrollView()
            HomeNavigationView.backgroundColor = .none
           }

    }
    func setMoveCar() {
        let originalCarConstant = carMoveConstraint.constant
        let sideMargin : CGFloat = 24
        let pageCount : Int = 4
        let currentWidth = bannerScrollView.contentOffset.x
        if bannerScrollView.contentOffset.x > 0{
               if currentWidth < 10000 {
                carMoveConstraint.constant = (currentWidth - sideMargin)/CGFloat(pageCount)
               } else {
                carMoveConstraint.constant = originalCarConstant
               }
           }
        else{
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
extension HomeVC: UITableViewDataSource{
}
extension HomeVC: IsSelectedCVCDelegate{
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

extension HomeVC: CollectionViewCellDelegate{
    func collectionView(collectionviewcell: HomeThemeCVC?, index: Int, didTappedInTableViewCell: HomeThemeTVC) {
        let storyboard = UIStoryboard(name: "ThemePost", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "ThemePostVC") as? ThemePostVC else { return }
        vc.setSelectedTheme(name: (collectionviewcell?.themeLabel.text)!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//postID 넘기기 위한 Delegate 구현
extension HomeVC: PostIdDelegate{

    func sendPostID(data: Int) {
        print("이거임 ~~~~\(data)")
        let nextVC = PostDetailVC()
        nextVC.setPostId(id: data)
        nextVC.modalPresentationStyle = .currentContext
        tabBarController?.present(nextVC, animated: true, completion: nil)
        //navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func sendPostDriveElement(data: DriveElement?) {
        let nextVC = PostDetailVC()
        nextVC.setAdditionalDataOfPost(data: data)
        print("sendPostDriveElement | 이거 잘 불렸나?? \(data)")
        nextVC.modalPresentationStyle = .currentContext
        tabBarController?.present(nextVC, animated: true, completion: nil)
    }
}

extension HomeVC: AnimateIndicatorDelegate{
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
