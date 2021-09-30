//
//  ProfileView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/09/30.
//

import UIKit

class ProfileView: UIView, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "profileImage")
    }
    
    var cameraButton = UIButton().then {
        $0.setImage(UIImage(named: "icCamera"), for: .normal)
        $0.addTarget(self, action: #selector(carmeraButtonClicked), for: .touchUpInside)
    }
    
    var callingViewController: UIViewController?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(viewController: UIViewController) {
        super.init(frame: .zero)
        self.callingViewController = viewController
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
        
        print("dddd")
        
        let picker = UIImagePickerController()
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = callingViewController! as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        callingViewController?.present(picker, animated: true)
    }

}
