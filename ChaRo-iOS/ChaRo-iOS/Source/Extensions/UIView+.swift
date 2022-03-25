//
//  Extension+UIView.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/06/29.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
    
    func removeAllSubViews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func getDeviceHeight() -> Int {
        return Int(UIScreen.main.bounds.height)
        }
    func getDeviceWidth() -> Int {
        return Int(UIScreen.main.bounds.width)
    }
    
    func getShadowView(color : CGColor, masksToBounds : Bool, shadowOffset : CGSize, shadowRadius : Int, shadowOpacity : Float) {
        layer.shadowColor = color
        layer.masksToBounds = masksToBounds
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = CGFloat(shadowRadius)
        layer.shadowOpacity = shadowOpacity
    }
    func removeShadowView() {
        layer.shadowOpacity = 0
    }
    
    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: UIScreen.getDeviceWidth() / 2 - 100,
                                               y: UIScreen.getDeviceHeight() - 150,
                                               width: 200, height: 35)).then {
            $0.backgroundColor = .gray40
            $0.textColor = UIColor.white
            $0.font = .notoSansRegularFont(ofSize: 14)
            $0.textAlignment = .center
            $0.text = message
            $0.alpha = 1.0
            $0.layer.cornerRadius = 17;
            $0.clipsToBounds = true
        }
        
        self.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0,
                       delay: 0.5, options: .curveEaseOut,
                       animations: { toastLabel.alpha = 0.0 },
                       completion: {(isCompleted) in toastLabel.removeFromSuperview() })
    }
}

