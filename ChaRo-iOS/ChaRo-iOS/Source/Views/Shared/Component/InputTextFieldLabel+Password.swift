//
//  InputTextFieldLabel+Password.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit

class InputTextFieldLabel_Password: UIView, UITextFieldDelegate {

    var firstTextField = InputTextField(type: .password, placeholder: "5이상 15자 이내의 영문과 숫자")
    var secondTextField = InputTextField(type: .password, placeholder: "비밀번호를 한번 더 작성해주세요")
    var statusLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.textColor = .mainOrange
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureTextField()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //초기값 받고 바구는 함수 만들기?
    init() {
        super.init(frame: .zero)
    }
    
    private func configureTextField() {
        firstTextField.delegate = self
        secondTextField.delegate = self
    }
    
    private func setConstraints() {
        
        addSubviews([firstTextField,
                     secondTextField,
                     statusLabel])
        
        firstTextField.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.height.equalTo(48)
        }
        
        secondTextField.snp.makeConstraints {
            $0.top.equalTo(self.firstTextField.snp.bottom).offset(10)
            $0.leading.trailing.height.equalTo(firstTextField)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(self.secondTextField.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(firstTextField)
            $0.height.equalTo(14)
        }
        
        
    }

}
