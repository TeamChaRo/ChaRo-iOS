//
//  Extension+UIButton.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/15.
//

import UIKit

extension UIButton {
    
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

    func setEmptyTitleColor(){
        self.setTitleColor(.gray40, for: .normal)
    }
    
    func setEmptyTitleColor(colorNum: Int){
        switch colorNum{
        case 10:
            self.setTitleColor(.gray10, for: .normal)
        case 20:
            self.setTitleColor(.gray20, for: .normal)
        case 30:
            self.setTitleColor(.gray30, for: .normal)
        case 40:
            self.setTitleColor(.gray40, for: .normal)
        case 50:
            self.setTitleColor(.gray50, for: .normal)
        default:
            self.setTitleColor(.gray40, for: .normal)
        }
    }
    
    func setBenefitTitleColor(){
        self.setTitleColor(.mainBlue, for: .normal)
    }
    
}
