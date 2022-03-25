//
//  Extension+UITextView.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/12.
//

import UIKit

extension UITextView {
    
    func addPadding(left: CGFloat, right: CGFloat) {
        self.textContainerInset = UIEdgeInsets(top: 10, left: left, bottom: 10, right: right)
    }
    
    func placeholder() {
        self.textColor = UIColor.gray30
    }
    
    func removePlaceholder() {
        self.textColor = .black
    }
    
}
