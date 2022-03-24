//
//  ChangePasswordVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2022/03/01.
//

import UIKit

class ChangePasswordVC: UIViewController {

    //MARK: - Properties
    static let identifier = "ChangePasswordVC"
    
    let userWidth = UIScreen.main.bounds.width
    let userheight = UIScreen.main.bounds.height
    
    //headerView
    private let settingBackgroundView = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    
    private let headerTitleLabel = UILabel().then {
        $0.text = "비밀번호 수정"
        $0.font = UIFont.notoSansRegularFont(ofSize: 17)
        $0.textColor = UIColor.black
        $0.textAlignment = .center
    }
    
    private let backButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "backIcon"), for: .normal)
        $0.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
    }
    
    private let doneButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 17)
        $0.setTitleColor(.gray40, for: .normal)
        $0.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
    }
    
    private let bottomView = UIView().then {
        $0.backgroundColor = UIColor.gray20
    }
    
    //passwordView
    let oldPasswordInputView = JoinInputView(title: "",
                                             subTitle: "기존 비밀번호",
                                             placeholder: "5이상 15자 이내의 영문과 숫자").then {
        $0.subTitleLabel.textColor = .gray50
    }
    
    let newPasswordInputView = PasswordView(title: "새 비밀번호",
                                            subTitle: "5자 이상 15자 이내의 비밀번호를 입력해주세요.").then {
        $0.titleLabel.font = .notoSansRegularFont(ofSize: 12)
    }
        
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderLayout()
        configureUI()
        configureDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.newPasswordInputView.isHidden = true
    }
        
    private func configureDelegate() {
        self.oldPasswordInputView.inputTextField?.delegate = self
        
        self.newPasswordInputView.enableNextButtonClosure = {
            self.doneButton.isEnabled = true
            self.doneButton.setTitleColor(.mainBlue, for: .normal)
        }
        
        self.newPasswordInputView.unableNextButtonClosure = {
            self.doneButton.isEnabled = false
            self.doneButton.setTitleColor(.gray40, for: .normal)
        }
    }
    
    @objc private func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneButtonClicked() {
        let newPassword = newPasswordInputView.secondTextField.text!
        UpdatePasswordService.shared.putNewPassword(password: newPassword) { result in
            
            switch result {
            case .success(let msg):
                print("success", msg)
                self.makeAlert(title: "", message: "비밀번호가 변경되었습니다.", okAction: { _ in 
                    self.navigationController?.popViewController(animated: true)
                })
            case .requestErr(let msg):
                print("requestERR", msg)
            case .pathErr:
                print("pathERR")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                print("networkFail")
            }
            
        }
    }
    
    
    //MARK: - Configure UI
    private func configureUI() {
        self.view.addSubviews([oldPasswordInputView,
                              newPasswordInputView])
        
        oldPasswordInputView.snp.makeConstraints {
            $0.top.equalTo(settingBackgroundView.snp.bottom).offset(26)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
        }
        
        newPasswordInputView.snp.makeConstraints {
            $0.top.equalTo(oldPasswordInputView.snp.bottom).offset(63)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(300)
        }
    }
    
    
    private func configureHeaderLayout() {
        let headerHeight = userheight * 0.15
        
        self.view.addSubview(settingBackgroundView)
        
        settingBackgroundView.addSubviews([headerTitleLabel,
                                           backButton,
                                           doneButton,
                                           bottomView])
        
        settingBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(headerHeight)
        }
        
        headerTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(settingBackgroundView)
            $0.bottom.equalToSuperview().offset(-25)
            $0.width.equalTo(170)
        }
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(headerTitleLabel)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        doneButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(headerTitleLabel)
        }
    }
}



//MARK: - Extension
extension ChangePasswordVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let text = textField.text
        
        switch textField {
        case oldPasswordInputView.inputTextField :
        
            //TODO: - UserDefault 에 저장된 유저의 비밀번호로 변경예정
            if text == "12345" {
                oldPasswordInputView.setBlueTFLabelColorWithText(text: "확인되었습니다.")
                newPasswordInputView.isHidden = false
            } else {
                oldPasswordInputView.setOrangeTFLabelColorWithText(text: "비밀번호가 일치하지 않습니다.")
                newPasswordInputView.isHidden = true
            }
        default :
            break
        }
        
    }
    
    
}
