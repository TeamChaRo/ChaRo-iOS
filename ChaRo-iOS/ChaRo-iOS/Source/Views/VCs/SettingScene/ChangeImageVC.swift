//
//  ChangeImageVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2022/04/26.
//

import UIKit

class ChangeImageVC: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    static let identifier = "ChangeImageVC"
    
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
    
    private let nicknameInputView = JoinInputView(title: "",
                                                  subTitle: "닉네임",
                                                  placeholder: "기존 닉네임")
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderLayout()
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
    
    
    //MARK: - Configure UI
    func setHeaderLayout() {
        let headerHeigth = userheight * 0.15
        self.view.addSubview(settingBackgroundView)
        settingBackgroundView.addSubviews([headerTitleLabel,
                                           backButton,
                                           doneButton,
                                           bottomView])
        
        self.view.addSubviews([
                    profileView,
                    profileChangeButton,
                    nicknameInputView
                ])
        
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
        
        nicknameInputView.snp.makeConstraints {
            $0.top.equalTo(profileChangeButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
        }
        
    }
}
