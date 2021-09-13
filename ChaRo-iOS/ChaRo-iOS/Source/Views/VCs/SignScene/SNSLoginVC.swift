//
//  SNSLoginVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/09/13.
//

import UIKit
import SnapKit
import Then

class SNSLoginVC: UIViewController {

    static let identifier = "SNSLoginVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "logo")
    }
    
    let logoLabel = UILabel().then {
        $0.text = "당신의 드라이브 메이트"
        $0.font = UIFont.notoSansBoldFont(ofSize: 14)
        $0.textColor = .mainBlue
    }
    
    let appleLoginBtn = UIButton().then {
        $0.tintColor = .mainBlack
    }
    
    let googleLoginBtn = UIButton().then {
        $0.tintColor = .white
    }
    
    let kakaoLoginBtn = UIButton().then {
        $0.tintColor = .blue
    }
    
    let emailLoginBtn = UIButton().then {
        $0.setTitle("이메일 로그인", for: .normal)
        $0.setTitleColor(.gray30, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
    }
    
    let emailJoinBtn  = UIButton().then {
        $0.setTitle("이메일로 가입", for: .normal)
        $0.setTitleColor(.gray30, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
    }
    
    
    func configureUI() {
        
        view.addSubviews([logoImageView,
                          logoLabel,
                          appleLoginBtn,
                          googleLoginBtn,
                          kakaoLoginBtn,
                          emailLoginBtn,
                          emailJoinBtn])
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(273)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(221)
            $0.height.equalTo(83)
        }
        
        logoLabel.snp.makeConstraints {
            $0.bottom.equalTo(logoImageView.snp.top)
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
        }
        
//        appleLoginBtn.snp.makeConstraints {
//
//        }
//
//        googleLoginBtn.snp.makeConstraints {
//
//        }
//
//        kakaoLoginBtn.snp.makeConstraints {
//
//        }
//
        emailLoginBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-55)
            $0.width.equalTo(81)
            $0.height.equalTo(21)
            $0.trailing.equalTo(view.snp.centerX).offset(-12.5)
        }
        
        emailJoinBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-55)
            $0.width.equalTo(81)
            $0.height.equalTo(21)
            $0.leading.equalTo(view.snp.centerX).offset(12.5)
        }
        
    }
    
    
//    backgroundImageView.snp.makeConstraints{
//        $0.top.leading.trailing.bottom.equalToSuperview()
//    }
//
//    backButton.snp.makeConstraints{
//        $0.top.equalTo(view.safeAreaLayoutGuide).offset(1)
//        $0.leading.equalTo(view.safeAreaLayoutGuide).offset(7)
//        $0.height.width.equalTo(48)
//    }
//
//    titleLabel.snp.makeConstraints{
//        $0.top.equalTo(view.safeAreaLayoutGuide).offset(14)
//        $0.centerX.equalTo(view.snp.centerX)
//    }
//
//    userNameLabel.snp.makeConstraints{
//        $0.top.equalTo(titleLabel.snp.bottom).offset(116)
//        $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
//    }
    
    
    
    

    
}
