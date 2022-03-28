//
//  UIStackView+.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/15.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(views: [UIView]) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
    
}
