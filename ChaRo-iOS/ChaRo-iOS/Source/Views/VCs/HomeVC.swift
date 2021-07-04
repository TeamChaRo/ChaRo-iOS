//
//  HomeVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/01.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var HomeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()

        // Do any additional setup after loading the view.
    }
    
    func setTableView(){
        
        HomeTableView.delegate = self
        HomeTableView.dataSource = self
        
        HomeTableView.registerCustomXib(xibName: "HomeAnimationTVC")
        HomeTableView.registerCustomXib(xibName: "HomeTodayDriveTVC")
        HomeTableView.registerCustomXib(xibName: "HomeThemeTVC")
        HomeTableView.registerCustomXib(xibName: "HomeSquareTVC")
        
    }
}

extension HomeVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView : UITableView, heightForRowAt indextPath: IndexPath) -> CGFloat{
        
        switch indextPath.row {
        
        case 0:
            return UIScreen.main.bounds.height/2
        case 1:
            // 354 / 812
            return UIScreen.main.bounds.height * 0.435
        case 2:
            //일단 몰라서 ..,,
            return UIScreen.main.bounds.height * 0.2
        case 3:
            //일단 몰라서 고정
            return 500
        default:
            return 100
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
            return cell

        case 3:

            let cell: HomeSquareTVC = tableView.dequeueReusableCell(for: indexPath)
            return cell

        default:
            return UITableViewCell()
        }

        
    }
    
    
}
