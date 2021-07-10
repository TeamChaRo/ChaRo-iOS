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
    @IBOutlet weak var TableCollectionView: UICollectionView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    
    var customTabbarList: [TabbarCVC] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderView()
        setCircleLayout()
        setCollectionView()
        customTabbarInit()


        // Do any additional setup after loading the view.
    }
    
    func setHeaderView(){
        headerView.backgroundColor = .mainBlue
        
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
        customTabbar.layer.addBorder([.bottom], color: UIColor.gray20, width: 1.0)
        customTabbar.registerCustomXib(xibName: "TabbarCVC")
        TableCollectionView.registerCustomXib(xibName: "MyPagePostCVC")
    }
    

}

extension MyPageVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        switch indexPath.row{
        case 0:
            customTabbarList[0].setSelectedView()
            customTabbarList[1].setDeselectedView()
            customTabbarList[0].setIcon(data: "write_active")
            customTabbarList[1].setIcon(data: "save5_inactive")
        case 1:
            customTabbarList[0].setDeselectedView()
            customTabbarList[1].setSelectedView()
            customTabbarList[0].setIcon(data: "write_inactive")
            customTabbarList[1].setIcon(data: "save5_active")
        default:
            customTabbarList[0].setSelectedView()
        }

    }
}

extension MyPageVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0{
            customTabbarList[0].setSelectedView()
            customTabbarList[0].setIcon(data: "write_active")
//            customTabbarList[1].setIcon(data: "save5_inactive")
            return customTabbarList[0]
        }
        if indexPath.row == 1{
            customTabbarList[1].setIcon(data: "save5_inactive")
            return customTabbarList[1]
        }
        else{
            return UICollectionViewCell()
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = UIScreen.main.bounds.width/2

        return CGSize(width: width, height: 50)
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

