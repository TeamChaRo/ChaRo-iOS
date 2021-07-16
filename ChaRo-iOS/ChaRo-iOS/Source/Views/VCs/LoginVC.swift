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
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    
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
//
//    private let idTextField: UITextField = {
//        let textField = UITextField()
//        return textField
//    }()
//
//    private let pwdTextField: UITextField = {
//        let textField = UITextField()
//        return textField
//    }()
//

    private let joinButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
    }
    
    
    func loginAction(){
            
        LoginService.shared.login(id: self.idTextField.text!, password: self.pwdTextField.text!) { result in
            
            switch result
            {
            case .success(let data):
                print("여기까진..")
                
                if let userData = data as? LoginDataModel {
                    dump(userData)
                    
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
    
}

extension LoginVC {
    func setConstraints() {

        let factor = UIScreen.main.bounds.width / 375

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
