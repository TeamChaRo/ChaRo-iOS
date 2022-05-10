//
//  FindPasswordVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/12/27.
//

import UIKit

class FindPasswordVC: UIViewController, UITextFieldDelegate {

    static let identifier = "FindPasswordVC"
    
    //MARK: - UI Variables
    let emailInputView = JoinInputView(title: "임시 비밀번호 발급",
                                       subTitle: "가입하신 이메일 주소로 임시 비밀번호가 발급됩니다. 로그인 후 꼭 비밀번호를 변경해주세요.",
                                       placeholder: "이메일 아이디를 입력해주세요")
    let nextButton = NextButton(isSticky: false, isTheLast: true)
    let stickyNextButton = NextButton(isSticky: true, isTheLast: true)
    var stickyView: UIView?
    
    var navigationView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var navigationViewTitleLabel = UILabel().then {
        $0.text = "비밀번호 찾기"
        $0.font = .notoSansMediumFont(ofSize: 17)
        $0.textColor = .mainBlack
    }
    
    var backButton = UIButton().then {
        $0.setImage(ImageLiterals.icBack, for: .normal)
        $0.addTarget(self, action: #selector(moveBack), for: .touchUpInside)
    }
    
    var naviBarLine = UIView().then {
        $0.backgroundColor = .gray20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDelegate()
        configureClosure()
        configureUI()
        configureStickyView()
    }
    
    //MARK: - configure 함수
    private func configureDelegate() {
        emailInputView.inputTextField?.delegate = self
    }
    
    private func configureClosure() {
        nextButton.nextPageClosure = {
            print("여기서 통신요청")
        }
        
        stickyNextButton.nextPageClosure = {
            print("여기서 통신요청")
        }
    }
    
    private func configureUI() {
        
        view.addSubview(navigationView)
        setupNavigationViewUI()
        
        view.addSubviews([emailInputView,
                          nextButton])
        
        emailInputView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(23)
            $0.height.equalTo(200)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        emailInputView.subTitleLabel.font = .notoSansRegularFont(ofSize: 14)
        
        emailInputView.inputTextField!.snp.remakeConstraints {
            $0.top.equalTo(emailInputView.subTitleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(emailInputView.titleLabel)
            $0.height.equalTo(48)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-73)
            $0.height.equalTo(48)
            $0.leading.trailing.equalTo(emailInputView)
        }
        
        view.dismissKeyboardWhenTappedAround()
        
    }
    
    
    private func setupNavigationViewUI() {
        
        navigationView.addSubviews([navigationViewTitleLabel,
                                    backButton,
                                    naviBarLine])
        
        
        navigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(102)
        }
        
        navigationViewTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(58)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(45)
            $0.width.height.equalTo(48)
            $0.leading.equalToSuperview()
        }
        
        naviBarLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
    }
    
    private func configureStickyView() {
        
        stickyView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 48))
        stickyView!.addSubview(stickyNextButton)
        
        stickyNextButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        emailInputView.inputTextField!.inputAccessoryView = stickyView
    }
    
    //MARK: - Custom 함수
    @objc func moveBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func makeButtonBlue() {
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

}
