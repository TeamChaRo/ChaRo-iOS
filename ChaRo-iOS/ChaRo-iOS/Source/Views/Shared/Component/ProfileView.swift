//
//  ProfileView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/09/30.
//

import UIKit
import Photos
import PhotosUI

class ProfileView: UIView {
    private var shownPhotoAuth: Bool = UserDefaults.standard.bool(
        forKey: Constants.UserDefaultsKey.shownPhotoAuth
    )
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(carmeraButtonClicked))
    
    lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "icProfile")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 112 / 2
        $0.addGestureRecognizer(tapGesture)
        $0.isUserInteractionEnabled = true
    }
    
    var cameraButton = UIButton().then {
        $0.setImage(UIImage(named: "icCamera"), for: .normal)
        $0.addTarget(self, action: #selector(carmeraButtonClicked), for: .touchUpInside)
    }
    
    //actionsheet 생성을 위한 클로저
    var actionSheetPresentClosure: ((UIAlertController) -> Void)?
    
    //picker 생성을 위한 클로져
    var imagePickerPresentClosure: ((UIImagePickerController) -> Void)?
    var authSettingOpenClosure: ((String) -> Void)?
    
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
        
        if #available(iOS 14, *) {
            if self.PhotoAuth() {
                showImagePicker()
            } else {
                guard self.shownPhotoAuth == true else {
                    Constants.shownPhotoLibrary()
                    return
                }
                if let authSettingClosure = self.authSettingOpenClosure {
                    authSettingClosure("갤러리")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    func showImagePicker() {
        
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
    
    func PhotoAuth() -> Bool {
        // 포토 라이브러리 접근 권한
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        var isAuth = false
        
        switch authorizationStatus {
        case .authorized:
            // 사용자가 앱에 사진 라이브러리에 대한 액세스 권한을 명시 적으로 부여했습니다.
            return true
        case .denied:
            // 사용자가 사진 라이브러리에 대한 앱 액세스를 명시 적으로 거부했습니다.
            break
        case .notDetermined:
            // 사진 라이브러리 액세스에는 명시적인 사용자 권한이 필요하지만 사용자가 아직 이러한 권한을 부여하거나 거부하지 않았습니다
            PHPhotoLibrary.requestAuthorization { (state) in
                if state == .authorized {
                    isAuth = true
                }
            }
            Constants.shownPhotoLibrary()
            return isAuth
        case .restricted:
            // 앱이 사진 라이브러리에 액세스 할 수있는 권한이 없으며 사용자는 이러한 권한을 부여 할 수 없습니다.
            break
        default:
            break
        }
        
        return false
    }
    
    
}
