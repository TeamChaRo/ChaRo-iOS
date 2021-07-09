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
        setTableViewTag()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    //MARK:- IBAction
    
    
    
    //MARK:- default Setting Function Part
    func setTableViewTag(){
        tableView.tag = 1
        dropDownTableView.tag = 2
    }
    
    func setTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCustomXib(xibName: "ThemePostThemeTVC")
        tableView.registerCustomXib(xibName: "ThemePostAllTVC")
        tableView.registerCustomXib(xibName: "ThemePostDetailTVC")


        
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none

        
    }
    
    
    func setShaow(){
        navigationView.getShadowView(color: UIColor.black.cgColor, masksToBounds: false, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8, shadowOpacity: 0.3)
    }
    
    func setdropDownTableView() {
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        dropDownTableView.clipsToBounds = true
        dropDownTableView.layer.cornerRadius = 20
        dropDownTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        dropDownTableView.isHidden = true
        dropDownTableView.registerCustomXib(xibName: "HotDropDownTVC")
        dropDownTableView.separatorStyle = .none
    }
    
    func setTitleLabel() {
        titleLabel.font = .notoSansMediumFont(ofSize: 17)
    }
    
    

    //MARK:- Function
}


//MARK:- extension

extension ThemePostVC: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView.tag == 2{
                return 2
            }
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        
        print(tableView.tag)
        
        if tableView.tag == 2{
            print(indexPath.row)
            switch indexPath.row {
            case 0:
                let cell: HotDropDownTVC = dropDownTableView.dequeueReusableCell(for: indexPath)
                return cell
            default:
                let cell: HotDropDownTVC = dropDownTableView.dequeueReusableCell(for: indexPath)
                return cell
            }
           
        }

        if tableView.tag == 1{
        
        switch indexPath.row {
        case 0:
            let cell: ThemePostThemeTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.setTVCHeight(height: Double(UIScreen.main.bounds.height) * 0.1434)
            return cell
        case 1:
            let cell: ThemePostDetailTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case 2:
            let cell: ThemePostAllTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.cellDelegate = self
            return cell
            
        default:
            return UITableViewCell()
        }
        }
        return UITableViewCell()

     
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 2{
            print("dd")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag == 2{
            return 44
        }
        
        
        var topBarHeight = 100
        let factor = UIScreen.main.bounds.width / 375
        
        switch indexPath.row {
        
        case 0:
            //116 / 812
            return 118 * factor
        case 1:
            return 50
        case 2:
            return UIScreen.main.bounds.height - 100 - 118
        default:
            return 118
        }
        
    }
    
    
    
    
}


extension ThemePostVC: ThemeCollectionViewCellDelegate {

    
    
    func collectionView(collectionviewcell: HomePostDetailCVC?, index: Int, didTappedInTableViewCell: ThemePostAllTVC, button: UIButton!) {
       
        var isButtonClicked = (collectionviewcell?.isButtonClicked)!
        
        collectionviewcell?.selectButton.addTarget(self, action: #selector(buttonClicked(isButtonClicked:)), for: .touchUpInside)
        
    }
    
    
    @objc func buttonClicked(isButtonClicked: Bool) {
        
        print(isButtonClicked)
        
        if isButtonClicked == false {
            dropDownTableView.isHidden = true
        } else {
            dropDownTableView.isHidden = false
        }
    }
    
    
}

extension ThemePostVC: MenuClickedDelegate{
    func menuClicked() {
        dropDownTableView.isHidden = false
        dropDownTableView.reloadData()
    }
    
    
}
