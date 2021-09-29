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
    
    var iconClick = true
    
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
            configureShowPasswordButton()
        }
    }
    
    private func configureShowPasswordButton() {
        
        let iconImageView = UIImageView()
        let eyeOnImage = UIImage(named: "icEyeOn")
        let eyeOffImage = UIImage(named: "icEyeOff")
        
        //눈 이미지 TextField 위에 생성
        iconImageView.image = eyeOffImage
        
        let contentView = UIView()
        contentView.addSubview(iconImageView)
        
        contentView.frame = CGRect(x: 0, y: 0,
                                   width: eyeOnImage!.size.width,
                                   height: eyeOnImage!.size.height)
        
        iconImageView.frame = CGRect(x: -10, y: 0,
                                     width: eyeOnImage!.size.width,
                                     height: eyeOnImage!.size.height)
        
        self.rightView = contentView
        self.rightViewMode = .always
        
        
        //tapGestureRecognizer 생성
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        iconImageView.isUserInteractionEnabled = true
        iconImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        //iconClick 변수의 값에 따라 비밀번호 보이기 안보이기
        if iconClick {
            iconClick = false
            tappedImage.image = UIImage(named: "icEyeOn")
            self.isSecureTextEntry = false
        }
        else {
            iconClick = true
            tappedImage.image = UIImage(named: "icEyeOff")
            self.isSecureTextEntry = true
        }
    }
    
    //사용자에게 텍스트와 함께 테두리 색상을 변경. 텍스트의 위치 조정을 위해 type 과 isFirst 인자를 받음, type이 normal일 때는 isFirst에 nil
    public func setBlueBorderWithText(text: String, type: InputTextFieldType, isFirst: Bool?) {
        self.layer.borderColor = UIColor.mainBlue.cgColor
    }
    
    public func setRedBorderWithText(text: String, type: InputTextFieldType, isFirst: Bool?) {
        self.layer.borderColor = UIColor.mainOrange.cgColor
    }
    
    
}
