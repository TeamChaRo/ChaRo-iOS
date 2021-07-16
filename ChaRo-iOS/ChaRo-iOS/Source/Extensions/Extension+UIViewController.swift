//
//  Extension+UIViewController.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/16.
//

import Foundation
import UIKit

extension UIViewController {
    
    func makeRequestAlert(title : String,
                          message : String,
                          okAction : ((UIAlertAction) -> Void)?,
                          cancelAction : ((UIAlertAction) -> Void)? = nil,
                          completion : (() -> Void)? = nil){
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "예", style: .default, handler: okAction)
        alertViewController.addAction(okAction)
        
        
        let cancelAction = UIAlertAction(title: "아니오", style: .default, handler: cancelAction)
        alertViewController.addAction(cancelAction)
        
        
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    
    func makeAlert(title : String,
                   message : String,
                   okAction : ((UIAlertAction) -> Void)? = nil,
                   completion : (() -> Void)? = nil){
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okAction)
        alertViewController.addAction(okAction)
        
        
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    func makeAlert(title : String?,
                   message : String?,
                   okAction : ((UIAlertAction) -> Void)? = nil,
                   completion : (() -> Void)? = nil){
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertViewController = UIAlertController(title: "", message: message,
                                                    preferredStyle: .alert)
        
        
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okAction)
        alertViewController.addAction(okAction)
        
        
        self.present(alertViewController, animated: true, completion: completion)
    }
    
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
