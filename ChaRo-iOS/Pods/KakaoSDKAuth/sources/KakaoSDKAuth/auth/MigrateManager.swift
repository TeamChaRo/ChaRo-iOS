//  Copyright 2019 Kakao Corp.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import KakaoSDKCommon

public class MigrateManager {
    public static func checkSdkVersionForMigration() {
        SdkLog.d("============================================================================================================")
        SdkLog.d("check migration... ")
        if let sdkVersion = Properties.markedSdkVersion() {
            SdkLog.d(" pass migration... ")
            SdkLog.d(" used sdk version:\(sdkVersion)")
            return
                
            //for
//            if versionKey.hasPrefix("2.") {
//                SdkLog.d("pass migraton...")
//                return
//            }
//            else {
//                //may be v3?
//            }
        }
        else {
            migrateSdk()
        }
    }
        
    public static func migrateSdk() {
        SdkLog.d("============================================================================================================")
        SdkLog.d("start migration sdk from v1 to v2.... ")
        var accessToken : String?
        var refreshToken : String?
        var accessTokenExpiredAt : Date?
        var refreshTokenExpiredAt : Date?
        var scopes : [String]?
        
        if UserDefaults.standard.bool(forKey:"kakao.open.sdk.LastSecureMode") == true {
            let storedAccessToken = UserDefaults.standard.data(forKey:"kakao.open.sdk.AccessToken")
            let storedRefreshToken = UserDefaults.standard.data(forKey:"kakao.open.sdk.RefreshToken")
            
            if let accessTokenData = SdkCrypto.shared.decryptForMigration(data: storedAccessToken) {
                accessToken = String(data: accessTokenData, encoding: .utf8)
            }
            if let refreshTokenData = SdkCrypto.shared.decryptForMigration(data: storedRefreshToken) {
                refreshToken = String(data: refreshTokenData, encoding: .utf8)
            }
        }
        else {
            accessToken = UserDefaults.standard.string(forKey:"kakao.open.sdk.AccessToken")
            refreshToken = UserDefaults.standard.string(forKey:"kakao.open.sdk.RefreshToken")
        }
        
        if accessToken == nil && refreshToken == nil {
            SdkLog.d(" first time sdk v2...")
            markSdkVersion()
            return
        }

        accessTokenExpiredAt = UserDefaults.standard.object(forKey:"kakao.open.sdk.ExpiresAccessTokenTime") as? Date
        refreshTokenExpiredAt = UserDefaults.standard.object(forKey:"kakao.open.sdk.ExpiresRefreshTokenTime") as? Date
        
        scopes = UserDefaults.standard.array(forKey:"kakao.open.sdk.Scopes") as? [String]
        
        let oauthToken = OAuthToken(accessToken: (accessToken != nil) ? accessToken! : "",
                                    expiredAt: accessTokenExpiredAt,
                                    tokenType: "Bearer",
                                    refreshToken: (refreshToken != nil) ? refreshToken! : "",
                                    refreshTokenExpiredAt: refreshTokenExpiredAt,
                                    scope: nil,
                                    scopes: scopes)
        SdkLog.d("\(String(describing: oauthToken))")
        
        KakaoSDKAuth.TokenManager.manager.setToken(oauthToken)
        
        removePrevSdkAuthInfo()
        
        markSdkVersion()
    }
        
    public static func markSdkVersion() {
        Properties.markSdkVersion()
        SdkLog.d("finished migration sdk...")
    }
        
    public static func removePrevSdkAuthInfo() {
        UserDefaults.standard.removeObject(forKey: "kakao.open.sdk.LastSecureMode")
        UserDefaults.standard.removeObject(forKey: "kakao.open.sdk.StorageState")
        UserDefaults.standard.removeObject(forKey: "kakao.open.sdk.AccessToken")
        UserDefaults.standard.removeObject(forKey: "kakao.open.sdk.RefreshToken")
        UserDefaults.standard.removeObject(forKey: "kakao.open.sdk.ExpiresAccessTokenTime")
        UserDefaults.standard.removeObject(forKey: "kakao.open.sdk.ExpiresRefreshTokenTime")
        SdkLog.d("removed sdk v1 auth info.")
    }
}
