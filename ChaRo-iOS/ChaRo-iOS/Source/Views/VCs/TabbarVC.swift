//
//  TabbarVCViewController.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/02.
//

import UIKit


class TabbarVC: UITabBarController {
    
    public var addressMainVC: AddressMainVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabbarCustomFrame()
        configTabbar()
    }

    private func setTabbarCustomFrame(){
        let customTabbar = tabBar
        var newFrame = CGRect(x: 0,
                              y: self.view.frame.size.height-150,
                              width:  self.view.frame.size.width,
                              height: 150)
        // 이 로그는 나중에 지울게요!
       //customTabbar.backgroundImage = UIImage(named: "tabbarBackground")
//        newFrame.size.height = 150
//        newFrame.origin.y = self.view.frame.size.height - newFrame.size.height
        customTabbar.frame = newFrame
    }
    
  
    internal override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.title == "작성하기" {
//            tabBar.isHidden = true
//            present(viewControllers[1], animated: true, completion: nil)
            let createStoryboard = UIStoryboard(name: "CreatePost", bundle: nil)

            let createVC = createStoryboard.instantiateViewController(identifier: CreatePostVC.identifier)
            let createTab = UINavigationController(rootViewController: createVC)

            createTab.modalPresentationStyle = .fullScreen
            self.present(createTab, animated: true, completion: nil)
        }
    }
    
    
    private func configTabbar(){
        
        let customTabbar = tabBar
        customTabbar.tintColor = .blue

        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = homeStoryboard.instantiateViewController(identifier: "HomeVC")
        let homeTab = UINavigationController(rootViewController: homeVC)
        homeTab.tabBarItem = UITabBarItem(title: "구경하기", image: UIImage(named: "tabbarIcHomeInactive"), selectedImage: UIImage(named: "tabbarIcHomeActive"))
       
        
<<<<<<< HEAD
        

=======
>>>>>>> develop
        let createStoryboard = UIStoryboard(name: "CreatePost", bundle: nil)

        let createVC = createStoryboard.instantiateViewController(identifier: CreatePostVC.identifier)
        let createTab = UINavigationController(rootViewController: createVC)
        
        createTab.tabBarItem = UITabBarItem(title: "작성하기", image: UIImage(named: "tabbarIcPostWrite"), selectedImage: UIImage(named: "tabbarIcPostWrite"))
        createTab.tabBarItem.imageInsets = UIEdgeInsets(top: -13, left: 0, bottom: 5, right: 0)
        
<<<<<<< HEAD

        
=======
>>>>>>> develop
        
        let myPageStoryboard = UIStoryboard(name: "MyPage", bundle: nil)
        let myPageTab = myPageStoryboard.instantiateViewController(identifier: "MyPageVC")
        myPageTab.tabBarItem = UITabBarItem(title: "나의차로", image: UIImage(named: "tabbarIcMypageInactive"), selectedImage: UIImage(named: "tabbarIcMypageActive"))
        

<<<<<<< HEAD
//
//        mapTab.tabBarItem.image = UIImage(named: "tabbarIcPostWrite")
//        mapTab.tabBarItem.title = "작성하기"
//        mapTab.tabBarItem.imageInsets = UIEdgeInsets(top: -13, left: 0, bottom: 5, right: 0)
//
        
//        let mapStoryboard = UIStoryboard(name: "AddressMain", bundle: nil)
//        let mapTab = mapStoryboard.instantiateViewController(identifier: AddressMainVC.identifier) as! AddressMainVC
//        addressMainVC = mapTab
//
//        mapTab.tabBarItem.image = UIImage(named: "tabbarIcPostWrite")
//        mapTab.tabBarItem.title = "작성하기"
//        mapTab.tabBarItem.imageInsets = UIEdgeInsets(top: -13, left: 0, bottom: 5, right: 0)
//
        
//        let writtingTab = postStoryboard.instantiateViewController(identifier: "PostDetailVC")
//        writtingTab.tabBarItem.image = UIImage(named: "tabbarIcPostWrite")
//        writtingTab.tabBarItem.title = "작성하기"
//        writtingTab.tabBarItem.imageInsets = UIEdgeInsets(top: -13, left: 0, bottom: 5, right: 0)
        
        let tabs = [homeTab, createTab, myPageTab]

=======
        let tabs = [homeTab,createTab, myPageTab]
>>>>>>> develop
        
        setViewControllers(tabs, animated: true)
        selectedViewController = homeTab
    }
    
}

