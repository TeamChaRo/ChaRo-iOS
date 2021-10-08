//
//  JoinProfileView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit

class JoinProfileView: UIView, UITextFieldDelegate {

    
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
    }
    
    private func makeButtonsGray() {
        nextButton.backgroundColor = .gray30
        stickyNextButton.backgroundColor = .gray30
    }
    
    private func isOnlyHanguel(text: String) -> Bool {
        // String -> Array
        let arr = Array(text)
        // 정규식 pattern. 한글만 있어야함
        let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣ]$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            var index = 0
            while index < arr.count { // string 내 각 문자 하나하나 마다 정규식 체크 후 충족하지 못한것은 제거.
                let results = regex.matches(in: String(arr[index]), options: [], range: NSRange(location: 0, length: 1))
                if results.count == 0 {
                    return false
                } else {
                    index += 1
                }
            }
        }
        return true
        
    }
    
    
    //MARK: - TextField Delegate 함수
    func textFieldDidEndEditing(_ textField: UITextField) {
        //이것도 Rx로 해야할까나 ...
        if textField.text == "" {
            nicknameView.setOrangeTFLabelColorWithText(text: "닉네임을 작성해주세요.")
        } else if textField.text!.count > 5 {
            nicknameView.setOrangeTFLabelColorWithText(text: "5자 이내로 작성해주세요.")
        } else if !isOnlyHanguel(text: textField.text!) {
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
            case .success(_):
                self.nicknameView.setBlueTFLabelColorWithText(text: "사용 가능한 닉네임입니다.")
                self.makeButtonsBlue()
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
