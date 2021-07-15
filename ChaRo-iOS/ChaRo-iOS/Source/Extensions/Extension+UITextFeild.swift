//
//  Extension+UITextFeild.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/03.
//

import UIKit

extension UITextField{
    func addLeftPadding(_ amount:CGFloat){ //왼쪽에 여백 주기
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func addRightPadding(_ amount:CGFloat) { //오른쪽에 여백 주기
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setGray20Border(_ radius: CGFloat) {
        self.layer.borderColor = UIColor.gray20.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = radius
    }
    
    func setMainBlueBorder(_ radius: CGFloat) {
        self.layer.borderColor = UIColor.mainBlue.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = radius
    }

}
