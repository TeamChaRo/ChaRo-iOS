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

/// 카카오 SDK 공통의 환경변수 설정을 위한 클래스입니다.
///
/// 싱글톤으로 제공되는 인스턴스를 사용해야 하며 다음과 같이 초기화할 수 있습니다.
///
///     // AppDelegate.swift
///     func application(_ application: UIApplication,
///                      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
///
///         KakaoSDK.initSDK(appKey: "<#Your App Key#>")
///
///         return true
///     }
/// - important: SDK 초기화가 수행되지 않으면 SDK 내 모든 기능을 사용할 수 없습니다. 반드시 가장 먼저 실행되어야 합니다.
final public class KakaoSDK {
    
    // MARK: Fields
    
    //static 라이브러리용 버전.
    private let _version = "2.11.0"
    
    /// 카카오 SDK의 싱글톤 객체입니다. SDK를 사용할 때 반드시 이 객체가 가장 먼저 초기화되어야 합니다.
    public static let shared = KakaoSDK()
    
    private var _appKey : String? = nil
    private var _customScheme : String? = nil
    private var _loggingEnable : Bool = false
    
    private var _hosts : Hosts? = nil
    
    private var _approvalType : ApprovalType? = nil
    
    private var _sdkType : SdkType!
    
    public init() {
        _appKey = nil
        _customScheme = nil
    }
        
    // MARK: Initializers
    
    /// SDK 초기화를 수행합니다.
    /// - parameters:
    ///   - appKey: [카카오 디벨로퍼스](https://developers.kakao.com)에서 발급 받은 NATIVE_APP_KEY
    ///   - loggingEnable: SDK에서 디버그 로깅를 사용 여부
    
    public static func initSDK(appKey: String,
                               customScheme: String? = nil,
                               loggingEnable: Bool = false,
                               hosts: Hosts? = nil,
                               approvalType: ApprovalType? = nil ) {
        KakaoSDK.shared.initialize(appKey: appKey,
                                         customScheme:customScheme,
                                         loggingEnable: loggingEnable,
                                         hosts: hosts,
                                         approvalType: approvalType,
                                         sdkType: .Swift)
    }

    /// :nodoc:
    public func initialize(appKey: String,
                           customScheme: String? = nil,
                           loggingEnable: Bool = false,
                           hosts: Hosts? = nil,
                           approvalType: ApprovalType? = nil,
                           sdkType: SdkType) {
        _appKey = appKey
        _customScheme = customScheme
        _loggingEnable = loggingEnable
        _hosts = hosts
        _approvalType = approvalType
        _sdkType = sdkType
        
        SdkLog.shared.clearLog()        
    }
    
    /// 현재 SDK의 버전을 조회합니다.
    public func sdkVersion() -> String {
        return _version
    }
    
    /// 초기화 시 지정한 loggingEnable
    /// - seealso: `SdkLog`
    public func isLoggingEnable() -> Bool {
        return _loggingEnable
    }
    
    public func hosts() -> Hosts {
        return _hosts != nil ? _hosts! : Hosts.shared
    }
    
    public func approvalType() -> ApprovalType {
        return _approvalType != nil ? _approvalType! : ApprovalType.shared
    }
    
    public func sdkType() -> SdkType {
        return _sdkType != nil ? _sdkType : .Swift
    }
    
    public func scheme() throws -> String {
        guard _appKey != nil else {
            throw SdkError(reason: .MustInitAppKey)
        }
        return _customScheme ?? "kakao\(_appKey!)"
    }
}

extension KakaoSDK {
    /// 설정된 앱키를 가져옵니다.
    /// - throws: `SdkError.ClientFailureReason.MustInitAppKey`: SDK가 초기화되지 않았습니다. 앱키를 가져오기 전에 initSDK를 이용하여 먼저 싱글톤 인스턴스를 초기화해야 합니다.
    public func appKey() throws -> String {
        guard _appKey != nil else {
            throw SdkError(reason: .MustInitAppKey)
        }
        return _appKey!
    }
    
    /// KA Header를 가져옵니다.
    public func kaHeader() -> String {
        return Constants.kaHeader
    }
    
    /// redirectUri를 가져옵니다.
    public func redirectUri() -> String {
        return "\(try! self.scheme())://oauth"
    }
}
