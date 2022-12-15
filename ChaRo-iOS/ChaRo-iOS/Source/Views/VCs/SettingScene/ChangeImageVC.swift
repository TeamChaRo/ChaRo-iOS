//
//  ChangeImageVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2022/04/26.
//

import UIKit
import Photos
import PhotosUI

class ChangeImageVC: UIViewController {
    
    //MARK: - Properties
    static let identifier = "ChangeImageVC"
    var isNicknamePassed = false
    var newImageString = ""
    
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
    
    private let profileView = ProfileView().then {
        guard let urlString = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.userImage) else { return }
        $0.profileImageView.kf.setImage(with: URL(string: urlString))
    }
    
    private let nicknameView = JoinInputView(title: "",
                                             subTitle: "닉네임",
                                             placeholder: "\(UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.userNickname) as? String ?? "")").then {
        $0.inputTextField?.text = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.userNickname) as? String
    }
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeaderLayout()
        configureUI()
        configureDelegate()
        configureClosure()
    }
    
    //MARK: - Custom Function
    private func configureDelegate() {
        nicknameView.inputTextField?.delegate = self
    }
    
    private func configureClosure() {
        profileView.actionSheetPresentClosure = { actionSheet in
            self.present(actionSheet, animated: true)
        }
        profileView.imagePickerPresentClosure = { picker in
            picker.delegate = self
            self.present(picker, animated: true)
        }
        profileView.doneButtonClosure = {
            self.makeDoneEnable()
        }
        profileView.authSettingOpenClosure = { authString in
            let message = "\(authString) 사용에 대한 액세스 권한을 허용해주세요. 더 쉽고 편하게 사진을 올릴 수 있어요."
            let alert = UIAlertController(title: "설정", message: message, preferredStyle: .alert)
            let cancle = UIAlertAction(title: "취소", style: .default)
            let confirm = UIAlertAction(title: "확인", style: .default) { (UIAlertAction) in
              UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
          
            alert.addAction(cancle)
            alert.addAction(confirm)
          
            self.present(alert, animated: true)
        }
    }
    
    private func makeDoneEnable() {
        self.doneButton.isEnabled = true
        self.doneButton.setTitleColor(.mainBlue, for: .normal)
    }
    
    private func makeDoneUnable() {
        self.doneButton.isEnabled = false
        self.doneButton.setTitleColor(.gray40, for: .normal)
    }
    
    @objc private func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func makeNicknameViewRed(text: String) {
        self.isNicknamePassed = false
        nicknameView.setOrangeTFLabelColorWithText(text: text)
        makeDoneUnable()
    }
    
    private func makeNicknameViewBlue(text: String) {
        self.isNicknamePassed = true
        nicknameView.setBlueTFLabelColorWithText(text: text)
        makeDoneEnable()
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
        guard let newNickname = nicknameView.inputTextField?.text else { return }
        let newImage = profileView.profileImageView.image
        UpdateProfileService.shared.putNewProfile(nickname: newNickname,
                                                  newImage: newImage) { result in
            switch result {
            case .success(let msg):
                print("success", msg)
                self.makeAlert(title: "", message: "프로필이 변경되었습니다.", okAction: { _ in
                    UserDefaults.standard.set(newNickname, forKey: Constants.UserDefaultsKey.userNickname)
                    let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
                    guard let nextVC = storyboard.instantiateViewController(withIdentifier: MyPageVC.className) as? MyPageVC else { return }
                    self.navigationController?.pushViewController(nextVC, animated: true)
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
            nicknameView
        ])
        
        profileView.snp.makeConstraints {
            $0.top.equalTo(settingBackgroundView.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(95)
        }
    
        nicknameView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(20)
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


extension ChangeImageVC : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //이미지 선택 Cancel
        picker.dismiss(animated: true) { () in
            self.makeAlert(title: "", message: "이미지 선택이 취소되었습니다.")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        //이미지 Choose
        picker.dismiss(animated: false) { () in
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.profileView.profileImageView.image = image
        }
        makeDoneEnable()
    }
}
