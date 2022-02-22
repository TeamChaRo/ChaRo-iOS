//
//  XmarkBackButton.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/11.
//

import UIKit

class XmarkDismissButton : UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
       required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(toDismiss vc: UIViewController) {
        super.init(frame: .zero)
        setBackgroundImage()
        initAction(vc: vc)
    }
    
   private func setBackgroundImage(){
       setBackgroundImage(ImageLiterals.icCloseWhite, for: .normal)
    }
    
    private func initAction(vc: UIViewController) {
        let dismissAction = UIAction { _ in
            vc.dismiss(animated: true, completion: nil)
        }
        addAction(dismissAction, for: .touchUpInside)
    }
    
}
