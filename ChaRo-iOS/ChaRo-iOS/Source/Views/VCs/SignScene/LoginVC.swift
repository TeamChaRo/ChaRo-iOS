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
        setConstraints()
        setLoginButtonUI()
        setNotificationCenter()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    func setLoginButtonUI() {
        titleLabel.font = .notoSansMediumFont(ofSize: 17)
        
        loginButton.layer.cornerRadius = 8
        loginButton.tintColor = .mainBlue
        
        joinButton.setTitleColor(.gray30, for: .normal)
        
    }
    
    
    func loginAction(){
        
        LoginService.shared.login(id: self.idTextField.text!, password: self.pwdTextField.text!) {
            result in

            switch result
            {
            case .success(let data):
                print("일반 로그인 성공 \(data)")
                let loginData = data as? LoginDataModel
                let userData = loginData?.data

                //UserDefaults에 이메일, 닉네임, 프로필 사진, 소셜 로그인 여부 저장
                if let user = userData {
                    UserDefaults.standard.set(user.email, forKey: "userId")
                    UserDefaults.standard.set(user.nickname, forKey: "nickname")
                    UserDefaults.standard.set(user.profileImage, forKey: "profileImage")
                    UserDefaults.standard.set(user.isSocial, forKey: "isSocial")
                }

            case .requestErr(let message):
                if let message = message as? String {
                    print(message)
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
        let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: TabbarVC.identifier)
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func textFieldMoveUp(_ notification: NSNotification){
        
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
            })
        }
        
    }
    
    @objc
    func textFieldMoveDown(_ notification: NSNotification){
        view.transform = .identity
    }
    
    
    
}

extension LoginVC {
    func setConstraints() {
        
        if UIScreen.hasNotch {
            let factor = UIScreen.main.bounds.width / 375
            
            heightConstraint.constant = factor * 464
        } else {
            heightConstraint.constant = 356
            imageView.image = UIImage(named: "maskGroupSE")
            
        }
        
        
        
        
        
    }
}
