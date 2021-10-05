//
//  JoinEmailView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit

class JoinEmailView: UIView, UITextFieldDelegate {

    
    var verifyNumber: String?
    
    //MARK: - UI Variables
    let emailInputView = JoinInputView(title: "이메일 아이디",
                                       subTitle: "사용할 이메일을 입력해주세요.",
                                       placeholder: "ex)charorong@gmail.com")
    
    let emailVerifyInputView = JoinInputView(title: "이메일 인증번호",
                                        subTitle: "이메일로 보내드린 인증번호를 입력해주세요.",
                                        placeholder: "ex)울랄라")
    
    let nextButton = NextButton(isSticky: false, isTheLast: false)
    let stickyNextButton = NextButton(isSticky: true, isTheLast: false)
    
    var stickyView: UIView?
    

    
    //MARK: - Life Cycle
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
        configureStickyView()
        configureClosure()
    }
    
    
    //MARK: - configure 함수
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
        
    }
    
    private func configureClosure() {
        self.nextButton.nextViewClosure = {
            self.emailVerifyInputView.isHidden = false
        }
        self.stickyNextButton.nextViewClosure = {
            self.emailVerifyInputView.isHidden = false
        }
    }
    
    private func configureStickyView() {
        
        stickyView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 48))
        stickyView!.addSubview(stickyNextButton)
        
        stickyNextButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        emailInputView.inputTextField!.inputAccessoryView = stickyView
        emailVerifyInputView.inputTextField!.inputAccessoryView = stickyView
        
        
    }

    
    //MARK: - textFieldDelegate 함수
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let text = textField.text
        
        switch textField {
        
        case emailInputView.inputTextField:
            print("ㅇㅇ")
            
        case emailVerifyInputView.inputTextField:
            if verifyNumber == text {
                emailVerifyInputView.setBlueTFLabelColorWithText(text: "인증되었습니다.")
            }
        default:
            print(text)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let text = textField.text
        
        switch textField {
        
        case emailInputView.inputTextField:
            if textField.text == "" {
                emailInputView.setOrangeTFLabelColorWithText(text: "이메일을 입력해주세요.")
            } else {
                //이거 물어봐야됨 형식이 어캐되는지??? 이거 잘 오면 view 가린거 없애고 다음버튼도 회색만들기
                IsDuplicatedEmail(email: textField.text!)
            }
            
        case emailVerifyInputView.inputTextField:
            if textField.text == "" {
                emailVerifyInputView.setOrangeTFLabelColorWithText(text: "인증번호를 입력해주세요.")
            } else {
                ValidateEmail(email: textField.text!)
            }
            
        default:
            print(text)
        }
        
    }
    
    
    //MARK: - 서버 요청 함수
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
    

    private func ValidateEmail(email: String) {
        ValidateEmailService.shared.postValidationNumber(email: email) { (response) in
            
            switch(response)
            {
            case .success(let data):
                if let data = data as? ValidationEmailModel {
                    self.verifyNumber = data.data
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

