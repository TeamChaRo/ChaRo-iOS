//
//  TabbarVCViewController.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/02.
//

import UIKit


class TabbarVC: UITabBarController {
    
    static let identifier = "TabbarVC"
    public var addressMainVC: AddressMainVC?
    public var tabs: [UIViewController] = []
    private var comeBackIndex = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabbar()
        setBackgroundClear()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedViewController = tabs[comeBackIndex]
    }
    func setBackgroundClear() {
        tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
    }
    func setShadow() {
        tabBar.getShadowView(color: UIColor.black.cgColor,
                             masksToBounds: false,
                             shadowOffset: CGSize(width: 0, height: 0),
                             shadowRadius: 10,
                             shadowOpacity: 0.5
        )
    }
    func setRadius() {
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 15
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.clipsToBounds = false
    }
    
    override func viewDidLayoutSubviews() {
        let tabbarY = view.getDeviceHeight()
        let tabbarX = view.getDeviceWidth()
        var tabbarHeight = 100
        setRadius()
        setShadow()
        let frame = CGRect(x: 0,
                                  y: tabbarY - tabbarHeight,
                                  width: tabbarX,
                                  height: tabbarHeight)
        self.tabBar.frame = frame
    }
    
    internal override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "작성하기" {
            let createStoryboard = UIStoryboard(name: "CreatePost", bundle: nil)
            
            let createVC = createStoryboard.instantiateViewController(identifier: CreatePostVC.className)
            let createTab = UINavigationController(rootViewController: createVC)
            
            createTab.modalPresentationStyle = .fullScreen
            self.present(createTab, animated: false, completion: nil)
        } else if item.title == "나의차로" {
            comeBackIndex = 2
        } else {
            comeBackIndex = 0
        }
        print("comeBackIndex = \(comeBackIndex)")
        
    }
    
    
    private func configTabbar() {
        self.view.tintColor = .blue
        self.view.backgroundColor = UIColor.white

        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = homeStoryboard.instantiateViewController(identifier: "HomeVC")
        let homeTab = UINavigationController(rootViewController: homeVC)
        homeTab.tabBarItem = UITabBarItem(title: "구경하기", image: UIImage(named: "tabbarIcHomeInactive"), selectedImage: UIImage(named: "tabbarIcHomeActive"))
        
        
        let createStoryboard = UIStoryboard(name: "CreatePost", bundle: nil)
        
        let createVC = createStoryboard.instantiateViewController(identifier: CreatePostVC.className)
        let createTab = UINavigationController(rootViewController: createVC)
        
        createTab.tabBarItem = UITabBarItem(title: "작성하기", image: UIImage(named: "tabbarIcPostWrite"), selectedImage: UIImage(named: "tabbarIcPostWrite"))
        createTab.tabBarItem.imageInsets = UIEdgeInsets(top: -13, left: 0, bottom: 5, right: 0)
        
        
        let myPageStoryboard = UIStoryboard(name: "MyPage", bundle: nil)
        let myPageVC = myPageStoryboard.instantiateViewController(identifier: "MyPageVC")
        let myPageTab = UINavigationController(rootViewController: myPageVC)
        myPageTab.navigationBar.isHidden = true
        myPageTab.tabBarItem = UITabBarItem(title: "나의차로", image: UIImage(named: "tabbarIcMypageInactive"), selectedImage: UIImage(named: "tabbarIcMypageActive"))
        
        
        tabs = [homeTab,createTab, myPageTab]
        setViewControllers(tabs, animated: true)
        selectedViewController = homeTab
    }
    
}
