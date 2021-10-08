//
//  JoinPasswordView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit

class JoinPasswordView: UIView {

    //MARK: - UI Variables
    let passwordInputView = PasswordView(title: "비밀번호", subTitle: "5자 이상 15자 이내의 비밀번호를 입력해주세요.")
    let nextButton = NextButton(isSticky: false, isTheLast: true)
    let stickyNextButton = NextButton(isSticky: true, isTheLast: true)
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
        configureUI()
        configureStickyView()
    }
    
    
    //MARK: - configure 함수
    private func configureUI() {
                
        self.addSubviews([passwordInputView, nextButton])
        
        passwordInputView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(200)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-73)
            $0.height.equalTo(48)
            $0.leading.trailing.equalTo(passwordInputView)
        }
        
        
        passwordInputView.enableNextButtonClosure = {
            self.makeButtonsBlue()
        }
        passwordInputView.unableNextButtonClosure = {
            self.makeButtonsGray()
        }
        
        self.dismissKeyboardWhenTappedAround()
        
    }
    
    private func configureStickyView() {
        
        stickyView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 48))
        stickyView!.addSubview(stickyNextButton)
        
        stickyNextButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        passwordInputView.firstTextField.inputAccessoryView = stickyView
        passwordInputView.secondTextField.inputAccessoryView = stickyView
        
        self.dismissKeyboardWhenTappedAround()
        
    }
    
    private func makeButtonsBlue() {
        nextButton.backgroundColor = .mainBlue
        stickyNextButton.backgroundColor = .mainBlue
    }
    
    private func makeButtonsGray() {
        nextButton.backgroundColor = .gray30
        stickyNextButton.backgroundColor = .gray30
    }

}
