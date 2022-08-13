//
//  JoinContractView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit
import SafariServices

class JoinContractView: UIView {

    
    //MARK: - UI Variables
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
    
    var showPushDocumentButton = UIButton().then {
        $0.setTitle("보기", for: .normal)
        $0.setTitleColor(.gray30, for: .normal)
        $0.titleLabel?.font = .notoSansRegularFont(ofSize: 14)
        $0.addTarget(self, action: #selector(presentPushSafariVC), for:.touchUpInside)
    }
    
    var showEmailDocumentButton = UIButton().then {
        $0.setTitle("보기", for: .normal)
        $0.setTitleColor(.gray30, for: .normal)
        $0.titleLabel?.font = .notoSansRegularFont(ofSize: 14)
        $0.addTarget(self, action: #selector(presentEmailSafariVC), for:.touchUpInside)
    }
    
    var agreeAllButton = JoinAgreeButton(isBig: true).then {
        $0.addTarget(self, action: #selector(allButtonClicked), for: .touchUpInside)
    }
    
    var agreePushButton = JoinAgreeButton(isBig: false).then {
        $0.addTarget(self, action: #selector(smallButtonClicked), for: .touchUpInside)
    }
    
    var agreeEmailButton = JoinAgreeButton(isBig: false).then {
        $0.addTarget(self, action: #selector(smallButtonClicked), for: .touchUpInside)
    }
    
    //약관 SafariViewer 생성을 위한 클로져
    var pushDocumentPresentClosure: ((SFSafariViewController) -> Void)?
    var emailDocumentPresentClosure: ((SFSafariViewController) -> Void)?
    
    let nextButton = NextButton(isSticky: false, isTheLast: true)
    
    
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
        makeButtonBlue()
    }
    
    @objc private func presentPushSafariVC() {
        guard let url = URL(string: "https://nosy-catmint-6ad.notion.site/a5b0820f25d741cc923bb84bbf8d3fcc") else { return }
        let safariView: SFSafariViewController = SFSafariViewController(url: url)
        self.pushDocumentPresentClosure!(safariView)
    }
    
    @objc private func presentEmailSafariVC() {
        guard let url = URL(string: "https://nosy-catmint-6ad.notion.site/f603f6a3d7c8413795dd42fc56a15b58") else { return }
        let safariView: SFSafariViewController = SFSafariViewController(url: url)
        //self.present(safariView, animated: true, completion: nil)
        self.emailDocumentPresentClosure!(safariView)
    }
    
    private func makeButtonBlue() {
        self.nextButton.backgroundColor = .mainBlue
        nextButton.isEnabled = true
    }
    
    private func makeButtonsGray() {
        nextButton.backgroundColor = .gray30
        nextButton.isEnabled = false
    }
    
    @objc func allButtonClicked() {
        agreePushButton.agreed = agreeAllButton.agreed
        agreeEmailButton.agreed = agreeAllButton.agreed
    }
    
    @objc func smallButtonClicked() {
        if agreePushButton.agreed == agreeEmailButton.agreed {
            self.agreeAllButton.agreed = agreePushButton.agreed
        }
    }
    
    //MARK: - configure 함수
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
                                       showPushDocumentButton,
                                       showEmailDocumentButton])
        
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
        
        showPushDocumentButton.snp.makeConstraints {
            $0.top.equalTo(agreePushLabel.snp.top)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(22)
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
        
        showEmailDocumentButton.snp.makeConstraints {
            $0.top.equalTo(agreeEmailLabel.snp.top)
            $0.trailing.equalTo(showPushDocumentButton.snp.trailing)
            $0.height.equalTo(22)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-73)
            $0.height.equalTo(48)
            $0.leading.trailing.equalTo(contractLabel)
        }
        
        makeButtonBlue()
    
    }


}
