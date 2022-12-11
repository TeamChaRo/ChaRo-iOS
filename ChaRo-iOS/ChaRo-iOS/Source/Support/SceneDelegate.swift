//
//  SceneDelegate.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/06/27.
//

import UIKit
import KakaoSDKAuth
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
            if let url = URLContexts.first?.url {
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
        }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLinks, error  in
                
                if UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.isLogin) {
                    guard let components = URLComponents(url: (dynamicLinks?.url)!, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return }
                    for queryItem in queryItems {
                        if queryItem.name == "postId" {
                            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                            let nextVC = storyboard.instantiateViewController(withIdentifier: TabbarVC.identifier)
                            
                            self.window?.rootViewController = nextVC
                            self.window?.makeKeyAndVisible()
                            
                            let postId = Int(queryItem.value ?? "")
                            let detailVC = PostDetailVC(postId: postId ?? 0, isModal: true)
                            detailVC.modalPresentationStyle = .fullScreen
                            nextVC.children[0].present(detailVC, animated: true)
                        }
                    }
                } else {
                    let alertViewController = UIAlertController(title: "", message: "로그인 후 이용가능합니다.",
                                                                preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alertViewController.addAction(okAction)
                    
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let loginVC = storyboard.instantiateViewController(identifier: SNSLoginVC.className)
                    
                    let rootVC = UINavigationController(rootViewController: loginVC)
                    self.window?.rootViewController = rootVC
                    
                    rootVC.present(alertViewController, animated: true)
                }
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}


