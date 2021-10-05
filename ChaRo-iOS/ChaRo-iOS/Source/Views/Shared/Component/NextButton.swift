//
//  NextButton.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit

class NextButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(isSticky: Bool) {
        super.init(frame: .zero)
        configureUI(isSticky: isSticky)
    }
    
    private func configureUI(isSticky: Bool) {
        
        self.setTitle("다음", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .gray30
        
        if isSticky {
            self.titleLabel?.font = .notoSansBoldFont(ofSize: 16)
        } else {
            self.clipsToBounds = true
            self.layer.cornerRadius = 10
        }
    }

}
