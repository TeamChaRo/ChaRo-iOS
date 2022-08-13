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

        //온보드 유무
        static let onBoardSeen = "onBoardSeen"
        
        //유저 정보
        static let userEmail = "userEmail"
        static let userPassword = "userPassword"
        static let userNickname = "userNickname"
        static let userImage = "userImage"

        //둘러보기를 위한 로그인 여부
        static let isLogin = "isLogin"

        //소셜 로그인 구분
        static let isAppleLogin = "isAppleLogin"
        static let savedAppleEmail = "savedAppleEmail"
        
        static let isKakaoLogin = "isKakaoLogin"
        static let isGoogleLogin = "isGoogleLogin"

        //포토 라이브러리 권한 팝업 여부
        static let shownPhotoAuth = "shownPhotoAuth"
    }
    
    static func addLoginUserDefaults(isAppleLogin: Bool, isKakaoLogin: Bool, isGoogleLogin: Bool) {
        UserDefaults.standard.set(isAppleLogin, forKey: Constants.UserDefaultsKey.isAppleLogin)
        UserDefaults.standard.set(isKakaoLogin, forKey: Constants.UserDefaultsKey.isKakaoLogin)
        UserDefaults.standard.set(isGoogleLogin, forKey: Constants.UserDefaultsKey.isGoogleLogin)
        UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.shownPhotoAuth)
    }
    
    static func addUserDefaults(userEmail: String, userPassword: String, userNickname: String, userImage: String) {
        UserDefaults.standard.set(userEmail, forKey: Constants.UserDefaultsKey.userEmail)
        UserDefaults.standard.set(userPassword, forKey: Constants.UserDefaultsKey.userPassword)
        UserDefaults.standard.set(userNickname, forKey: Constants.UserDefaultsKey.userNickname)
        UserDefaults.standard.set(userImage, forKey: Constants.UserDefaultsKey.userImage)
        UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.isLogin)
        UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.shownPhotoAuth)
    }

    static func shownPhotoLibrary() {
        UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.shownPhotoAuth)
    }
    
    static func removeAllUserDefaults() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.userEmail)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.userPassword)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.userNickname)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.userImage)
        
        UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.isLogin)
        
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.isAppleLogin)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.isKakaoLogin)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.isGoogleLogin)

        UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.shownPhotoAuth)
    }
}
