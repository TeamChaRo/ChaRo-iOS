//
//  ThemePostVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/07.
//

import UIKit

class ThemePostVC: UIViewController {

    
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variable
    

    //MARK:- Constraint
    
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        setTableView()
    }

    //MARK:- IBAction
    
    
    
    //MARK:- default Setting Function Part
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCustomXib(xibName: "ThemePostThemeTVC")
        //tableView.registerCustomXib(xibName: "")
        
    }

    //MARK:- Function
}


//MARK:- extension

extension ThemePostVC: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 10
        default:
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell: ThemePostThemeTVC = tableView.dequeueReusableCell(for: indexPath)
            return cell
            
//        case 1:
//            let cell: HomeAnimationTVC = tableView.dequeueReusableCell(for: indexPath)
//            cell.setDelegate()
//            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
        
    }
    
    
    
    
}

