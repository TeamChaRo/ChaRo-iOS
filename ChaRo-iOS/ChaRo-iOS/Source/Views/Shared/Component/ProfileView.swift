//
//  ProfileView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/09/30.
//

import UIKit

class ProfileView: UIView {

    var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "icProfile")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 112 / 2
    }
    
    var cameraButton = UIButton().then {
        $0.setImage(UIImage(named: "icCamera"), for: .normal)
        $0.addTarget(self, action: #selector(carmeraButtonClicked), for: .touchUpInside)
    }
    
    //picker 생성을 위한 클로져
    var imagePickerPresentClosure: ((UIImagePickerController) -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(viewController: UIViewController) {
        super.init(frame: .zero)
        
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
        
        let picker = UIImagePickerController()
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        //클로져 함수 실행
        self.imagePickerPresentClosure!(picker)
    }

}
