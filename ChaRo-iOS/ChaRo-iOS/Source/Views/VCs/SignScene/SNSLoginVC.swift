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
    
    let userInfo = UserInfo.shared
    let signInConfig = GIDConfiguration.init(clientID: "316255098127-usdg37h4sgpondqjh818cl3n002vaach.apps.googleusercontent.com")
    
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
        $0.addTarget(self, action: #selector(lookAroundButtonClicked), for: .touchUpInside)
    }
    
    let logoImageView = UIImageView().then {
        $0.image = ImageLiterals.icCharoLogo
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
        $0.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
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
        $0.addTarget(self, action: #selector(testLogin), for: .touchUpInside)
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
    
    @objc func lookAroundButtonClicked() {
        //isLogin 값을 false로 설정 - 둘러보기이므로 계정 없음
        UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.isLogin)
        self.goToHomeVC()
    }
    
    @objc func testLogin() {
        snsType = "G"
        socialLogin(email: "ghjf39853@naver.com", profileImage: nil, nickname: nil)
        //snsJoin(email: "ghjf3322233@naver.com", profileImage: nil, nickname: nil)
    }
    
    @objc func appleLogin() {
        snsType = "A"
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController =
            ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    @objc func googleLogin() {
        snsType = "G"
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            let userEmail = user?.profile?.email
            //여기 유저 이미지 ... String 으로 변환 모루겟다
//            do {
//                var userProfileImageString = try String(contentsOf: URL(string: (user?.profile?.imageURL(withDimension: 320)!)!)!)
//            }
//            catch let error {
//                print("URL 인코딩 에러")
//            }

            //로그인
            self.socialLogin(email: userEmail!, profileImage: nil, nickname: nil)
        }
    }
    
    @objc func kakaoLogin() {
        snsType = "K"
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { (_, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("카카오 로긘 성공")
                    
                    
                    UserApi.shared.me() { (user, error) in
                                if let error = error {
                                    print(error)
                                }
                                else {
                                    print("me() 성공")
                                    
                                    // 닉네임, 이메일 정보
                                    let email = user?.kakaoAccount?.email
                                    let nickname = user?.kakaoAccount?.profile?.nickname
                                    let profile = user?.kakaoAccount?.profile?.profileImageUrl
                                    //여기서도 URL 을 String 으로 바꾸는 법을 모르겠군요 ...
                                    
                                    UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.isAppleLogin)
                                    UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.isGoogleLogin)
                                    UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.isKakaoLogin)
                                    
                                    //로그인
                                    self.socialLogin(email: email!, profileImage: nil, nickname: nickname)
                                }
                            }
                }
            }
        }

    }
    
    @objc func socialLogin(email: String, profileImage: String?, nickname: String?) {
        SocialLoginService.shared.socialLogin(email: email) { (response) in
            
            switch(response)
            {
            case .success(let success):
                if let success = success as? Bool {
                    if success {
                        print("로그인 성공")
                        //여기서 UserDefault 에 저장
                        UserDefaults.standard.set(email, forKey: Constants.UserDefaultsKey.userEmail)
                        UserDefaults.standard.set(profileImage ?? "", forKey: Constants.UserDefaultsKey.userImage)
                        UserDefaults.standard.set(nickname ?? "", forKey: Constants.UserDefaultsKey.userNickname)
                        self.goToHomeVC()
                    } else {
                        print("회원가입 갈겨")
                        self.snsJoin(email: email, profileImage: profileImage, nickname: nickname)
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
    
    func snsJoin(email: String, profileImage: String?, nickname: String?) {
        
        let storyboard = UIStoryboard(name: "Join", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: SNSJoinVC.identifier) as? SNSJoinVC
        self.navigationController?.pushViewController(nextVC!, animated: true)
            
        nextVC?.contractView.nextButton.nextPageClosure = {
            let isPushAgree = nextVC?.contractView.agreePushButton.Agreed
            let isEmailAgree = nextVC?.contractView.agreeEmailButton.Agreed
            
            switch self.snsType {
            case "A":
                print("애플 소셜 회원가입")
                SocialJoinService.shared.appleJoin(email: email,
                                                   pushAgree: isPushAgree!,
                                                   emailAgree: isEmailAgree!) { result in
                    

                    switch result {
                    
                    case .success(let data):
                        if let personData = data as? UserInitialInfo {
                            
                            
                            UserDefaults.standard.set(personData.email, forKey: Constants.UserDefaultsKey.userEmail)
                            UserDefaults.standard.set(personData.profileImage, forKey: Constants.UserDefaultsKey.userImage)
                            UserDefaults.standard.set(personData.nickname, forKey: Constants.UserDefaultsKey.userNickname)
                        }
                        self.navigationController?.popViewController(animated: true)
                        self.goToHomeVC()
                        
                        
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
                break
                
            case "G":
                print("구글 소셜 회원가입")
                SocialJoinService.shared.googleJoin(email: email,
                                                    profileImage: "",
                                                    pushAgree: isPushAgree!,
                                                    emailAgree: isEmailAgree!) { result in
                    

                    switch result {
                    
                    case .success(let data):
                        print("data : \(data)")
                        if let personData = data as? UserInitialInfo {

                            print("personData : \(personData)")
                            UserDefaults.standard.set(personData.email, forKey: Constants.UserDefaultsKey.userEmail)
                            UserDefaults.standard.set(personData.profileImage, forKey: Constants.UserDefaultsKey.userImage)
                            UserDefaults.standard.set(personData.nickname, forKey: Constants.UserDefaultsKey.userNickname)

                        }
                        self.navigationController?.popViewController(animated: true)
                        self.goToHomeVC()
                        
                        
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
                break
                
            case "K":
                print("카카오 소셜 회원가입")
                SocialJoinService.shared.kakaoJoin(email: email,
                                                   profileImage: "",
                                                   pushAgree: isPushAgree!,
                                                   emailAgree: isEmailAgree!,
                                                   nickname: nickname!) { result in
                    
                    switch result {
                    
                    case .success(let data):
                        if let personData = data as? UserInitialInfo {
                            
                            UserDefaults.standard.set(personData.email, forKey: Constants.UserDefaultsKey.userEmail)
                            UserDefaults.standard.set(personData.profileImage, forKey: Constants.UserDefaultsKey.userImage)
                            UserDefaults.standard.set(personData.nickname, forKey: Constants.UserDefaultsKey.userNickname)
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                        self.goToHomeVC()
                        
                        
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
                break
                
            default:
                print(self.snsType)
                break
            }
            
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
    
    private func goToHomeVC() {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: TabbarVC.identifier)
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    private func configureNavigationController() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    private func configureUI() {
        view.backgroundColor = UIColor.white
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

//MARK: - Apple Login
extension SNSLoginVC : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // AppleID 연동 성공
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print(credential.user)
            let user = credential.user
            print("👨‍🍳 \(user)")
            if let email = credential.email {
                socialLogin(email: email, profileImage: nil, nickname: nil)
            }
        }
        
            
//            // AppleID 로 로그인 시도
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//            if let userEmail = appleIDCredential.email {
//                socialLogin(email: userEmail, profileImage: nil, nickname: nil)
//            }
//
//            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.isAppleLogin)
//            UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.isKakaoLogin)
//            UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.isGoogleLogin)
//
    }
    
    // AppleID 연동 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error \(error)")
    }
    
}
