//
//  ProfileView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/09/30.
//

import UIKit

class ProfileView: UIView, UIImagePickerControllerDelegate {

    var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "")
    }
    
    var cameraButton = UIButton().then {
        $0.addTarget(self, action: #selector(carmeraButtonClicked), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func carmeraButtonClicked() {
        
    }

}
