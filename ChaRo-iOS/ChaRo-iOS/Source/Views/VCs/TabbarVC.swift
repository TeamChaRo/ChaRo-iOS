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
       
        let postStoryboard = UIStoryboard(name: "PostDetail", bundle: nil)
        let postTab = postStoryboard.instantiateViewController(identifier: "PostDetailVC")
        postTab.tabBarItem = UITabBarItem(title: "나의차로", image: UIImage(named: "tabbarIcMypageInactive"), selectedImage: UIImage(named: "tabbarIcMypageActive"))
        
        
        
        let createStoryboard = UIStoryboard(name: "CreatePost", bundle: nil)
//        let createTab = createStoryboard.instantiateViewController(identifier: CreatePostVC.identifier)
        let createVC = createStoryboard.instantiateViewController(identifier: CreatePostVC.identifier)
        let createTab = UINavigationController(rootViewController: createVC)
        
        createTab.tabBarItem = UITabBarItem(title: "작성하기", image: UIImage(named: "tabbarIcPostWrite"), selectedImage: UIImage(named: "tabbarIcPostWrite"))
        createTab.tabBarItem.imageInsets = UIEdgeInsets(top: -13, left: 0, bottom: 5, right: 0)
        
    
        let tabs = [homeTab, createTab, postTab]
        
        setViewControllers(tabs, animated: true)
        selectedViewController = homeTab
    }
    
}

