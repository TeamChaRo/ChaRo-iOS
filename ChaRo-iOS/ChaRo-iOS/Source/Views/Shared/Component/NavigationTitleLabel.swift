//
//  NavigationTitleLabel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/11.
//

import UIKit

class NavigationTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, color: UIColor){
        super.init(frame: .zero)
        text = title
        textColor = color
        font = .notoSansMediumFont(ofSize: 17)
        textAlignment = .center
    }
    
}
