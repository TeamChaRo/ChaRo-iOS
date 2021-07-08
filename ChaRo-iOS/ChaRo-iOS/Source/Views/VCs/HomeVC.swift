//
//  HomeVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/01.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var HomeTableView: UITableView!
    @IBOutlet weak var HomeNavigationView: UIView!
    @IBOutlet weak var homeNavigationLogo: UIImageView!
    @IBOutlet weak var homeNavigationSearchButton: UIButton!
    @IBOutlet weak var homeNavigationNotificationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setHomeNavigationViewLayout()
    }
    
    func setHomeNavigationViewLayout(){
        HomeNavigationView.backgroundColor = .none

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
        
        switch indextPath.row {
    
        case 0:
            return UIScreen.main.bounds.height * 0.65
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let VC = UIStoryboard(name: "HomePost", bundle: nil).instantiateViewController(identifier: "HomePostVC") as? HomePostVC else {return}
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:

            let cell: HomeAnimationTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.setDelegate()
            return cell

        case 1:

            let cell: HomeTodayDriveTVC = tableView.dequeueReusableCell(for: indexPath)
            return cell

        case 2:

            let cell: HomeThemeTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.cellDelegate = self
            return cell

        case 3:

            let cell: HomeSquareTVC = tableView.dequeueReusableCell(for: indexPath)
            return cell
            
        case 4:

            let cell: HomeSeasonRecommandTVC = tableView.dequeueReusableCell(for: indexPath)
            return cell
           
        case 5:

            let cell: HomeAreaRecommandTVC = tableView.dequeueReusableCell(for: indexPath)
            return cell
           

        default:
            return UITableViewCell()
        }

        
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

