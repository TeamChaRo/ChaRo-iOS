//
//  JoinEmailView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit

class JoinEmailView: UIView, UITextFieldDelegate {

    let emailInputView = JoinInputView(title: "이메일 아이디",
                                       subTitle: "사용할 이메일을 입력해주세요.",
                                       placeholder: "ex)charorong@gmail.com")
    
    let emailVerifyInputView = JoinInputView(title: "이메일 인증번호",
                                        subTitle: "이메일로 보내드린 인증번호를 입력해주세요.",
                                        placeholder: "ex)울랄라")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    private func configureUI() {
                
        self.addSubviews([emailInputView,
                          emailVerifyInputView])
        
        emailInputView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(117)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        emailVerifyInputView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.height.equalTo(117)
            $0.leading.trailing.equalTo(emailInputView)
        }
        
        self.dismissKeyboardWhenTappedAround()
        
        
    }

}
