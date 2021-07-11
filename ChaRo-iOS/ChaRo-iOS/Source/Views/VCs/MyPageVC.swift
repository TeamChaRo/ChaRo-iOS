//
//  MyPageVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/10.
//

import UIKit


class MyPageVC: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var customTabbar: UICollectionView!
    @IBOutlet weak var myTableCollectionView: UICollectionView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var saveTableCollectionView: UICollectionView!
    
    var myCVCCell: HomePostDetailCVC?
    var saveCVCCell: HomePostDetailCVC?
    
    var customTabbarList: [TabbarCVC] = []
    @IBOutlet weak var dropDownTableView: UITableView!
    var myCellIsFirstLoaded: Bool = true
    var saveCellIsFirstLoaded: Bool = true
    var delegate: SetTopTitleDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderView()
        setCircleLayout()
        setCollectionView()
        customTabbarInit()
        setDropDown()


        // Do any additional setup after loading the view.
    }
    
    func setHeaderView(){
        headerView.backgroundColor = .mainBlue
    }
    
    func setDropDown(){
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        dropDownTableView.isHidden = true
        dropDownTableView.registerCustomXib(xibName: "HotDropDownTVC")
        dropDownTableView.clipsToBounds = true
        dropDownTableView.layer.cornerRadius = 10
        dropDownTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        dropDownTableView.separatorStyle = .none
        
    }
    
    func customTabbarInit(){
        guard let MyCell = customTabbar.dequeueReusableCell(withReuseIdentifier: "TabbarCVC", for: [0,0]) as? TabbarCVC else {return}
        guard let SaveCell = customTabbar.dequeueReusableCell(withReuseIdentifier: "TabbarCVC", for: [0,1]) as? TabbarCVC else {return}
        
        customTabbarList.append(MyCell)
        customTabbarList.append(SaveCell)
        
    }
    
    
    
    func setCircleLayout(){
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        profileImageButton.setBackgroundImage(UIImage(named: "camera_mypage_wth_circle.png"), for: .normal)
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageButton.clipsToBounds = true
        profileImageButton.layer.borderWidth = 0
        profileImageButton.layer.borderColor = .none
        profileImageButton.layer.masksToBounds = false
        profileImageButton.layer.cornerRadius = profileImageButton.frame.height/2
    }
    
    func setCollectionView(){
        customTabbar.delegate = self
        customTabbar.dataSource = self
        myTableCollectionView.delegate = self
        myTableCollectionView.dataSource = self
        saveTableCollectionView.delegate = self
        saveTableCollectionView.dataSource = self
        
        customTabbar.tag = 1
        myTableCollectionView.tag = 2
        saveTableCollectionView.tag = 3
        
        customTabbar.layer.addBorder([.bottom], color: UIColor.gray20, width: 1.0)
        customTabbar.registerCustomXib(xibName: "TabbarCVC")
        myTableCollectionView.registerCustomXib(xibName: "MyPagePostCVC")
        myTableCollectionView.registerCustomXib(xibName: "HomePostDetailCVC")
        saveTableCollectionView.registerCustomXib(xibName: "MyPagePostCVC")
        saveTableCollectionView.registerCustomXib(xibName: "HomePostDetailCVC")
    
    }
    

}

extension MyPageVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //커스텀 탭바 설정
        if collectionView.tag == 1{
        switch indexPath.row{
        case 0:
            customTabbarList[0].setSelectedView()
            customTabbarList[1].setDeselectedView()
            customTabbarList[0].setIcon(data: "write_active")
            customTabbarList[1].setIcon(data: "save5_inactive")
            saveTableCollectionView.isHidden = true
        case 1:
            customTabbarList[0].setDeselectedView()
            customTabbarList[1].setSelectedView()
            customTabbarList[0].setIcon(data: "write_inactive")
            customTabbarList[1].setIcon(data: "save5_active")
            saveTableCollectionView.isHidden = false
        default:
            print("Error")
        }
        }
        //밑 컬렉션 뷰 설정
        else {
            
        }

    }
}

extension MyPageVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
        return 2
        }
        else if collectionView.tag == 2{
            return 10
        }
        else{
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let MyCell = myTableCollectionView.dequeueReusableCell(withReuseIdentifier: "MyPagePostCVC", for: indexPath) as? MyPagePostCVC else {return UICollectionViewCell()}
        guard let detailCell = myTableCollectionView.dequeueReusableCell(withReuseIdentifier: "HomePostDetailCVC", for: indexPath) as? HomePostDetailCVC else {return UICollectionViewCell()}
        
        
        //커스텀 탭바 구현
        if collectionView.tag == 1{
        if indexPath.row == 0{
            customTabbarList[0].setSelectedView()
            customTabbarList[0].setIcon(data: "write_active")
            return customTabbarList[0]
        }
        if indexPath.row == 1{
            customTabbarList[1].setIcon(data: "save5_inactive")
            return customTabbarList[1]
        }
        }
        //밑부분 셀 구현
        else if collectionView.tag == 2{
            detailCell.delegate = self
            if indexPath.row == 0{
                if myCellIsFirstLoaded {
                    myCellIsFirstLoaded = false
                    myCVCCell = detailCell
                }
                return detailCell
            }
            else{
            return MyCell
            }
        }
        
        else if collectionView.tag == 3{
            detailCell.delegate = self
            if indexPath.row == 0{
                if saveCellIsFirstLoaded {
                    saveCellIsFirstLoaded = false
                    saveCVCCell = detailCell
                }
            return detailCell
            }
            return MyCell
        }
        
       return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = UIScreen.main.bounds.width
        if collectionView.tag == 1{
        return CGSize(width: width/2, height: 50)
        }
        else {
            if indexPath.row == 0{
                return CGSize(width: width-40, height: 30)
            }
            else{
            return CGSize(width: width, height: 100)
            }
        }
    }
    
}

extension MyPageVC: UICollectionViewDelegateFlowLayout{
    
}

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}

extension MyPageVC: UITableViewDelegate{
    
}
extension MyPageVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: HotDropDownTVC = tableView.dequeueReusableCell(for: indexPath)
            var bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.mainBlue.withAlphaComponent(0.2)
            cell.selectedBackgroundView = bgColorView
            cell.setLabel()
            cell.setCellName(name: "인기순")
            cell.delegate = self
            return cell

        case 1:
            let cell: HotDropDownTVC = tableView.dequeueReusableCell(for: indexPath)
            var bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.mainBlue.withAlphaComponent(0.2)
            cell.selectedBackgroundView = bgColorView
            cell.setCellName(name: "최신순")
            cell.delegate = self
            return cell

        default:
            return UITableViewCell()
    }
    }
    
}

extension MyPageVC: MenuClickedDelegate{
    func menuClicked(){
        dropDownTableView.isHidden = false
    }
    
}

extension MyPageVC: SetTitleDelegate {
    func setTitle(cell: HotDropDownTVC) {
        delegate?.setTopTitle(name: cell.name)
        dropDownTableView.isHidden = true
        myCVCCell?.setTitle(data: cell.name)
        saveCVCCell?.setTitle(data: cell.name)
    }
    
}
