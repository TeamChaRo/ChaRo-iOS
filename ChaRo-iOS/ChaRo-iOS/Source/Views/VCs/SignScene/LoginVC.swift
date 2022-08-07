//
//  LoginVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/15.
//

import UIKit

class LoginVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var findPasswordButton: UIButton!
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    static let identifier = "LoginVC"
    
    
    //MARK: 생성주기함수
    override func viewDidLoad() {
        super.viewDidLoad()
        configureConstraints()
        configureLoginButtonUI()
        configureTextfieldUI()
        configureNotificationCenter()
        configureDelegate()
        addTestUserAccount()
    }
    
    private func addTestUserAccount() {
        self.idTextField.text = "charo@ios.com"
        self.pwdTextField.text = "charo0505"
    }
    
    private func configureDelegate() {
        idTextField.delegate = self
        pwdTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func configureLoginButtonUI() {
        titleLabel.font = .notoSansMediumFont(ofSize: 17)
        
        loginButton.layer.cornerRadius = 8
        loginButton.tintColor = .mainBlue
        
        joinButton.setTitleColor(.gray30, for: .normal)
    }
    
    func configureTextfieldUI() {
        let height = idTextField.frame.height
        self.idTextField.layer.cornerRadius = 10
        self.pwdTextField.layer.cornerRadius = 10
        
        self.idTextField.layer.borderWidth = 1.0
        self.pwdTextField.layer.borderWidth = 1.0

        self.idTextField.layer.borderColor = UIColor.neomorfismBlueLine.cgColor
        self.pwdTextField.layer.borderColor = UIColor.neomorfismBlueLine.cgColor

        self.idTextField.leftViewMode = .always
        self.pwdTextField.leftViewMode = .always

        self.idTextField.clearButtonMode = .never
        self.pwdTextField.clearButtonMode = .never

        self.idTextField.rightViewMode = .whileEditing
        self.pwdTextField.rightViewMode = .whileEditing

        let idContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: height))
        let pwdContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: height))

        let idImageView = UIImageView(frame: CGRect(x: 5, y: 4, width: 40, height: 40))
        let pwdImageView = UIImageView(frame: CGRect(x: 5, y: 4, width: 40, height: 40))

        idImageView.image = ImageLiterals.icId
        pwdImageView.image = ImageLiterals.icPassword

        idContainerView.addSubview(idImageView)
        pwdContainerView.addSubview(pwdImageView)

        idTextField.leftView = idContainerView
        pwdTextField.leftView = pwdContainerView
        
        let idClearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        idClearButton.setImage(ImageLiterals.icMapSearchClose, for: [])
        idClearButton.addTarget(self, action: #selector(clearIdTextField), for: .touchUpInside)
        
        let pwdClearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        pwdClearButton.setImage(ImageLiterals.icMapSearchClose, for: [])
        pwdClearButton.addTarget(self, action: #selector(clearPwdTextField), for: .touchUpInside)
        
        self.idTextField.rightView = idClearButton
        self.pwdTextField.rightView = pwdClearButton
    }
    
    func loginAction() {
        guard let userEmail = self.idTextField.text, !userEmail.isEmpty else {
            self.makeAlert(title: "로그인 실패", message: "아이디를 입력해주세요.")
            return
        }
        guard let userPassword = self.pwdTextField.text, !userPassword.isEmpty else {
            self.makeAlert(title: "로그인 실패", message: "비밀번호를 입력해주세요.")
            return
        }
        LoginService.shared.login(id: userEmail, password: userPassword) {
            result in
            
            switch result
            {
            case .success(let data):
                print("일반 로그인 성공 \(data)")
                let loginData = data as? LoginDataModel
                let userData = loginData?.data
                
                //UserDefaults에 이메일, 닉네임, 프로필 사진 저장
                if let user = userData {
                    UserDefaults.standard.set(user.email, forKey: Constants.UserDefaultsKey.userEmail)
                    UserDefaults.standard.set(userPassword, forKey: Constants.UserDefaultsKey.userPassword)
                    UserDefaults.standard.set(user.nickname, forKey: Constants.UserDefaultsKey.userNickname)
                    UserDefaults.standard.set(user.profileImage, forKey: Constants.UserDefaultsKey.userImage)
                    UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.isLogin)
                }
                self.showHomeVC()
                
            case .requestErr(let message):
                if let message = message as? String {
                    if message.contains("아이디") {
                        self.makeAlert(title: "로그인 실패",
                                       message: "가입된 아이디가 없습니다. 회원가입 후 이용해 주세요.")
                    }
                    else {
                        self.makeAlert(title: "로그인 실패",
                                   message: message)
                    }
                }
            default :
                print("ERROR")
            }
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func findPwdButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: FindPasswordVC.identifier) as? FindPasswordVC else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        loginAction()
    }
    
    private func showHomeVC() {
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: TabbarVC.identifier)
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func textFieldMoveUp(_ notification: NSNotification){
        self.view.frame.origin.y = -150
    }
    
    @objc
    func textFieldMoveDown(_ notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc
    func clearIdTextField() {
        self.idTextField.text = ""
    }
    
    @objc
    func clearPwdTextField() {
        self.pwdTextField.text = ""
    }
}

extension LoginVC {
    func configureConstraints() {
        if UIScreen.hasNotch {
            let factor = UIScreen.main.bounds.width / 375
            
            heightConstraint.constant = factor * 464
        } else {
            heightConstraint.constant = 356
            imageView.image = UIImage(named: "maskGroupSE")
        }
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == idTextField {
            pwdTextField.becomeFirstResponder()
        } else {
            pwdTextField.resignFirstResponder()
        }
        return true
    }
}
