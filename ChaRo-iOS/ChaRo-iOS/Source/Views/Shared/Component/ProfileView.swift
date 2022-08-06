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
    
    //actionsheet 생성을 위한 클로저
    var actionSheetPresentClosure: ((UIAlertController) -> Void)?
    
    //picker 생성을 위한 클로져
    var imagePickerPresentClosure: ((UIImagePickerController) -> Void)?
    
    //Done 버튼 활성화를 위한 클로저
    var doneButtonClosure: (() -> Void)?
    
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
    
    @objc private func carmeraButtonClicked() {
        
        let actionsheetController = UIAlertController(title: "프로필 사진 바꾸기", message: nil, preferredStyle: .actionSheet)
        
        let actionDefaultImage = UIAlertAction(title: "기본 이미지 설정", style: .default, handler: { action in
            self.profileImageView.image = ImageLiterals.imgMypageDefaultProfile
            
            if let doneClosure = self.doneButtonClosure {
                doneClosure()
            }
        })
        let actionLibraryImage = UIAlertAction(title: "라이브러리에서 선택", style: .default, handler: { action in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            
            //피커 띄우기
            if let pickerClosure = self.imagePickerPresentClosure {
                pickerClosure(picker)
            }
            
        })
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: { action in
            print("캔슬 action called")
        })
        
        actionsheetController.addAction(actionDefaultImage)
        actionsheetController.addAction(actionLibraryImage)
        actionsheetController.addAction(actionCancel)
        
        if let actionClosure = self.actionSheetPresentClosure {
            actionClosure(actionsheetController)
        }
    }
    
}
