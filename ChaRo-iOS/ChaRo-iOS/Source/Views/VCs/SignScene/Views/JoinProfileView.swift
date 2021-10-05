//
//  JoinProfileView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit

class JoinProfileView: UIView, UITextFieldDelegate {

    var profileLabel = JoinTitleLabel(type: .boldTitle, title: "프로필 사진")
    
    let profileView = ProfileView()
    let nicknameView = JoinInputView(title: "닉네임 작성", placeholder: "5자 이내 한글")
    
    let nextButton = NextButton(isSticky: false, isTheLast: false)
    let stickyNextButton = NextButton(isSticky: true, isTheLast: false)
    var stickyView: UIView?
    
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
        configureClosure()
    }
    
    private func configureClosure() {
        self.nextButton.nextViewClosure = {
            self.IsDuplicatedNickname(nickname: (self.nicknameView.inputTextField?.text!)!)
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
    
    
    //MARK: - 서버 연결 함수
    private func IsDuplicatedNickname(nickname: String) {
        IsDuplicatedNicknameService.shared.getNicknameInfo(nickname: nickname) { (response) in
            
            switch(response)
            {
            case .success(let success):
                print(success)
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
