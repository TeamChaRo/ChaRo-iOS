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

import UIKit
import Foundation
import KakaoSDKCommon
import KakaoSDKAuth

/// 카카오 로그인의 주요 기능을 제공하는 클래스입니다.
///
/// 이 클래스를 이용하여 **카카오톡 간편로그인** 또는 **카카오계정 로그인** 으로 로그인을 수행할 수 있습니다.
///
/// 카카오톡 간편로그인 예제입니다.
///
///     // 로그인 버튼 클릭
///     if (UserApi.isKakaoTalkLoginAvailable()) {
///         UserApi.shared.loginWithKakaoTalk()
///     }
///
///     // AppDelegate
///     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
///         if (AuthController.isKakaoTalkLoginUrl(url)) {
///             if AuthController.handleOpenUrl(url: url, options: options) {
///                 return true
///             }
///         }
///         ...
///     }
///
/// 카카오계정 로그인 예제입니다.
///
///     UserApi.shared.loginWithKakaoAccount()
///

/// 카카오 Open API의 사용자관리 API 호출을 담당하는 클래스입니다.
final public class UserApi {
    
    // MARK: Fields

    /// 간편하게 API를 호출할 수 있도록 제공되는 공용 싱글톤 객체입니다.
    public static let shared = UserApi()

    // MARK: API Methods
    
    // MARK: Login with KakaoTalk
    
