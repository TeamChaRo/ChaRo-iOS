//
//  JoinInputView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/09/28.
//

import UIKit


class JoinInputView: UIView {
    
    var titleLabel = UILabel().then {
        $0.font = .notoSansBoldFont(ofSize: 17)
        $0.textColor = .mainBlack
    }
    
    var subTitleLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 11)
        $0.textColor = .gray40
    }
    
    var inputTextField: InputTextField?
    
    var statusLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 11)
        $0.textColor = .mainOrange
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, subTitle: String, placeholder: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        subTitleLabel.text = subTitle
        inputTextField = InputTextField(type: .normal, placeholder: placeholder)
        
        setConstraints(hasSubtitle: true)
    }
    
    init(title: String, placeholder: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        inputTextField = InputTextField(type: .normal, placeholder: placeholder)
        setConstraints(hasSubtitle: false)
    }
    
    private func setConstraints(hasSubtitle: Bool) {
        
        addSubviews([titleLabel,
                     subTitleLabel,
                     inputTextField!,
                     statusLabel])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
        }
        
        if hasSubtitle {
            
            subTitleLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(2)
                $0.leading.trailing.equalTo(titleLabel)
            }
            
            inputTextField!.snp.makeConstraints {
                $0.top.equalTo(subTitleLabel.snp.bottom).offset(12)
                $0.leading.trailing.equalTo(titleLabel)
                $0.height.equalTo(48)
            }
            
        } else {
            
            inputTextField!.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(12)
                $0.leading.trailing.equalTo(titleLabel)
                $0.height.equalTo(48)
            }
            
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(inputTextField!.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(6)
            $0.height.equalTo(14)
        }
    }
    
    public func setBlueTFLabelColorWithText(text: String) {
        inputTextField?.setBlueBorderWithText()
        statusLabel.textColor = .mainBlue
        statusLabel.text = text
    }
    
    public func setOrangeTFLabelColorWithText(text: String) {
        inputTextField?.setOrangeBorderWithText()
        statusLabel.textColor = .mainOrange
        statusLabel.text = text
    }
    
    
}
