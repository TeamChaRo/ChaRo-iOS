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
    
    init() {
        super.init(frame: .zero)
    }
    

}
