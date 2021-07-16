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
    
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    static let identifier = "LoginVC"
    
    //MARK: - Component
    private let CharoimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "maskGroup")
        return imageView
    }()

    private let idBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "idBackground")
        return imageView
    }()

    private let pwdBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pwdBackground")
        return imageView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setLoginButtonUI()
    }
    
    func setLoginButtonUI() {
        loginButton.layer.cornerRadius = 8
        loginButton.tintColor = .mainBlue
        
        joinButton.setTitleColor(.gray30, for: .normal)
        
    }
    
    func loginAction(){
            
            LoginService.shared.login(id: self.idTextField.text!, password: self.pwdTextField.text!) { result in
                
                switch result
                {
                case .success(let data):
                    let loginData = data as? LoginDataModel
                    let userData = loginData?.data
                    dump(userData)
                    
                    if let user = userData as? UserData {
                        
                        UserDefaults.standard.set(user.userId, forKey: "userId")
                        UserDefaults.standard.set(user.nickname, forKey: "nickname")
                        UserDefaults.standard.set(user.token, forKey: "token")
                        
                        print(UserDefaults.standard.string(forKey: "userId"))
                        print(UserDefaults.standard.string(forKey: "nickname"))
                        print(UserDefaults.standard.string(forKey: "token"))
                    }
                    
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
    
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        loginAction()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
    }
    

    
}

extension LoginVC {
    func setConstraints() {

        let factor = UIScreen.main.bounds.width / 375

        heightConstraint.constant = factor * 464
        
        view.addSubview(CharoimageView)
        view.addSubview(idBackground)
        view.addSubview(pwdBackground)
        
        view.addSubviews([CharoimageView,
                          idBackground,
                          pwdBackground,
                          idTextField,
                          pwdTextField,
                          joinButton])

        CharoimageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(464 * factor)
        }

        idBackground.snp.makeConstraints {
            $0.top.equalTo(CharoimageView.snp.bottom).offset(13)
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(64)
        }
        
        idBackground.snp.makeConstraints {
            $0.top.equalTo(idBackground.snp.bottom).offset(-5)
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(64)
        }
        
    }
}
