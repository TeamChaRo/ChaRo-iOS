//  Copyright 2019 Kakao Corp.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import UIKit

extension UIApplication {

    public class func getMostTopViewController(base: UIViewController? = nil) -> UIViewController? {

        var baseVC: UIViewController?
        if base != nil {
            baseVC = base
        }
        else {
            if #available(iOS 13, *) {
                baseVC = (UIApplication.shared.connectedScenes
                            .compactMap { $0 as? UIWindowScene }
                            .flatMap { $0.windows }
                            .first { $0.isKeyWindow })?.rootViewController
            }
            else {
                baseVC = UIApplication.shared.keyWindow?.rootViewController
            }
        }
        
        if let naviController = baseVC as? UINavigationController {
            return getMostTopViewController(base: naviController.visibleViewController)

        } else if let tabbarController = baseVC as? UITabBarController, let selected = tabbarController.selectedViewController {
            return getMostTopViewController(base: selected)

        } else if let presented = baseVC?.presentedViewController {
            return getMostTopViewController(base: presented)
        }
        return baseVC
    }
}
