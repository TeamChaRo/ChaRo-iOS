//
//  SNSLoginVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/09/13.
//

import UIKit
import SnapKit
import Then
import AuthenticationServices
import GoogleSignIn
import KakaoSDKUser

class SNSLoginVC: UIViewController {
    
    let signInConfig = GIDConfiguration.init(clientID: "com.googleusercontent.apps.278013610969-pmisnn93vofvfhk25q9a86eeu84ns1ll")
    static let identifier = "SNSLoginVC"
    var snsType: String = "DEFAULT"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    let lookAroundBtn = UIButton().then {
        $0.setTitle("둘러보기", for: .normal)
        $0.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.contentHorizontalAlignment = .right
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
        $0.backgroundColor = .black
        $0.setTitle("Apple로 로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        $0.setImage(UIImage(named: "appleLogo"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 210)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(testLogin), for: .touchUpInside)
    }
    
    let googleLoginBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("Google 로그인", for: .normal)
        $0.setTitleColor(.mainBlack, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        $0.setImage(UIImage(named: "googleLogo"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 210)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
        $0.layer.borderColor = UIColor.gray30.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
    }
    
    let kakaoLoginBtn = UIButton().then {
        $0.setImage(UIImage(named: "kakaoLogo"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 210)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
        $0.backgroundColor = UIColor(red: 254.0 / 255.0, green: 229.0 / 255.0, blue: 0.0, alpha: 1.0)
        $0.setTitle("카카오 로그인", for: .normal)
        $0.setTitleColor(.mainBlack, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(kakaoLogin), for: .touchUpInside)
    }
    
    @objc func testLogin() {
        snsType = "A"
        socialLogin(email: "yyyyaaaaong222@naver.com")
    }
    
    @objc func appleLogin() {
        snsType = "A"
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
    
    @objc func googleLogin() {
        snsType = "G"
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            print("로긘 성공")
            let userEmail = user?.profile?.email
            print("사용자 이메일은 \(userEmail)")
        }
    }
    
    @objc func kakaoLogin() {
        snsType = "K"
        
        print("카카오톡 로그인 시도합니다")
        if (UserApi.isKakaoTalkLoginAvailable()) {
            print("카카오톡 로그인 실행가능")
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    _ = oauthToken
                    let accessToken = oauthToken?.accessToken
                }
            }
        }

    }
    
    @objc func socialLogin(email: String) {
        SocialLoginService.shared.socialLogin(email: email) { (response) in
            
            switch(response)
            {
            case .success(let success):
                if let success = success as? Bool {
                    if success {
                        print("로그인 성공")
                        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
                        let nextVC = storyboard.instantiateViewController(withIdentifier: TabbarVC.identifier)
                        nextVC.modalPresentationStyle = .fullScreen
                        self.present(nextVC, animated: true, completion: nil)
                    } else {
                        print("회원가입 갈겨")
                        self.snsJoin()
                        
                    }
                    
                }
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
    
    func snsJoin() {
        
        let storyboard = UIStoryboard(name: "Join", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: SNSJoinVC.identifier) as? SNSJoinVC
        //nextVC?.modalPresentationStyle = .fullScreen
        //self.present(nextVC!, animated: true, completion: nil)
        self.navigationController?.pushViewController(nextVC!, animated: true)
            
        nextVC?.contractView.nextButton.nextPageClosure = {
            switch self.snsType {
            case "A":
                print(self.snsType)
                print("여기서 애플 회원가입 api 날리기")
                break
                
            case "G":
                
                break
                
            case "K":
                
                break
                
            default:
                print(self.snsType)
                break
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    let emailLoginBtn = UIButton().then {
        $0.setTitle("이메일 로그인", for: .normal)
        $0.setTitleColor(.gray30, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        $0.addTarget(self, action: #selector(goToEmailLoginVC), for: .touchUpInside)
    }
    
    let emailJoinBtn  = UIButton().then {
        $0.setTitle("이메일로 가입", for: .normal)
        $0.setTitleColor(.gray30, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        $0.addTarget(self, action: #selector(goToEmailJoinVC), for: .touchUpInside)
    }
    
    
    @objc func goToEmailLoginVC() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: LoginVC.identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func goToEmailJoinVC() {
        let storyboard = UIStoryboard(name: "Join", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: JoinVC.identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureNavigationController() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    private func configureUI() {
        
        view.addSubviews([lookAroundBtn,
                          logoImageView,
                          logoLabel,
                          appleLoginBtn,
                          googleLoginBtn,
                          kakaoLoginBtn,
                          emailLoginBtn,
                          emailJoinBtn])
        
        lookAroundBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(55)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(21)
            $0.width.equalTo(170)
        }
        
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
        
        appleLoginBtn.snp.makeConstraints {
            $0.bottom.equalTo(googleLoginBtn.snp.top).offset(-14)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(48)
        }
        
        googleLoginBtn.snp.makeConstraints {
            $0.bottom.equalTo(kakaoLoginBtn.snp.top).offset(-14)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(48)
        }
        
        kakaoLoginBtn.snp.makeConstraints {
            $0.bottom.equalTo(emailLoginBtn.snp.top).offset(-39)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(48)
        }
        
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
    
    
}

extension SNSLoginVC : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print(credential.user)
            let user = credential.user
            print("👨‍🍳 \(user)")
            if let email = credential.email {
                socialLogin(email: email)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error \(error)")
    }
}
