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
        setActionToSearchButton()
        
        navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("뷰디드어피어")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("뷰 윌 어피어")
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("뷰 디드 디사피어")
    }
    
    
    
    func setHomeNavigationViewLayout(){
        HomeNavigationView.backgroundColor = .none

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
                    for i in 0 ... 3{
                        cell.setData(imageName: bannerData[i].bannerImage, title: bannerData[i].bannerTitle, tag: bannerData[i].bannerTag)
                    }
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
                for image in todayData{
                    cell.imageNameText.append(image.image)
                }
                for title in todayData{
                    cell.titleText.append(title.title)
                }
                //해 쉬 태 그
                for i in 0 ... todayData[0].tags.count-1{
                    cell.hashTagText1.append(todayData[0].tags[i].rawValue)
                }
                
                if cell.hashTagText1.count == 2{
                    cell.hashTagText1.append("")
                }
                
                for i in 0 ... todayData[1].tags.count-1{
                    cell.hashTagText2.append(todayData[1].tags[i].rawValue)
                }
                
                if cell.hashTagText2.count == 2{
                    cell.hashTagText2.append("")
                }
                
                for i in 0 ... todayData[2].tags.count-1{
                    cell.hashTagText3.append(todayData[2].tags[i].rawValue)
                }
                
                if cell.hashTagText3.count == 2{
                    cell.hashTagText3.append("")
                }
                
                for i in 0 ... todayData[3].tags.count-1{
                    cell.hashTagText4.append(todayData[3].tags[i].rawValue)
                }
                
                if cell.hashTagText4.count == 2{
                    cell.hashTagText4.append("")
                }
            //heart
                for heart in todayData{
                    cell.heart.append(heart.isFavorite)
                }
            return cell
            }
        
        

        case 2:

            let cell: HomeThemeTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.cellDelegate = self
            return cell
            
//MARK: 트렌드
        case 3:

            let cell: HomeSquareTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.ButtonDelegate = self
            if trendyData.count == 0{
                return cell
            }
            else{
                for image in trendyData{
                    cell.imageNameText.append(image.image)
                }
                for title in trendyData{
                    cell.titleText.append(title.title)
                }
                //해 쉬 태 그
                for i in 0 ... trendyData[0].tags.count-1{
                    cell.hashTagText1.append(trendyData[0].tags[i].rawValue)
                }
                
                if cell.hashTagText1.count == 2{
                    cell.hashTagText1.append("")
                }
            
                for i in 0 ... trendyData[1].tags.count-1{
                    cell.hashTagText2.append(trendyData[1].tags[i].rawValue)
                }
                
                if cell.hashTagText2.count == 2{
                    cell.hashTagText2.append("")
                }
                
                for i in 0 ... trendyData[2].tags.count-1{
                    cell.hashTagText3.append(trendyData[2].tags[i].rawValue)
                }
                
                if cell.hashTagText3.count == 2{
                    cell.hashTagText3.append("")
                }
                
                for i in 0 ... trendyData[3].tags.count-1{
                    cell.hashTagText4.append(trendyData[3].tags[i].rawValue)
                }
                
                if cell.hashTagText4.count == 2{
                    cell.hashTagText4.append("")
                }
            //heart
                for heart in trendyData{
                    cell.heart.append(heart.isFavorite)
                }
            return cell
            }

            
//MARK: 커스텀 테마
        case 4:

            let cell: HomeSeasonRecommandTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.buttonDelegate = self
            cell.headerText = customText
            if customData.count == 0{
                return cell
            }
            else{
                for image in customData{
                    cell.imageNameText.append(image.image)
                }
                for title in customData{
                    cell.titleText.append(title.title)
                }
                //해 쉬 태 그
                for i in 0 ... customData[0].tags.count-1{
                    cell.hashTagText1.append(customData[0].tags[i].rawValue)
                }
                
                if cell.hashTagText1.count == 2{
                    cell.hashTagText1.append("")
                }
            
                for i in 0 ... customData[1].tags.count-1{
                    cell.hashTagText2.append(customData[1].tags[i].rawValue)
                }
                
                if cell.hashTagText2.count == 2{
                    cell.hashTagText2.append("")
                }
                
                for i in 0 ... customData[2].tags.count-1{
                    cell.hashTagText3.append(customData[2].tags[i].rawValue)
                }
                
                if cell.hashTagText3.count == 2{
                    cell.hashTagText3.append("")
                }
                
                for i in 0 ... customData[3].tags.count-1{
                    cell.hashTagText4.append(customData[3].tags[i].rawValue)
                }
                
                if cell.hashTagText4.count == 2{
                    cell.hashTagText4.append("")
                }
            //heart
                for heart in customData{
                    cell.heart.append(heart.isFavorite)
                }
            return cell
            }
           
//MARK: 로컬 테마
        case 5:

            let cell: HomeAreaRecommandTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.buttonDelegate = self
            cell.headerText = localText
            print("로컬 뷰 시작")
            if localData.count == 0{
                return cell
            }
            else{
                for image in localData{
                    cell.imageNameText.append(image.image)
                }
                for title in localData{
                    cell.titleText.append(title.title)
                }
                //해 쉬 태 그
                for i in 0 ... localData[0].tags.count-1{
                    cell.hashTagText1.append(localData[0].tags[i].rawValue)
                }
                
                if cell.hashTagText1.count == 2{
                    cell.hashTagText1.append("")
                }
            
                for i in 0 ... localData[1].tags.count-1{
                    cell.hashTagText2.append(localData[1].tags[i].rawValue)
                }
                
                if cell.hashTagText2.count == 2{
                    cell.hashTagText2.append("")
                }
                
                for i in 0 ... localData[2].tags.count-1{
                    cell.hashTagText3.append(localData[2].tags[i].rawValue)
                }
                
                if cell.hashTagText3.count == 2{
                    cell.hashTagText3.append("")
                }
                
                for i in 0 ... localData[3].tags.count-1{
                    cell.hashTagText4.append(localData[3].tags[i].rawValue)
                }
                
                if cell.hashTagText4.count == 2{
                    cell.hashTagText4.append("")
                }
            //heart
                for heart in localData{
                    cell.heart.append(heart.isFavorite)
                }
            return cell
            }
        default:
            print("Error")
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
            HomePostVC.topText = customText
        case 5:
            HomePostVC.topText = localText
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
            smVC.topText = customText
        case 5:
            smVC.topText = localText
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
        
        if let labelText = collectionviewcell?.themeLabel.text {
                print("You tapped the cell \(index) in the row of Label \(labelText)")
                // 여기서 CVC 클릭했을 때 할 거 쓰기
            }
        }
    
}

