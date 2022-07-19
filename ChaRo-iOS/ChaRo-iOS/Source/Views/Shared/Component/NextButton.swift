//
//  NextButton.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit

class NextButton: UIButton {

    var nextPageClosure: (() -> Void)?
    var nextViewClosure: (() -> Void)?
    var isTheLast: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(isSticky: Bool, isTheLast: Bool, isTempPassword: Bool = false) {
        super.init(frame: .zero)
        self.isTheLast = isTheLast
        configureUI(isSticky: isSticky, isTempPassword: isTempPassword)
        self.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    
    //다음 버튼이 마지막 단계일 경우 다음 페이지 뷰로 이동 -> JoinVC에서 클로저 구현
    //다음 단계가 있을 경우 -> 각 View에서 클로저 구현
    @objc func nextButtonClicked() {
        
        if isTheLast {
            self.nextPageClosure!()
        }
        else {
            self.nextViewClosure!()
            isTheLast.toggle()
        }
        
    }
    
    private func configureUI(isSticky: Bool, isTempPassword: Bool) {
        
        self.setTitle(isTempPassword ? "임시 비밀번호 전송" : "다음", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .gray30
        
        if isSticky {
            self.titleLabel?.font = .notoSansBoldFont(ofSize: 16)
        } else {
            self.clipsToBounds = true
            self.layer.cornerRadius = 10
        }
    }

}
