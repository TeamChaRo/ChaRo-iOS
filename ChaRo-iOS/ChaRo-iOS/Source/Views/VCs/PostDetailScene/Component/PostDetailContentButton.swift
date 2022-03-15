//
//  PostDetailContentButton.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/15.
//

import UIKit

final class PostDetailContentButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String, isSelected: Bool){
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.isSelected = isSelected
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
            
    private func configureUI(){
        self.isUserInteractionEnabled = false
        self.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        self.layer.cornerRadius = 21
        self.layer.borderWidth = 1
        self.layer.borderColor = isSelected ? UIColor.mainSkyBlue.cgColor : UIColor.gray30.cgColor
        self.setTitleColor(.gray50, for: .selected)
        self.setTitleColor(.gray30, for: .normal)
    }
    
    public func clearUI(){
        self.setTitleColor(.clear, for: .normal)
        self.layer.borderWidth = 0
    }
}