    /// 카카오톡 간편로그인이 실행 가능한지 확인합니다.
    ///
    /// 내부적으로 UIApplication.shared.canOpenURL() 메소드를 사용합니다. 카카오톡 간편로그인을 위한 커스텀 스킴은 "kakaokompassauth"이며 이 메소드를 정상적으로 사용하기 위해서는 LSApplicationQueriesSchemes에 해당 스킴이 등록되어야 합니다.
    /// 등록되지 않은 상태로 메소드를 호출하면 카카오톡이 설치되어 있더라도 항상 false를 반환합니다.
    ///
    /// ```xml
    /// // info.plist
    /// <key>LSApplicationQueriesSchemes</key>
    /// <array>
    ///   <string>kakaokompassauth</string>
    /// </array>
    /// ```
    public static func isKakaoTalkLoginAvailable() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string:Urls.compose(.TalkAuth, path:Paths.authTalk))!)
    }
    
    /// 카카오톡 간편로그인을 실행합니다.
    /// - note: UserApi.isKakaoTalkLoginAvailable() 메소드로 실행 가능한 상태인지 확인이 필요합니다. 카카오톡을 실행할 수 없을 경우 loginWithKakaoAccount() 메소드로 웹 로그인을 시도할 수 있습니다.
    /// - parameters:
    ///   - nonce ID 토큰 재생 공격 방지를 위한 검증 값, 임의의 문자열, ID 토큰 검증 시 사용
    public func loginWithKakaoTalk(channelPublicIds: [String]? = nil,
                                   serviceTerms: [String]? = nil,
                                   nonce: String? = nil,
                                   completion: @escaping (OAuthToken?, Error?) -> Void) {
        
        AuthController.shared.authorizeWithTalk(channelPublicIds:channelPublicIds,
                                                serviceTerms:serviceTerms,
                                                completion:completion)
        
    }
    
    /// 앱투앱(App-to-App) 방식 카카오톡 인증 로그인을 실행합니다.
    /// 카카오톡을 실행하고, 카카오톡에 연결된 카카오계정으로 사용자 인증 후 동의 및 전자서명을 거쳐 [CertTokenInfo]을 반환합니다.
    /// - parameters:
    ///   - prompts 동의 화면 요청 시 추가 상호작용을 요청하고자 할 때 전달, 사용할 수 있는 옵션의 종류는 [Prompt] 참고
    ///   - state 전자서명 원문
    ///   - nonce ID 토큰 재생 공격 방지를 위한 검증 값, 임의의 문자열, ID 토큰 검증 시 사용
    public func certLoginWithKakaoTalk(prompts: [Prompt]? = nil,
                                       state: String? = nil,
                                       channelPublicIds: [String]? = nil,
                                       serviceTerms: [String]? = nil,
                                       nonce: String? = nil,
                                       completion: @escaping (CertTokenInfo?, Error?) -> Void) {
        
        AuthController.shared.certAuthorizeWithTalk(prompts:prompts,
                                                    state:state,
                                                    channelPublicIds:channelPublicIds,
                                                    serviceTerms:serviceTerms,
                                                    completion:completion)
        
    }
    

    // MARK: Login with Kakao Account
    
    /// iOS 11 이상에서 제공되는 (SF/ASWeb)AuthenticationSession 을 이용하여 로그인 페이지를 띄우고 쿠키 기반 로그인을 수행합니다. 이미 사파리에에서 로그인하여 카카오계정의 쿠키가 있다면 이를 활용하여 ID/PW 입력 없이 간편하게 로그인할 수 있습니다.
    /// - parameters:
    ///   - prompts 동의 화면 요청 시 추가 상호작용을 요청하고자 할 때 전달. [Prompt]
    ///   - loginHint 카카오계정 로그인 페이지의 ID에 자동 입력할 이메일 또는 전화번호
    ///   - nonce ID 토큰 재생 공격 방지를 위한 검증 값, 임의의 문자열, ID 토큰 검증 시 사용
    
    public func loginWithKakaoAccount(prompts : [Prompt]? = nil,
                                      loginHint: String? = nil,
                                      nonce: String? = nil,
                                      completion: @escaping (OAuthToken?, Error?) -> Void) {
        AuthController.shared.authorizeWithAuthenticationSession(prompts: prompts,
                                                                 loginHint: loginHint,
                                                                 nonce: nonce,
                                                                 completion:completion)
    }

    
    /// 채널 메시지 방식 카카오톡 인증 로그인을 실행합니다.
    /// 기본 브라우저의 카카오계정 쿠키(cookie)로 사용자 인증 후, 카카오계정에 연결된 카카오톡으로 카카오톡 인증 로그인을 요청하는 채널 메시지를 발송합니다.
    /// 카카오톡의 채널 메시지를 통해 동의 및 전자서명을 거쳐 [CertTokenInfo]을 반환합니다.
    /// - parameters:
    ///   - prompts 동의 화면 요청 시 추가 상호작용을 요청하고자 할 때 전달, 사용할 수 있는 옵션의 종류는 [Prompt] 참고
    ///   - state   전자서명 원문
    ///   - loginHint 카카오계정 로그인 페이지의 ID에 자동 입력할 이메일 또는 전화번호
    ///   - nonce ID 토큰 재생 공격 방지를 위한 검증 값, 임의의 문자열, ID 토큰 검증 시 사용
    
    public func certLoginWithKakaoAccount(prompts : [Prompt]? = nil,
                                          state: String? = nil,
                                          loginHint: String? = nil,
                                          nonce: String? = nil,
                                          completion: @escaping (CertTokenInfo?, Error?) -> Void) {
        AuthController.shared.certAuthorizeWithAuthenticationSession(prompts: prompts,
                                                                     state: state,
                                                                     loginHint: loginHint,
                                                                     nonce: nonce,
                                                                     completion:completion)
    }
    
    
    // MARK: New Agreement
    
    /// 사용자로부터 카카오가 보유중인 사용자 정보 제공에 대한 동의를 받습니다.
    ///
    /// 카카오로부터 사용자의 정보를 제공 받거나 카카오서비스 접근권한이 필요한 경우, 사용자로부터 해당 정보 제공에 대한 동의를 받지 않았다면 이 메소드를 사용하여 **추가 항목 동의**를 받아야 합니다.
    /// 필요한 동의항목과 매칭되는 scope id를 배열에 담아 파라미터로 전달해야 합니다. 동의항목과 scope id는 카카오 디벨로퍼스의 [내 애플리케이션] > [제품 설정] > [카카오 로그인] > [동의항목]에서 확인할 수 있습니다.
    ///
    /// ## 사용자 동의 획득 시나리오
    /// 간편로그인 또는 웹 로그인을 수행하면 최초 로그인 시 카카오 디벨로퍼스에 설정된 동의항목 설정에 따라 사용자의 동의를 받습니다. 동의항목을 설정해도 상황에 따라 동의를 받지 못할 수 있습니다. 대표적인 케이스는 아래와 같습니다.
    /// - **선택 동의** 로 설정된 동의항목이 최초 로그인시 선택받지 못한 경우
    /// - **필수 동의** 로 설정하였지만 해당 정보가 로그인 시점에 존재하지 않아 카카오에서 동의항목을 보여주지 못한 경우
    /// - 사용자가 해당 동의항목이 설정되기 이전에 로그인한 경우
    ///
    /// 이외에도 다양한 여건에 따라 동의받지 못한 항목이 발생할 수 있습니다.
    ///
    /// ## 추가 항목 동의 받기 시 주의사항
    /// **선택 동의** 으로 설정된 동의항목에 대한 **추가 항목 동의 받기**는, 반드시 **사용자가 동의를 거부하더라도 서비스 이용이 지장이 없는** 시나리오에서 요청해야 합니다.
    
    public func loginWithKakaoAccount(scopes:[String],
                                      nonce: String? = nil,
                                      completion: @escaping (OAuthToken?, Error?) -> Void) {
        AuthController.shared.authorizeWithAuthenticationSession(scopes:scopes, completion:completion)
    }
    
    /// :nodoc: 카카오싱크 전용입니다. 자세한 내용은 카카오싱크 전용 개발가이드를 참고하시기 바랍니다.
    public func loginWithKakaoAccount(prompts : [Prompt]? = nil,
                                      channelPublicIds: [String]? = nil,
                                      serviceTerms: [String]? = nil,
                                      nonce: String? = nil,
                                      completion: @escaping (OAuthToken?, Error?) -> Void) {
        
        AuthController.shared.authorizeWithAuthenticationSession(prompts: prompts,
                                                                 channelPublicIds: channelPublicIds,
                                                                 serviceTerms: serviceTerms,
                                                                 nonce: nonce,
                                                                 completion: completion)
    }
    
    /// 앱 연결 상태가 **PREREGISTER** 상태의 사용자에 대하여 앱 연결 요청을 합니다. **자동연결** 설정을 비활성화한 앱에서 사용합니다. 요청에 성공하면 회원번호가 반환됩니다.
    public func signup(properties: [String:String]? = nil,
                       completion:@escaping (Int64?, Error?) -> Void) {
        AUTH.responseData(.post,
                          Urls.compose(path:Paths.signup),
                          parameters: ["properties": properties?.toJsonString()].filterNil(),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }

                            if let data = data {
                                if let json = (try? JSONSerialization.jsonObject(with:data, options:[])) as? [String: Any] {
                                    if let id = json["id"] as? Int64 {
                                        completion(id, nil)
                                        return
                                    }
                                }
                            }

                            completion(nil, SdkError())
        }
    }
    
    
    /// 사용자에 대한 다양한 정보를 얻을 수 있습니다.
    /// - seealso: `User`
    public func me(propertyKeys: [String]? = nil,
                   secureResource: Bool = true,
                   completion:@escaping (User?, Error?) -> Void) {
        AUTH.responseData(.get,
                          Urls.compose(path:Paths.userMe),
                          parameters: ["property_keys": propertyKeys?.toJsonString(), "secure_resource": secureResource].filterNil(),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }
                            
                            if let data = data {
                                completion(try? SdkJSONDecoder.customIso8601Date.decode(User.self, from: data), nil)
                                return
                            }
                            
                            completion(nil, SdkError())
        }
    }
    
    /// User 클래스에서 제공되고 있는 사용자의 부가정보를 신규저장 및 수정할 수 있습니다.
    ///
    /// 저장 가능한 키 이름은 개발자 사이트의 [내 애플리케이션]  > [제품 설정] >  [카카오 로그인] > [사용자 프로퍼티] 메뉴에서 확인하실 수 있습니다. 앱 연결 시 기본 저장되는 nickanme, profile_image, thumbnail_image 값도 덮어쓰기 가능하며
    /// 새로운 컬럼을 추가하면 해당 키 이름으로 값을 저장할 수 있습니다.
    /// - seealso: `User.properties`
    public func updateProfile(properties: [String:Any],
                              completion:@escaping (Error?) -> Void) {
        AUTH.responseData(.post,
                          Urls.compose(path:Paths.userUpdateProfile),
                          parameters: ["properties": properties.toJsonString()].filterNil(),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(error)
                                return
                            }
                            
                            completion(nil)
        }
    }
    
    /// 현재 토큰의 기본적인 정보를 조회합니다. me()에서 제공되는 다양한 사용자 정보 없이 가볍게 토큰의 유효성을 체크하는 용도로 사용하는 경우 추천합니다.
    /// - seealso: `AccessTokenInfo`
    public func accessTokenInfo(completion:@escaping (AccessTokenInfo?, Error?) -> Void) {
        AUTH.responseData(.get,
                          Urls.compose(path:Paths.userAccessTokenInfo),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }
                            
                            if let data = data {
                                completion(try? SdkJSONDecoder.custom.decode(AccessTokenInfo.self, from: data), nil)
                                return
                            }
                            
                            completion(nil, SdkError())
        }
    }
    
    /// 토큰을 강제로 만료시킵니다. 같은 사용자가 여러개의 토큰을 발급 받은 경우 로그아웃 요청에 사용된 토큰만 만료됩니다.
    public func logout(completion:@escaping (Error?) -> Void) {
        AUTH.responseData(.post,
                          Urls.compose(path:Paths.userLogout),
                          apiType: .KApi) { (response, data, error) in
                            
                            ///실패여부와 상관없이 토큰삭제.
                            AUTH.tokenManager.deleteToken()
                            
                            if let error = error {
                                completion(error)
                                return
                            }
                            
                            completion(nil)
        }
    }
    
    /// 카카오 플랫폼 서비스와 앱 연결을 해제합니다.
    public func unlink(completion:@escaping (Error?) -> Void) {
        AUTH.responseData(.post,
                          Urls.compose(path:Paths.userUnlink),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(error)
                                return
                            }
                            else {
                                AUTH.tokenManager.deleteToken()
                            }
                            
                            completion(nil)
        }
    }
    
    /// 앱에 가입한 사용자의 배송지 정보를 얻을 수 있습니다.
    /// - seealso: `UserShippingAddresses`
    public func shippingAddresses(fromUpdatedAt: Int? = nil, pageSize: Int? = nil, completion:@escaping (UserShippingAddresses?, Error?) -> Void) {
       AUTH.responseData(.get,
                         Urls.compose(path:Paths.userShippingAddress),
                         parameters: ["from_updated_at": fromUpdatedAt, "page_size": pageSize].filterNil(),
                         apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }
                            
                            if let data = data {
                                completion(try? SdkJSONDecoder.customSecondsSince1970.decode(UserShippingAddresses.self, from: data), nil)
                                return
                            }
                            
                            completion(nil, SdkError())
        }
    }
    
    /// 앱에 가입한 사용자의 배송지 정보를 얻을 수 있습니다.
    /// - seealso: `UserShippingAddresses`
    public func shippingAddresses(addressId: Int64, completion:@escaping (UserShippingAddresses?, Error?) -> Void) {
        AUTH.responseData(.get,
                          Urls.compose(path:Paths.userShippingAddress),
                          parameters: ["address_id": addressId].filterNil(),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }
                            
                            if let data = data {
                                completion(try? SdkJSONDecoder.customSecondsSince1970.decode(UserShippingAddresses.self, from: data), nil)
                                return
                            }
                            
                            completion(nil, SdkError())
        }
    }
    
    /// 사용자가 카카오 간편가입을 통해 동의한 서비스 약관 내역을 반환합니다.
    /// - seealso: `UserServiceTerms`
    public func serviceTerms(extra:String? = nil, completion:@escaping (UserServiceTerms?, Error?) -> Void) {
        AUTH.responseData(.get,
                          Urls.compose(path:Paths.userServiceTerms),
                          parameters: ["extra": extra].filterNil(),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }
                            
                            if let data = data {
                                completion(try? SdkJSONDecoder.customIso8601Date.decode(UserServiceTerms.self, from: data), nil)
                                return
                            }
                            
                            completion(nil, SdkError())
        }
    }
    
    /// 사용자가 동의한 동의 항목의 상세 정보 목록을 조회합니다.
    /// [내 애플리케이션] > [카카오 로그인] > [동의 항목]에 설정된 동의 항목의 목록과 사용자의 동의 여부를 반환합니다.
    /// - parameters:
    ///   - scopes 추가할 동의 항목 ID 목록 (옵셔널)
    public func scopes(scopes:[String]? = nil, completion:@escaping (ScopeInfo?, Error?) -> Void) {
        AUTH.responseData(.get,
                          Urls.compose(path:Paths.userScopes),
                          parameters: ["scopes":scopes?.toJsonString()].filterNil(),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }
                            
                            if let data = data {
                                completion(try? SdkJSONDecoder.custom.decode(ScopeInfo.self, from: data), nil)
                                return
                            }
                            
                            completion(nil, SdkError())
        }
    }
    
    /// 사용자의 특정 동의 항목에 대한 동의를 철회(Revoke)합니다.
    /// 동의 내역 확인하기 API를 통해 조회한 동의 항목 정보 중 동의 철회 가능 여부(revocable) 값이 true인 동의 항목만 철회 가능합니다.
    /// - parameters:
    ///   - scopes 추가할 동의 항목 ID 목록
    public func revokeScopes(scopes:[String], completion:@escaping (ScopeInfo?, Error?) -> Void) {
        AUTH.responseData(.post,
                          Urls.compose(path:Paths.userRevokeScopes),
                          parameters: ["scopes":scopes.toJsonString()].filterNil(),
                          apiType: .KApi) { (response, data, error) in
                            if let error = error {
                                completion(nil, error)
                                return
                            }
                            
                            if let data = data {
                                completion(try? SdkJSONDecoder.custom.decode(ScopeInfo.self, from: data), nil)
                                return
                            }
                            
                            completion(nil, SdkError())
        }
    }
}

