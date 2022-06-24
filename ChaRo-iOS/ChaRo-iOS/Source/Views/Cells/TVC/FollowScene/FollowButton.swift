//
//  FollowButton.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/06/25.
//

import UIKit

final class FollowButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderColor = isSelected ? UIColor.mainBlue.cgColor : UIColor.gray30.cgColor
            self.backgroundColor = isSelected ? .mainBlue : .white
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.layer.cornerRadius = 11
        self.layer.borderWidth = 1
        self.setTitleColor(.white, for: .selected)
        self.setTitleColor(.gray30, for: .normal)
        self.setTitle("팔로우" , for: .selected)
        self.setTitle("팔로잉", for: .normal)
        self.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 13)
    }
}
