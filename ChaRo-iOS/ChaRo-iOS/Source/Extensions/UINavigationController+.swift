//
//  UINavigationViewController+.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/04/19.
//

import UIKit

extension UINavigationController {
    var previousViewController: UIViewController? {
        self.viewControllers.count > 1 ? self.viewControllers[viewControllers.count - 2] : nil
    }
}
