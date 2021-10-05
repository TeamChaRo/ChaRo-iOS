//
//  JoinContractView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit

class JoinContractView: UIView {

    var contractLabel = JoinTitleLabel(type: .boldTitle, title: "약관동의")
    
    let contractBackgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "rectangle243")
    }
    
    var contractInputView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var agreeAllLabel = JoinTitleLabel(type: .normalTitle, title: "전체 동의")
    var agreeLine = UIView().then {
        $0.backgroundColor = .gray20
    }
    var agreePushLabel = JoinTitleLabel(type: .normalTitle, title: "(선택)  마케팅 푸시 수신 동의")
    var agreeEmailLabel = JoinTitleLabel(type: .normalTitle, title: "(선택)  마케팅 이메일 수신 동의")
    
    var agreeAllButton = JoinAgreeButton(isBig: true)
    var agreePushButton = JoinAgreeButton(isBig: false)
    var agreeEmailButton = JoinAgreeButton(isBig: false)
    
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
        
        self.addSubviews([contractLabel, contractInputView, nextButton])
        
        contractLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        contractInputView.snp.makeConstraints {
            $0.top.equalTo(contractLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(contractLabel)
            $0.height.equalTo(196)
        }
        
        contractInputView.addSubviews([contractBackgroundImageView,
                                       agreeAllLabel,
                                       agreeLine,
                                       agreePushLabel,
                                       agreeEmailLabel,
                                       agreeAllButton,
                                       agreePushButton,
                                       agreeEmailButton,
                                       nextButton])
        
        contractBackgroundImageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        agreeAllLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(60)
            $0.height.equalTo(22)
        }
        
        agreeAllButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalToSuperview().offset(12)
        }
        
        agreeLine.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalToSuperview().offset(76)
            $0.height.equalTo(1)
        }
        
        agreePushLabel.snp.makeConstraints {
            $0.top.equalTo(agreeLine.snp.bottom).offset(25)
            $0.leading.equalTo(agreeAllLabel.snp.leading)
            $0.height.equalTo(22)
        }
        
        agreePushButton.snp.makeConstraints {
            $0.height.width.equalTo(36)
            $0.top.equalTo(agreeLine.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(18)
        }
        
        agreeEmailLabel.snp.makeConstraints {
            $0.top.equalTo(agreePushLabel.snp.bottom).offset(20)
            $0.leading.equalTo(agreeAllLabel.snp.leading)
            $0.height.equalTo(22)
        }
        
        agreeEmailButton.snp.makeConstraints {
            $0.height.width.leading.equalTo(agreePushButton)
            $0.top.equalTo(agreeLine.snp.bottom).offset(58)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-73)
            $0.height.equalTo(48)
            $0.leading.trailing.equalTo(contractLabel)
        }
    
    }

}
