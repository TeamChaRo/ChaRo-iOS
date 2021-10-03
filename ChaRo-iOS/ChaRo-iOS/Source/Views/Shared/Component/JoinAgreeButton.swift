//
//  JoinAgreeButton.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/04.
//

import UIKit

class JoinAgreeButton: UIButton {
    
    var Agreed = false

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(isBig: Bool) {
        super.init(frame: .zero)
        
        if isBig {
            self.setBackgroundImage(UIImage(named: "icSignupDisagreeBig"), for: .normal)
        } else {
            self.setBackgroundImage(UIImage(named: "icSignupDisagreeSmall"), for: .normal)
        }
        
        self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        
    }
    
    @objc func buttonClicked() {
        
        if Agreed {
            self.setBackgroundImage(UIImage(named: "icSignupAgreeBig"), for: .normal)
        } else {
            self.setBackgroundImage(UIImage(named: "icSignupAgreeSmall"), for: .normal)
        }
        Agreed = !Agreed
        
    }
    
    


}
