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
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        addSubviews([profileImageView,
                     cameraButton])
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.width.height.equalTo(112)
        }
        
        cameraButton.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(72)
            $0.leading.equalTo(self.snp.leading).offset(72)
            $0.width.height.equalTo(48)
        }
    }
    
    @objc func carmeraButtonClicked() {
        
    }

}
