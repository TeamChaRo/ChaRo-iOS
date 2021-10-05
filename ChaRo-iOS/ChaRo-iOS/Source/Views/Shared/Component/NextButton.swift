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
    
    init(toPop vc: UIViewController) {
        super.init(frame: .zero)
        configureUI()
    }
    
    private func configureUI() {
        self.setTitle("다음", for: .normal)
        self.backgroundColor = .gray30
        self.setTitleColor(.white, for: .normal)
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }

}
