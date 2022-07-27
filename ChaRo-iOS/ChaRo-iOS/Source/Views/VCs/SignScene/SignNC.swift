//
//  SignNC.swift
//  ChaRo-iOS
//
//  Created by hwangJi on 2022/04/26.
//

import UIKit

class SignNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.viewControllers[0].isKind(of: OnBoardVC.self) && UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.onBoardSeen) {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: SNSLoginVC.className)
            self.pushViewController(nextVC, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
