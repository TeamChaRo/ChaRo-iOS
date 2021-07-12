//
//  HomeVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/01.
//
//
//let banner: [Banner]
//let todayCharoDrive, trendDrive: [Drive]
//let customThemeTitle: String
//let customThemeDrive: [Drive]
//let localTitle: String
//let localDrive: [Drive]

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var HomeTableView: UITableView!
    @IBOutlet weak var HomeNavigationView: UIView!
    @IBOutlet weak var homeNavigationLogo: UIImageView!
    @IBOutlet weak var homeNavigationSearchButton: UIButton!
    @IBOutlet weak var homeNavigationNotificationButton: UIButton!
    
    var isFirstSetData: Bool = true
    
    ///배너 데이타
    var bannerData: [Banner] = []
    var todayData: [Drive] = []
    var trendyData: [Drive] = []
    var customData: [Drive] = []
    var localData: [Drive] = []
    
    var customText: String = ""
    var localText: String = ""
    
    var tableIndex: IndexPath = [0,0]
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setTableView()
        setHomeNavigationViewLayout()
        
        navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    func setHomeNavigationViewLayout(){
        HomeNavigationView.backgroundColor = .none

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func getData(){
        GetHomeDataService.HomeData.getRecommendInfo{ (response) in
            switch response
            {
            case .success(let data) :
                if let response = data as? HomeDataModel{
                    
                        let data = response.data
                        //배너 타이틀
                        self.bannerData.append(data.banner[0])
                        self.bannerData.append(data.banner[1])
                        self.bannerData.append(data.banner[2])
                        self.bannerData.append(data.banner[3])
                    //today 차로
                    self.todayData.append(data.todayCharoDrive[0])
                    self.todayData.append(data.todayCharoDrive[1])
                    self.todayData.append(data.todayCharoDrive[2])
                    self.todayData.append(data.todayCharoDrive[3])
                    //trendy 차로
                    self.trendyData.append(data.trendDrive[0])
                    self.trendyData.append(data.trendDrive[1])
                    self.trendyData.append(data.trendDrive[2])
                    self.trendyData.append(data.trendDrive[3])
        
                    //custom 차로
                    self.customData.append(data.customThemeDrive[0])
                    self.customData.append(data.customThemeDrive[1])
                    self.customData.append(data.customThemeDrive[2])
                    self.customData.append(data.customThemeDrive[3])
                    self.customText = data.customThemeTitle
                    //local 차로
                    self.localData.append(data.localDrive[0])
                    self.localData.append(data.localDrive[1])
                    self.localData.append(data.localDrive[2])
                    self.localData.append(data.localDrive[3])
                    self.localText = data.localTitle
                    
                    
                    DispatchQueue.main.async {
                        print("리로드")
                        self.HomeTableView.reloadData()
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
}

extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView : UITableView, heightForRowAt indextPath: IndexPath) -> CGFloat{
        
        let factor = UIScreen.main.bounds.width / 375
        let homeBannerRatio: CGFloat = 0.65
        
        switch indextPath.row {
    
        case 0:
            return UIScreen.main.bounds.height * homeBannerRatio
        case 1:
            return 353 * factor
        case 2:
            return 178 * factor
        case 3, 4, 5:
            return 570 * factor
        default:
            return 100
        }
        
    }
    func setNavigationViewShadow(){
        //shadowExtension 예제
        HomeNavigationView.getShadowView(color: UIColor.black.cgColor, masksToBounds: false, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8, shadowOpacity: 0.3)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//스크롤뷰에 따라서 알파값 조정함
        let userHeight = HomeNavigationView.getDeviceHeight()
        let standardHeight = userHeight/2
        let currentHeight = scrollView.contentOffset.y
        if scrollView.contentOffset.y > 0{
               if scrollView.contentOffset.y > 1 {
                HomeNavigationView.backgroundColor = UIColor(white: 1, alpha: 0.01 + (scrollView.contentOffset.y / CGFloat(standardHeight)))
                
                if currentHeight >= CGFloat(standardHeight){
                    homeNavigationLogo.image = UIImage(named: "logo.png")
                    homeNavigationSearchButton.setBackgroundImage(UIImage(named: "iconSearchBlack.png"), for: .normal)
                    homeNavigationNotificationButton.setBackgroundImage(UIImage(named: "iconAlarmBlack.png"), for: .normal)
                    setNavigationViewShadow()
                }
                else if currentHeight <= CGFloat(standardHeight){
                    homeNavigationLogo.image = UIImage(named: "logoWhite.png")
                    homeNavigationSearchButton.setBackgroundImage(UIImage(named: "icSearchWhite.png"), for: .normal)
                    homeNavigationNotificationButton.setBackgroundImage(UIImage(named: "icAlarmWhite.png"), for: .normal)
                    HomeNavigationView.removeShadowView()
                }
               
                
               } else {
                HomeNavigationView.backgroundColor = .none
               }
           }
        else{
            HomeNavigationView.backgroundColor = .none
           }

       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
//MARK: 내용 구현 부
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableview indexPath
        tableIndex = indexPath
//MARK: 배너부분 구현
        switch indexPath.row {
        case 0:
            let cell: HomeAnimationTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.setDelegate()
            
            if bannerData.count == 0{
                return cell
            }
            
            else{
                
                if isFirstSetData{
                    print("홈브씨")
                    cell.setData(imageName: bannerData[0].bannerImage, title: bannerData[0].bannerTitle, tag: bannerData[0].bannerTag)
                    cell.setData(imageName: bannerData[1].bannerImage, title: bannerData[1].bannerTitle, tag: bannerData[1].bannerTag)
                    cell.setData(imageName: bannerData[2].bannerImage, title: bannerData[2].bannerTitle, tag: bannerData[2].bannerTag)
                    cell.setData(imageName: bannerData[3].bannerImage, title: bannerData[3].bannerTitle, tag: bannerData[3].bannerTag)
                    isFirstSetData = false
                    return cell
                }
         
                
            }
//MARK: 오늘의 드라이브
        case 1:
            let cell: HomeTodayDriveTVC = tableView.dequeueReusableCell(for: indexPath)
            //image
            if todayData.count == 0{
                return cell
            }
            else{
            cell.imageNameText.append(todayData[0].image)
            cell.imageNameText.append(todayData[1].image)
            cell.imageNameText.append(todayData[2].image)
            cell.imageNameText.append(todayData[3].image)
            //title
            cell.titleText.append(todayData[0].title)
            cell.titleText.append(todayData[1].title)
            cell.titleText.append(todayData[2].title)
            cell.titleText.append(todayData[3].title)
            //hashTag
                cell.hashTagText.append(todayData[0].tags[0].rawValue)
            cell.hashTagText.append(todayData[0].tags[1].rawValue)
            cell.hashTagText.append(todayData[0].tags[2].rawValue)
            cell.hashTagText.append(todayData[1].tags[0].rawValue)
            cell.hashTagText.append(todayData[1].tags[1].rawValue)
            cell.hashTagText.append(todayData[2].tags[0].rawValue)
            cell.hashTagText.append(todayData[2].tags[1].rawValue)
//            cell.hashTagText.append(todayData[2].tags[2].rawValue)
            cell.hashTagText.append(todayData[3].tags[0].rawValue)
            cell.hashTagText.append(todayData[3].tags[1].rawValue)
//            cell.hashTagText.append(todayData[3].tags[2].rawValue)
            //heart
            cell.heart.append(todayData[0].isFavorite)
            cell.heart.append(todayData[1].isFavorite)
            cell.heart.append(todayData[2].isFavorite)
            
            
            return cell
            }
        
        
//MARK: 테마
        case 2:

            let cell: HomeThemeTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.cellDelegate = self
            return cell

        case 3:

            let cell: HomeSquareTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.ButtonDelegate = self
            return cell
            
        case 4:

            let cell: HomeSeasonRecommandTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.buttonDelegate = self
            return cell
           
        case 5:

            let cell: HomeAreaRecommandTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.buttonDelegate = self
            return cell
           
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }

}
extension HomeVC : IsSelectedCVCDelegate {
    func isSelectedCVC(indexPath: IndexPath) {
        guard let HomePostVC = UIStoryboard(name: "HomePost", bundle: nil).instantiateViewController(identifier: "HomePostVC") as? HomePostVC else {return}
        //tableview indexPath에 따라ㅏ 받아오고, 나중에 서버랑 연결되면 거기서 또 테이블 뷰 셀이랑 연동하면 될듯~!
        print(tableIndex.row)
        
        switch tableIndex.row {
        case 3:
            HomePostVC.topText = "요즘 뜨는 드라이브 코스"
        case 4:
            HomePostVC.topText = "여름맞이 야간 드라이브"
        case 5:
            HomePostVC.topText = "경기도 드라이브 코스"
        default:
           print("Error")
        }
        self.navigationController?.pushViewController(HomePostVC, animated: true)
    }
}

extension HomeVC: SeeMorePushDelegate{
    func seeMorePushDelegate(data: Int) {
        guard let smVC = UIStoryboard(name: "HomePost", bundle: nil).instantiateViewController(identifier: "HomePostVC") as? HomePostVC else {return}
        
        switch data {
        case 3:
            smVC.topText = "요즘 뜨는 드라이브 코스"
        case 4:
            smVC.topText = "여름맞이 야간 드라이브"
        case 5:
            smVC.topText = "경기도 드라이브 코스"
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
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        if let labelText = collectionviewcell?.themeLabel.text {
                print("You tapped the cell \(index) in the row of Label \(labelText)")
                // 여기서 CVC 클릭했을 때 할 거 쓰기
            }
        }
    
}

