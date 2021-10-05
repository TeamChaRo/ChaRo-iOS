//
//  JoinProfileView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit

class JoinProfileView: UIView {

    var profileLabel = JoinTitleLabel(type: .boldTitle, title: "프로필 사진")
    
    let profileView = ProfileView()
    let nicknameView = JoinInputView(title: "닉네임 작성", placeholder: "5자 이내 한글")
    
    let nextButton = NextButton(isSticky: false)
    let stickyNextButton = NextButton(isSticky: true)
    
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

}
