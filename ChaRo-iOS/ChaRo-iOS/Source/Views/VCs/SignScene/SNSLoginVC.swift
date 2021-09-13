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
    
    
    func configureUI() {
        view.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
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
