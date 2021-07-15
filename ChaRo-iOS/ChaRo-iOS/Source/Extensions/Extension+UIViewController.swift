//
//  Extension+UIViewController.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/16.
//

import Foundation
import UIKit

extension UIViewController {
    
    public func setMainNavigationViewUI(height: NSLayoutConstraint, fromTopToImageView: NSLayoutConstraint) {
        
        if !UIScreen.hasNotch {
            height.constant = 93
            fromTopToImageView.constant = 39
            print("노치 없음")
        }
        
    }
    
    
    public func setDetailNavigationViewUI(height: NSLayoutConstraint, fromBottomToTitle: NSLayoutConstraint) {
        
        if !UIScreen.hasNotch {
            height.constant = 93
            fromBottomToTitle.constant = 26
            print("노치 없음")
        }
        
    }
    
}
