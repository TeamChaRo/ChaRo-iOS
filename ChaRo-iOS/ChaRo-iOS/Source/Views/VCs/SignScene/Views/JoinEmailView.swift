//
//  JoinEmailView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit

class JoinEmailView: UIView, UITextFieldDelegate {

    
    var verifyNumber: String?
    var passedEmail: String = ""
    var DuplicateCheck: Bool = false
    var ValidateCheck: Bool = false
    
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
        makeButtonsGray()
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
        
        self.dismissKeyboardWhenTappedAround()
    }
    
    private func configureClosure() {
        //다음 버튼을 눌렀을 때 JoinEMailView 내 에서의 클로져 정의.
        //다음 뒤에 나올 뷰가 있으면 이 nextViewClosure 가 실행되고 다음 페이지로 넘어가야 하면 JoinVC에 있는 nextPageClosure 가 실행됨
        self.nextButton.nextViewClosure = {
            if self.DuplicateCheck {
                self.emailVerifyInputView.isHidden = false
                self.ValidateEmail(email: (self.emailInputView.inputTextField?.text!)!)
                self.makeButtonsGray()
            }
        }
        self.stickyNextButton.nextViewClosure = {
            if self.DuplicateCheck {
                self.emailVerifyInputView.isHidden = false
                self.ValidateEmail(email: (self.emailInputView.inputTextField?.text!)!)
                self.makeButtonsGray()
                NotificationCenter.default.post(name: UIResponder.keyboardWillShowNotification, object: nil, userInfo: nil)
            }
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
    
    private func makeButtonsBlue() {
        nextButton.backgroundColor = .mainBlue
        stickyNextButton.backgroundColor = .mainBlue
        nextButton.isEnabled = true
        stickyNextButton.isEnabled = true
    }
    
    private func makeButtonsGray() {
        nextButton.backgroundColor = .gray30
        stickyNextButton.backgroundColor = .gray30
        nextButton.isEnabled = false
        stickyNextButton.isEnabled = false
    }

    
    //MARK: - textFieldDelegate 함수
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let text = textField.text
        if !(passedEmail == emailInputView.inputTextField?.text) {
            self.emailVerifyInputView.isHidden = true
            self.emailVerifyInputView.inputTextField?.text = ""
            self.emailVerifyInputView.setOrangeTFLabelColorWithText(text: "인증번호를 입력해주세요.")
            self.nextButton.isTheLast = false
            self.stickyNextButton.isTheLast = false
        }
        
        switch textField {
        
        case emailInputView.inputTextField:
            self.DuplicateCheck = false
            if textField.text == "" {
                emailInputView.setOrangeTFLabelColorWithText(text: "이메일을 입력해주세요.")
                makeButtonsGray()
                self.emailVerifyInputView.isHidden = true
            } else {
                IsDuplicatedEmail(email: textField.text!)
            }
            break
        
        case emailVerifyInputView.inputTextField:
            if textField.text == "" {
                emailVerifyInputView.setOrangeTFLabelColorWithText(text: "인증번호를 입력해주세요.")
                makeButtonsGray()
            }
            else if verifyNumber == text {
                ValidateCheck = true
                emailVerifyInputView.setBlueTFLabelColorWithText(text: "인증되었습니다.")
                makeButtonsBlue()
                if passedEmail == emailInputView.inputTextField?.text {
                    nextButton.isTheLast = true
                    stickyNextButton.isTheLast = true
                }
            } else {
                ValidateCheck = false
                emailVerifyInputView.setOrangeTFLabelColorWithText(text: "입력하신 인증번호가 맞지 않습니다. 다시 한 번 확인해주세요.")
                makeButtonsGray()
            }
            break
        default:
            print(text)
        }
    }
    
    //MARK: - 서버 요청 함수
    private func IsDuplicatedEmail(email: String) {
            
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regex)
        if !emailTest.evaluate(with: email) {
            self.emailInputView.setOrangeTFLabelColorWithText(text: "이메일 형식이 올바르지 않습니다.")
            self.makeButtonsGray()
            self.emailVerifyInputView.isHidden = true
            return
        }
        
        IsDuplicatedEmailService.shared.getEmailInfo(email: email) { (response) in
            
            switch(response)
            {
            case .success(let success):
                
                if let success = success as? Bool {
                    if success {
                        self.DuplicateCheck = true
                        self.emailInputView.setBlueTFLabelColorWithText(text: "사용가능한 이메일 형식입니다.")
                        self.makeButtonsBlue()
                        self.passedEmail = email
                    } else {
                        self.DuplicateCheck = false
                        self.emailInputView.setOrangeTFLabelColorWithText(text: "중복되는 이메일이 존재합니다.")
                        self.makeButtonsGray()
                        self.emailVerifyInputView.isHidden = true
                    }
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
                    print("이메일 인증 번호 : \(data.data)")
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

