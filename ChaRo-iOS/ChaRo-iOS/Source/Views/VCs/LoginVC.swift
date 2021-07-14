//
//  LoginVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/15.
//

import UIKit

class LoginVC: UIViewController {

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
    
    private let idTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private let pwdTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private let joinButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        
        
    }
    

}
