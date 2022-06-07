//
//  ChangeImageVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2022/04/26.
//

import UIKit

class ChangeImageVC: UIViewController {
    
    //MARK: - Properties
    static let identifier = "ChangeImageVC"
    var isNicknamePassed = false
    
    let userWidth = UIScreen.main.bounds.width
    let userheight = UIScreen.main.bounds.height
    
    //headerView
    private let settingBackgroundView = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    
    private let headerTitleLabel = UILabel().then {
        $0.text = "프로필 수정"
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
    
    private let profileView = UIImageView().then {
        $0.image = UIImage(named: "icProfile")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 95 / 2
    }
    
    private let profileChangeButton = UIButton().then {
        $0.setTitle("프로필 사진 바꾸기", for: .normal)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 14)
        $0.addTarget(self, action: #selector(profileChangeButtonClicked), for: .touchUpInside)
    }
    
    private let nicknameView = JoinInputView(title: "",
                                             subTitle: "닉네임",
                                             placeholder: "기존 닉네임").then {
        $0.inputTextField?.text = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.userNickname) as? String
    }
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderLayout()
        configureUI()
        configureDelegate()
    }
    
    //MARK: - Custom Function
    private func configureDelegate() {
        nicknameView.inputTextField?.delegate = self
    }
    
    @objc private func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func profileChangeButtonClicked() {
        
        let actionsheetController = UIAlertController(title: "프로필 사진 바꾸기", message: nil, preferredStyle: .actionSheet)
        let actionDefaultImage = UIAlertAction(title: "기본 이미지 설정", style: .default, handler: { action in
            print("디폴트 action called")
        })
        let actionLibraryImage = UIAlertAction(title: "라이브러리에서 선택", style: .default, handler: { action in
            print("디폴트 action called")
        })
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: { action in
            print("캔슬 action called")
        })
        
        actionsheetController.addAction(actionDefaultImage)
        actionsheetController.addAction(actionLibraryImage)
        actionsheetController.addAction(actionCancel)
        
        self.present(actionsheetController, animated: true)
    }
    
    private func makeNicknameViewRed(text: String) {
        self.isNicknamePassed = false
        nicknameView.setOrangeTFLabelColorWithText(text: text)
        self.doneButton.isEnabled = false
        self.doneButton.setTitleColor(.gray40, for: .normal)
    }
    
    private func makeNicknameViewBlue(text: String) {
        self.isNicknamePassed = true
        nicknameView.setBlueTFLabelColorWithText(text: text)
        self.doneButton.isEnabled = true
        self.doneButton.setTitleColor(.mainBlue, for: .normal)
    }
    
    //MARK: - Service Function
    private func IsDuplicatedNickname(nickname: String) {
        IsDuplicatedNicknameService.shared.getNicknameInfo(nickname: nickname) { (response) in
            
            switch(response)
            {
            case .success(let success):
                if let success = success as? Bool {
                    if success {
                        self.makeNicknameViewBlue(text: "사용 가능한 닉네임입니다. ")
                    } else {
                        self.makeNicknameViewRed(text: "중복되는 닉네임이 존재합니다.")
                    }
                }
            case .requestErr(let message) :
                print("requestERR", message)
            case .pathErr :
                print("pathERR")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                print("networkFail") }
        }
    }
    
    @objc private func doneButtonClicked() {
        let newNickname = nicknameView.inputTextField?.text
        UpdateProfileService.shared.putNewProfile(nickname: newNickname!,
                                                  newImage: nil) { result in
            
            switch result {
            case .success(let msg):
                print("success", msg)
                self.makeAlert(title: "", message: "프로필이 변경되었습니다.", okAction: { _ in
                    self.navigationController?.popViewController(animated: true)
                    UserDefaults.standard.set(newNickname, forKey: Constants.UserDefaultsKey.userNickname)
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
        self.view.addSubviews([
            profileView,
            profileChangeButton,
            nicknameView
        ])
        
        profileView.snp.makeConstraints {
            $0.top.equalTo(settingBackgroundView.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(95)
        }
        
        profileChangeButton.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19)
            $0.width.equalTo(200)
        }
        
        nicknameView.snp.makeConstraints {
            $0.top.equalTo(profileChangeButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
        }
    }
    
    private func configureHeaderLayout() {
        let headerHeigth = userheight * 0.15
        self.view.addSubview(settingBackgroundView)
        
        settingBackgroundView.addSubviews([headerTitleLabel,
                                           backButton,
                                           doneButton,
                                           bottomView])
        
        settingBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(headerHeigth)
        }
        
        headerTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(settingBackgroundView.snp.centerX)
            $0.bottom.equalToSuperview().offset(-25)
            $0.width.equalTo(170)
        }
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.leading.equalToSuperview().offset(0)
            $0.centerY.equalTo(headerTitleLabel)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().offset(0)
            $0.height.equalTo(1)
        }
        
        doneButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(headerTitleLabel)
        }
    }
    
}

extension ChangeImageVC: UITextFieldDelegate {
    //MARK: - TextField Delegate 함수
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let nickname: String = textField.text ?? ""
        if nickname == "" {
            makeNicknameViewRed(text: "닉네임을 작성해주세요.")
        } else if nickname.count > 5 {
            makeNicknameViewRed(text: "5자 이내로 작성해주세요.")
        } else if !nickname.isOnlyHanguel() {
            makeNicknameViewRed(text: "한글만 사용해주세요.")
        } else {
            self.IsDuplicatedNickname(nickname: nickname)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let nickname = textField.text ?? ""
        if nickname == "" {
            makeNicknameViewRed(text: "닉네임을 작성해주세요.")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let nickname = textField.text ?? ""
        if nickname == "" {
            makeNicknameViewRed(text: "닉네임을 작성해주세요.")
        }
    }
}
