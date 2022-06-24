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

/// SDK에서 기본 제공하는 토큰 관리자입니다.
///
/// 카카오 SDK에서 제공하는 로그인 기반 API를 호출할 때 SDK 내부적으로 이 곳에 저장된 토큰을 사용합니다. 토큰은 UserDefaults에 저장되며 기기 고유값을 이용해 암호화하여 저장됩니다.
///
/// - seealso: `TokenManagable`
final public class TokenManager : TokenManagable {
    
    // MARK: Fields
    
    /// 간편한 사용을 위한 싱글톤 객체입니다.
    static public let manager = TokenManager()
    
    let OAuthTokenKey = "com.kakao.sdk.oauth_token"
    
    var token : OAuthToken?
    
    /// :nodoc: 토큰 관리자를 초기화합니다. UserDefaults에 저장되어 있는 토큰을 읽어옵니다.
    public init() {
        self.token = Properties.loadCodable(key:OAuthTokenKey)
    }
    
    
    // MARK: TokenManagable Methods
    
    /// UserDefaults에 토큰을 저장합니다.
    public func setToken(_ token: OAuthToken?) {
        Properties.saveCodable(key:OAuthTokenKey, data:token)
        self.token = token
    }
    
    /// 현재 토큰을 가져옵니다.
    public func getToken() -> OAuthToken? {
        return self.token
    }
    
    /// UserDefaults에 저장된 토큰을 삭제합니다.
    public func deleteToken() {
        Properties.delete(OAuthTokenKey)
        self.token = nil
    }
}
