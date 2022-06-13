//
//  JoinProfileView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit

class JoinProfileView: UIView, UITextFieldDelegate {
    
    var isNicknamePassed = false
    
    //MARK: - UI Variables
    var profileLabel = JoinTitleLabel(type: .boldTitle, title: "프로필 사진")
    
    let profileView = ProfileView()
    let nicknameView = JoinInputView(title: "닉네임 작성", placeholder: "5자 이내 한글")
    
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
        nicknameView.inputTextField?.delegate = self
    }
    
    private func configureClosure() {
        self.nextButton.nextViewClosure = {
        }
        self.stickyNextButton.nextViewClosure = {
            //서버연결
        }
    }
    
    private func configureUI() {
        
        self.addSubviews([profileView,
                          profileLabel,
                          nicknameView,
                          nextButton])
        
        profileLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.height.equalTo(122)
            $0.leading.trailing.equalTo(profileLabel)
        }
        
        nicknameView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(profileLabel)
            $0.height.equalTo(150)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-73)
            $0.height.equalTo(48)
            $0.leading.trailing.equalTo(profileLabel)
        }
        
        makeButtonsGray()
        
        self.dismissKeyboardWhenTappedAround()
        
    }
    
    private func configureStickyView() {
        
        stickyView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 48))
        stickyView!.addSubview(stickyNextButton)
        
        stickyNextButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        nicknameView.inputTextField!.inputAccessoryView = stickyView
        
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
    
    private func makeNicknameViewRed(text: String) {
        self.isNicknamePassed = false
        self.makeButtonsGray()
        self.nicknameView.setOrangeTFLabelColorWithText(text: text)
    }
    
    private func makeNicknameViewBlue(text: String) {
        self.isNicknamePassed = true
        self.makeButtonsBlue()
        self.nicknameView.setBlueTFLabelColorWithText(text: text)
    }
    
    //MARK: - TextField Delegate 함수
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let nickname = textField.text!
        if nickname == "" {
            isNicknamePassed = false
            self.makeButtonsGray()
            nicknameView.setOrangeTFLabelColorWithText(text: "닉네임을 작성해주세요.")
        } else if nickname.count > 5 {
            isNicknamePassed = false
            self.makeButtonsGray()
            nicknameView.setOrangeTFLabelColorWithText(text: "5자 이내로 작성해주세요.")
        } else if !nickname.isOnlyHanguel() {
            isNicknamePassed = false
            self.makeButtonsGray()
            nicknameView.setOrangeTFLabelColorWithText(text: "한글만 사용해주세요.")
        }
        else {
            self.IsDuplicatedNickname(nickname: (self.nicknameView.inputTextField?.text!)!)
        }
    }
    
    //MARK: - 서버 연결 함수
    private func IsDuplicatedNickname(nickname: String) {
        IsDuplicatedNicknameService.shared.getNicknameInfo(nickname: nickname) { (response) in
            
            switch(response)
            {
            case .success(let success):
                if let success = success as? Bool {
                    if success {
                        self.makeNicknameViewBlue(text: "사용 가능한 닉네임입니다. ")
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
                self.makeNicknameViewRed(text: "중복되는 닉네임이 존재합니다.")
            }
        }
    }
    
    
    
}
