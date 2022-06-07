//
//  UserDefaultKey.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2022/03/27.
//

import Foundation

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
}
