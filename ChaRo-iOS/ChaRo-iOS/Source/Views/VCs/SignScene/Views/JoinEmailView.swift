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
    
    let nextButton = NextButton(isSticky: false)
    let stickyNextButton = NextButton(isSticky: true)
    
    var verifyNumber: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init() {
        super.init(frame: .zero)
        configureDelegate()
        configureUI()
    }
    
    private func configureDelegate() {
        emailInputView.inputTextField?.delegate = self
        emailVerifyInputView.inputTextField?.delegate = self
    }
    
    private func configureUI() {
                
        self.addSubviews([emailInputView,
                          emailVerifyInputView,
                          nextButton])
        
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
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-73)
            $0.height.equalTo(48)
            $0.leading.trailing.equalTo(emailInputView)
        }
        
        //초기에 아래 뷰 가리기
        emailVerifyInputView.isHidden = true
        
        self.dismissKeyboardWhenTappedAround()
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == emailInputView.inputTextField {
            
            if textField.text == "" {
                emailInputView.setOrangeTFLabelColorWithText(text: "이메일을 입력해주세요.")
            } else {
                //이거 물어봐야됨 형식이 어캐되는지???
                IsDuplicatedEmail(email: textField.text!)
            }
            
        }
    }
    
    private func IsDuplicatedEmail(email: String) {
        
        IsDuplicatedEmailService.shared.getEmailInfo(email: email) { (response) in
            
            switch(response)
            {
            case .success(let success):
                if let success = success as? Bool {
                    print(success)
                }
            case .requestErr(let message) :
                print("requestERR", message)
            case .pathErr :
                print("pathERR")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                print("networkFail")
            }
        }
        
    }

}

