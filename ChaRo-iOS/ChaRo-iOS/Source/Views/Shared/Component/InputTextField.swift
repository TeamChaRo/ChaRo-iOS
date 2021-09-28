//
//  InputTextField.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/09/28.
//

import UIKit

enum InputTextFieldType {
    case normal
    case password
}

class InputTextField: UITextField {
    
    var iconClick = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
       required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(type: InputTextFieldType, placeholder: String) {
        
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.backgroundColor = .gray10
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray20.cgColor
        self.addLeftPadding(14)
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: [
                                                            .foregroundColor: UIColor.lightGray,
                                                            .font: UIFont.notoSansRegularFont(ofSize: 14)
                                                        ])
        
        switch type {
        case .normal:
            self.clearButtonMode = .whileEditing
        case .password:
            self.isSecureTextEntry = true
        }
    }
    
    private func configureShowPasswordButton() {
        
    }
    
    public func setBlueBorderWithText(type: InputTextFieldType, text: String) {
        self.layer.borderColor = UIColor.mainBlue.cgColor
    }
    
    public func setRedBorderWithText(type: InputTextFieldType, text: String) {
        self.layer.borderColor = UIColor.mainOrange.cgColor
    }
    
    
}
