//
//  JoinPasswordView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit

class JoinPasswordView: UIView {

    let passwordInputView = PasswordView(title: "비밀번호", subTitle: "5자 이상 15자 이내의 비밀번호를 입력해주세요.")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    private func configureUI() {
                
        self.addSubviews([passwordInputView])
        
        passwordInputView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(200)
        }
        
        passwordInputView.enableNextButtonClosure = {
            //self.nextButton.setTitle("됐다!!!", for: .normal)
            print("나중에 자기 버튼 만들어서 넣기")
        }
        passwordInputView.unableNextButtonClosure = {
            //self.nextButton.setTitle("다음", for: .normal)
            print("나중에 자기 버튼 만들어서 넣기")
        }
        
        self.dismissKeyboardWhenTappedAround()
        
    }

}