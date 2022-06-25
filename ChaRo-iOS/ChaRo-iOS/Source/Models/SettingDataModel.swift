//
//  SettingDataModel.swift
//  ChaRo-iOS
//
//  Created by hwangJi on 2022/06/25.
//

import Foundation
import UIKit

// MARK: - SettingDataModel
struct SettingDataModel {
    var isToggle: Bool = false
    var toggleData: Bool = false
    var isSubLabel: Bool = false
    var subLabelString: String = ""
    var titleString: String = ""
    var titleLabelColor: UIColor = UIColor.black
    var subLabelColor: UIColor = UIColor.white
    
    init() { }
    
    // 토글 있는 부분 init
    init(titleString: String, isToggle: Bool, toggleData: Bool) {
        self.titleString = titleString
        self.isToggle = isToggle
        self.toggleData = toggleData
    }
    
    // 좌측 문구 init
    init(isSubLabel: Bool, subLabelString: String, subLabelColor: UIColor) {
        self.isSubLabel = isSubLabel
        self.subLabelString = subLabelString
        self.subLabelColor = subLabelColor
    }
    
    // 기본 글씨 색상 init
    init(titleString: String, titleLabelColor: UIColor) {
        self.titleString = titleString
        self.titleLabelColor = titleLabelColor
    }
    
    // 기본 글씨 + 좌측 글씨 + 색상
    init(titleString: String, titleLabelColor: UIColor, isSubLabel: Bool, subLabelString: String, subLabelColor: UIColor) {
        self.titleString = titleString
        self.titleLabelColor = titleLabelColor
        self.isSubLabel = isSubLabel
        self.subLabelString = subLabelString
        self.subLabelColor = subLabelColor
    }
}

// MARK: - SettingSection
enum SettingSection: CaseIterable {
    case accessAllow
    case account
    case info
    case serviceCenter
    case terms
}

extension SettingSection {
    var settingData: [SettingDataModel] {
        switch self {
        case .accessAllow:
            return [SettingDataModel(titleString: "사진", isToggle: true, toggleData: true)]
        case .account:
            return [SettingDataModel(titleString: "프로필 수정", titleLabelColor: UIColor.black),
                    SettingDataModel(titleString: "비밀번호 수정", titleLabelColor: UIColor.black),
                    SettingDataModel(titleString: "이메일", titleLabelColor: UIColor.black, isSubLabel: true, subLabelString: "\(UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.userEmail) ?? "ios@gmail.com")", subLabelColor: UIColor.black)]
        case .info:
            return [SettingDataModel(titleString: "공지사항", titleLabelColor: UIColor.black)]
        case .serviceCenter:
            return [SettingDataModel(titleString: "1:1 문의", titleLabelColor: UIColor.black),
                    SettingDataModel(titleString: "신고하기", titleLabelColor: UIColor.black)]
        case .terms:
            return [SettingDataModel(titleString: "개인정보 처리방침", titleLabelColor: UIColor.black),
                    SettingDataModel(titleString: "서비스 이용약관", titleLabelColor: UIColor.black),
                    SettingDataModel(titleString: "오픈소스 라이선스", titleLabelColor: UIColor.black),
                    SettingDataModel(titleString: "버전 정보", titleLabelColor: UIColor.gray30, isSubLabel: true, subLabelString: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "", subLabelColor: UIColor.gray30),
                    SettingDataModel(titleString: "로그아웃", titleLabelColor: UIColor.mainBlue),
                    SettingDataModel(titleString: "회원탈퇴", titleLabelColor: UIColor.mainOrange)]
        }
    }
}
