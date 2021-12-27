//
//  JoinTitleLabel.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/01.
//

enum JoinTitleLabelType {
    case boldTitle
    case normalTitle
}

import UIKit

class JoinTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(type: JoinTitleLabelType, title: String) {
        super.init(frame: .zero)
        
        self.text = title
        
        switch type {
        
        case .boldTitle:
            self.font = .notoSansBoldFont(ofSize: 17)
            self.textColor = .mainBlack
            
        case .normalTitle:
            self.font = .notoSansRegularFont(ofSize: 14)
            self.textColor = .gray50
        }
    }
    

}
