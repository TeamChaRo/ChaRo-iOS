//
//  UserDefaultKey.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2022/03/27.
//

import Foundation
import SwiftUI

extension Constants {
    struct UserDefaultsKey {

        //유저 정보
        static let userEmail = "userEmail"
        static let userPassword = "userPassword"
        static let userNickname = "userNickname"
        static let userImage = "userImage"

        //둘러보기를 위한 로그인 여부
        static let isLogin = "isLogin"

        //소셜 로그인 구분
        static let isAppleLogin = "isAppleLogin"
        static let isKakaoLogin = "isKakaoLogin"
        static let isGoogleLogin = "isGoogleLogin"
    }
    
    static func removeAllUserDefaults() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.userEmail)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.userPassword)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.userNickname)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.userImage)
        
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.isLogin)
        
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.isAppleLogin)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.isKakaoLogin)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.isGoogleLogin)
    }
}
