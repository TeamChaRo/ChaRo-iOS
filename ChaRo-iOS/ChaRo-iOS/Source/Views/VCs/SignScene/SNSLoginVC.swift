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
import KakaoSDKAuth

enum socialType: String {
    case google
    case kakao
    case apple
    case none
}

class SNSLoginVC: UIViewController {
    
    let userInfo = UserInfo.shared
    let signInConfig = GIDConfiguration.init(clientID: "316255098127-usdg37h4sgpondqjh818cl3n002vaach.apps.googleusercontent.com")
    
    static let identifier = "SNSLoginVC"
    var socialType: socialType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        configureUI()
        autoLogin()
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
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 17)
        $0.setImage(UIImage(named: "appleLogo"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 180)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
    }
    
    let googleLoginBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("Google 로그인", for: .normal)
        $0.setTitleColor(.mainBlack, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 17)
        $0.setImage(UIImage(named: "googleLogo"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 180)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
        $0.layer.borderColor = UIColor.gray30.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.showsTouchWhenHighlighted = false
        $0.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
    }
    
    let kakaoLoginBtn = UIButton().then {
        $0.setImage(UIImage(named: "kakaoLogo"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 190)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
        $0.backgroundColor = UIColor(red: 254.0 / 255.0, green: 229.0 / 255.0, blue: 0.0, alpha: 1.0)
        $0.setTitle("카카오 로그인", for: .normal)
        $0.setTitleColor(.mainBlack, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 17)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(kakaoLogin), for: .touchUpInside)
    }
    
    @objc func lookAroundButtonClicked() {
        //isLogin 값을 false로 설정 - 둘러보기이므로 계정 없음
        Constants.removeAllUserDefaults()
        UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.isLogin)
        self.goToHomeVC()
    }
    
    private func autoLogin() {
        guard let userEmail = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.userEmail) else { return }
        
        //소셜로그인
        let isSNSLogin = UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.isSNSLogin)
        if isSNSLogin {
            SocialLoginService.shared.socialLogin(email: userEmail) { (response) in
                switch(response) {
                case .success(let data):
                    if let data = data as? UserData {
                        print("자동 로그인 성공! - 소셜 로그인")
                        Constants.addUserDefaults(userEmail: data.email,
                                                  userPassword: "",
                                                  userNickname: data.nickname ?? "",
                                                  userImage: data.profileImage ?? "")
                        UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.isSNSLogin)
                        self.goToHomeVC()
                    }
                case .requestErr(let message) :
                    if let message = message as? String {
                        print("자동 로그인 ERROR - 소셜 로그인: \(message)")
                    }
                default :
                    print("자동 로그인 ERROR - 소셜 로그인")
                }
                
            }
            return
        }

        //일반로그인
        guard let userPassword = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.userPassword) else { return }
        
        LoginService.shared.login(id: userEmail, password: userPassword) { result in
            switch result {
            case .success(let data) :
                print("자동 로그인 성공! - 이메일 로그인")
                self.goToHomeVC()
            case .requestErr(let message) :
                if let message = message as? String {
                    print("자동 로그인 ERROR - 이메일 로그인 : \(message)")
                }
            default :
                print("자동 로그인 ERROR - 이메일 로그인")
            }
            
        }
    }
    
    @objc func appleLogin() {
        socialType = .apple
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
        socialType = .google
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            
            let userEmail = user?.profile?.email
            self.socialLogin(email: userEmail, id: nil, profileImage: nil, nickname: nil)
            //여기 유저 이미지 ... String 으로 변환 모루겟다
            //            do {
            //                var userProfileImageString = try String(contentsOf: URL(string: (user?.profile?.imageURL(withDimension: 320)!)!)!)
            //            }
            //            catch let error {
            //                print("URL 인코딩 에러")
            //            }
        }
    }
    
    @objc func kakaoLogin() {
        socialType = .kakao
        
        // 카톡 앱 설치 여부
        if (UserApi.isKakaoTalkLoginAvailable()) {
            self.kakaoLoginByApp()
        } else {
            self.makeAlert(title: "카카오톡 미설치", message: "카카오톡이 설치되어 있지 않습니다. 로그인을 위해 웹으로 이동합니다.", okAction: { _ in
                self.kakaoLoginByWeb()
            })
        }
    }
    
    // 카톡 앱으로 로그인
    private func kakaoLoginByApp() {
        UserApi.shared.loginWithKakaoTalk {(_, error) in
            if let error = error {
                print(error)
            }
            else {
                UserApi.shared.me() { (user, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        // 닉네임, 이메일 정보
                        let id = user?.id
                        let email = user?.kakaoAccount?.email
                        let nickname = user?.kakaoAccount?.profile?.nickname
                        let profile = user?.kakaoAccount?.profile?.profileImageUrl
                        //여기서도 URL 을 String 으로 바꾸는 법을 모르겠군요 ...
                        
                        //로그인
                        self.socialLogin(email: email, id: "\(id)", profileImage: nil, nickname: nickname)
                    }
                }
            }
        }
    }
    
    // 카톡 앱 미설치시 웹으로 로그인
    private func kakaoLoginByWeb() {
        UserApi.shared.loginWithKakaoAccount {(_, error) in
            if let error = error {
                print(error)
            }
            
            else {
                UserApi.shared.me() { (user, error) in
                    
                    if let error = error {
                        print(error)
                    } else {
                        print("loginWithKakaoAccount me() sucess.")
                        
                        let id = user?.id
                        let email = user?.kakaoAccount?.email
                        let nickname = user?.kakaoAccount?.profile?.nickname
                        
                        //로그인
                        self.socialLogin(email: email, id: "\(id)", profileImage: nil, nickname: nickname)
                    }
                    
                }
            }
        }
    }
    
    @objc func socialLogin(email: String?, id: String?, profileImage: String?, nickname: String?) {
        var finalEmail: String = ""
        
        if let email = email {
            finalEmail = email
        } else {
            if let id = id {
                finalEmail = "Kakao@\(id)"
            } else {
                self.makeAlert(title: "오류", message: "카카오 계정 정보를 불러오지 못했습니다.")
                return
            }
        }

        SocialLoginService.shared.socialLogin(email: finalEmail) { (response) in
            
            switch(response) {
            case .success(let data):
                if let data = data as? UserData {
                    print("로그인 성공")
                    //여기서 UserDefault 에 저장
                    Constants.addUserDefaults(userEmail: data.email,
                                              userPassword: "",
                                              userNickname: data.nickname,
                                              userImage: data.profileImage)
                    UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.isSNSLogin)
                    self.goToHomeVC()
                } else {
                    print("회원가입 갈겨")
                    self.snsJoin(email: finalEmail, profileImage: profileImage, nickname: nickname)
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
        guard let nextVC = storyboard.instantiateViewController(withIdentifier: SNSJoinVC.identifier) as? SNSJoinVC else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        nextVC.contractView.nextButton.nextPageClosure = {
            let isPushAgree = nextVC.contractView.agreePushButton.agreed
            let isEmailAgree = nextVC.contractView.agreeEmailButton.agreed
            
            switch self.socialType {
            case .apple:
                print("애플 소셜 회원가입")
                SocialJoinService.shared.appleJoin(email: email,
                                                   pushAgree: isPushAgree,
                                                   emailAgree: isEmailAgree) { result in
                    
                    
                    switch result {
                        
                    case .success(let data):
                        if let personData = data as? JoinUserModel {
                            Constants.addUserDefaults(userEmail: personData.email,
                                                      userPassword: "",
                                                      userNickname: personData.nickname,
                                                      userImage: personData.profileImage)
                            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.isSNSLogin)
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
                
            case .google:
                print("구글 소셜 회원가입")
                SocialJoinService.shared.googleJoin(email: email,
                                                    profileImage: "",
                                                    pushAgree: isPushAgree,
                                                    emailAgree: isEmailAgree) { result in
                    
                    
                    switch result {
                        
                    case .success(let data):
                        if let personData = data as? JoinUserModel {
                            Constants.addUserDefaults(userEmail: personData.email,
                                                      userPassword: "",
                                                      userNickname: personData.nickname,
                                                      userImage: personData.profileImage)
                            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.isSNSLogin)
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
                
            case .kakao:
                print("카카오 소셜 회원가입")
                SocialJoinService.shared.kakaoJoin(email: email,
                                                   profileImage: "",
                                                   pushAgree: isPushAgree,
                                                   emailAgree: isEmailAgree,
                                                   nickname: nickname!) { result in
                    
                    switch result {
                        
                    case .success(let data):
                        if let personData = data as? JoinUserModel {
                            Constants.addUserDefaults(userEmail: personData.email,
                                                      userPassword: "",
                                                      userNickname: personData.nickname,
                                                      userImage: personData.profileImage)
                            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.isSNSLogin)
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
                print(self.socialType)
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
            $0.width.equalTo(211)
            $0.height.equalTo(74)
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
            if let email = credential.email {
                print("애플 최초 로그인 이메일 \(email)")
                UserDefaults.standard.set(email, forKey: Constants.UserDefaultsKey.savedAppleEmail)
                socialLogin(email: email, id: nil, profileImage: nil, nickname: nil)
            } else {
                if let savedAppleEmail = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.savedAppleEmail) {
                    socialLogin(email: savedAppleEmail, id: nil, profileImage: nil, nickname: nil)
                } else {
                    self.makeAlert(title: "로그인 오류", message: "로그인 하기 위해서는 이메일 계정 정보가 필요합니다. 설정 > 계정 > 암호 및 보안 > Apple ID 를 사용하는 앱 > XC com king Charo 를 애플 아이디 사용 중단 한 후, 시도해주세요.")
                }
            }
        } else {
            print("Credential error")
        }
    }
    
    // AppleID 연동 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization error \(error)")
    }
    
}


//            self.makeRequestAlert(title: "카카오톡 미설치",
//                                  message: "카카오톡이 설치되어 있지 않습니다.\n설치를 위해 앱스토어로 이동하시겠습니까?",
//                                  okAction: { (action) in
//                let appId = "362057947"
//                if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appId)"), UIApplication.shared.canOpenURL(url) {
//                    if #available(iOS 10.0, *) {
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    } else {
//                        UIApplication.shared.openURL(url)
//                    }
//                }
//            })
