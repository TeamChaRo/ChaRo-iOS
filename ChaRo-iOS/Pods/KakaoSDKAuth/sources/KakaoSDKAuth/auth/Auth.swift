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
import UIKit
import Alamofire
import KakaoSDKCommon

public let AUTH = Auth.shared

public class Auth {
    let sdkVersionKey = "com.kakao.sdk.version"
    static public let retryTokenRefreshCount = 3
    static public let shared = Auth()
    
    public var tokenManager: TokenManagable
    
    public init(tokenManager : TokenManagable = TokenManager.manager) {
        self.tokenManager = tokenManager
        
        initSession()

        if tokenManager is KakaoSDKAuth.TokenManager {
            MigrateManager.checkSdkVersionForMigration()
        }
    }
    
    func initSession() {
        let interceptor = Interceptor(adapter: AuthRequestAdapter(), retrier: AuthRequestRetrier())
        let authApiSessionConfiguration : URLSessionConfiguration = URLSessionConfiguration.default
        authApiSessionConfiguration.tlsMinimumSupportedProtocol = .tlsProtocol12
        API.addSession(type: .AuthApi, session: Session(configuration: authApiSessionConfiguration, interceptor: interceptor))
        
        let rxAuthApiSessionConfiguration : URLSessionConfiguration = URLSessionConfiguration.default
        rxAuthApiSessionConfiguration.tlsMinimumSupportedProtocol = .tlsProtocol12
        API.addSession(type: .RxAuthApi, session: Session(configuration: rxAuthApiSessionConfiguration, interceptor: AuthRequestAdapter()))
        
        SdkLog.d(">>>> \(API.sessions)")
    }
    
    /// ## 커스텀 토큰 관리자
    /// TokenManagable 프로토콜을 구현하여 직접 토큰 관리자를 구현할 수 있습니다.
    public func setTokenManager(_ tokenManager: TokenManagable = TokenManager.manager) {
        self.tokenManager = tokenManager
    }
    
    public func responseData(_ HTTPMethod: Alamofire.HTTPMethod,
                             _ url: String,
                             parameters: [String: Any]? = nil,
                             headers: [String: String]? = nil,
                             apiType: ApiType,
                             logging: Bool = true,
                             completion: @escaping (HTTPURLResponse?, Data?, Error?) -> Void) {
        
        API.responseData(HTTPMethod, url, parameters: parameters, headers: headers, sessionType: .AuthApi, apiType: apiType, logging: logging, completion: completion)
    }
    
    public func upload(_ HTTPMethod: Alamofire.HTTPMethod,
                       _ url: String,
                       images: [UIImage?] = [],
                       headers: [String: String]? = nil,
                       apiType: ApiType,
                       completion: @escaping (HTTPURLResponse?, Data?, Error?) -> Void) {
        API.upload(HTTPMethod, url, images:images, headers: headers, apiType: apiType, completion: completion)
    }
}
