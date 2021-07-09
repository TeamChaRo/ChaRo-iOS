//
//  ThemePostVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/07.
//

import UIKit

class ThemePostVC: UIViewController {

    
    //MARK:- IBOutlet
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropDownTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK:- Variable
    

    //MARK:- Constraint
    
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        setTableView()
        setdropDownTableView()
        setTitleLabel()
        setShaow()
    }

    //MARK:- IBAction
    
    
    
    //MARK:- default Setting Function Part
    func setTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCustomXib(xibName: "ThemePostThemeTVC")
        tableView.registerCustomXib(xibName: "ThemePostAllTVC")
        
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none

    }
    
    
    func setShaow(){
        navigationView.getShadowView(color: UIColor.black.cgColor, masksToBounds: false, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8, shadowOpacity: 0.3)
    }
    
    func setdropDownTableView() {
        
        dropDownTableView.isHidden = true
        dropDownTableView.registerCustomXib(xibName: "ThemePostThemeTVC")
        
    }
    
    func setTitleLabel() {
        titleLabel.font = .notoSansMediumFont(ofSize: 17)
    }
    
    

    //MARK:- Function
}


//MARK:- extension

extension ThemePostVC: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell: ThemePostThemeTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.setTVCHeight(height: Double(UIScreen.main.bounds.height) * 0.1434)
            return cell
            
        case 1:
            let cell: ThemePostAllTVC = tableView.dequeueReusableCell(for: indexPath)
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var topBarHeight = 100
        let factor = UIScreen.main.bounds.width / 375
        
        switch indexPath.row {
        
        case 0:
            //116 / 812
            return 118 * factor
        case 1:
            return UIScreen.main.bounds.height - 100 - 118
        default:
            return 118
        }
        
    }
    
    
    
    
}

extension ThemePostVC: MenuClickedDelegate {
    func menuClicked(){
        dropDownTableView.isHidden = false
    }
    
}
