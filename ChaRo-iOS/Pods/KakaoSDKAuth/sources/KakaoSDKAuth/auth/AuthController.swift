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
import SafariServices
import AuthenticationServices
import KakaoSDKCommon

let AUTH_CONTROLLER = AuthController.shared

/// 인가 코드 요청 시 추가 상호작용을 요청하고자 할 때 전달하는 파라미터입니다.
public enum Prompt : String {
    
    /// 기본 웹 브라우저에 카카오계정 쿠키(cookie)가 이미 있더라도 이를 무시하고 무조건 카카오계정 로그인 화면을 보여주도록 합니다.
    case Login = "login"
    
    /// 보안 로그인을 요청합니다. 보안 로그인은 카카오 인증서 기반의 사용자 전자서명 과정을 포함합니다.
    case Cert = "cert"
    
    ///:nodoc:
    case Signup = "signup"
}

public class AuthController {
    
    // MARK: Fields
    
    /// 간편하게 API를 호출할 수 있도록 제공되는 공용 싱글톤 객체입니다.
    public static let shared = AuthController()
    
    //TODO: parameter 방식으로 바꾸기.
    @available(iOS 13.0, *)
    public lazy var presentationContextProvider: Any? = DefaultPresentationContextProvider()
    
    public var authenticationSession : Any?
    
    public var authorizeWithTalkCompletionHandler : ((URL) -> Void)?

    static public func isValidRedirectUri(_ redirectUri:URL) -> Bool {
        return redirectUri.absoluteString.hasPrefix(KakaoSDK.shared.redirectUri())
    }
    
    //PKCE Spec
    public var codeVerifier : String?
    
    //내부 디폴트브라우져용 time delay
    /// :nodoc:
    public static let delayForAuthenticationSession : Double = 0.4
    
    public init() {
        resetCodeVerifier()
    }
    
    public func resetCodeVerifier() {
        self.codeVerifier = nil
    }
    
    // MARK: Login with KakaoTalk
    /// :nodoc:
    public func authorizeWithTalk(prompts: [Prompt]? = nil,
                                  state: String? = nil,
                                  channelPublicIds: [String]? = nil,
                                  serviceTerms: [String]? = nil,
                                  nonce: String? = nil,
                                  completion: @escaping (OAuthToken?, Error?) -> Void) {
        
        AUTH_CONTROLLER.authorizeWithTalkCompletionHandler = { (callbackUrl) in
            let parseResult = callbackUrl.oauthResult()
            if let code = parseResult.code {
                AuthApi.shared.token(code: code, codeVerifier: self.codeVerifier) { (token, error) in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    else {
                        if let token = token {
                            completion(token, nil)
                            return
                        }
                    }
                }
            }
            else {
                let error = parseResult.error ?? SdkError(reason: .Unknown, message: "Failed to parse redirect URI.")
                SdkLog.e("Failed to parse redirect URI.")
                completion(nil, error)
                return
            }
        }
        
        let parameters = self.makeParametersForTalk(prompts:prompts,
                                                    state:state,
                                                    channelPublicIds: channelPublicIds,
                                                    serviceTerms: serviceTerms,
                                                    nonce:nonce)

        guard let url = SdkUtils.makeUrlWithParameters(Urls.compose(.TalkAuth, path:Paths.authTalk), parameters: parameters) else {
            SdkLog.e("Bad Parameter.")
            completion(nil, SdkError(reason: .BadParameter))
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { (result) in
            if (result) {
                SdkLog.d("카카오톡 실행: \(url.absoluteString)")
            }
            else {
                SdkLog.e("카카오톡 실행 취소")
                completion(nil, SdkError(reason: .Cancelled, message: "The KakaoTalk authentication has been canceled by user."))
                return
            }
        }
    }
    
    /// **카카오톡 간편로그인** 등 외부로부터 리다이렉트 된 코드요청 결과를 처리합니다.
    /// AppDelegate의 openURL 메소드 내에 다음과 같이 구현해야 합니다.
    ///
    /// ```
    /// func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    ///     if (AuthController.isKakaoTalkLoginUrl(url)) {
    ///         if AuthController.handleOpenUrl(url: url, options: options) {
    ///             return true
    ///         }
    ///     }
    ///     // 서비스의 나머지 URL 핸들링 처리
    /// }
    /// ```
    public static func handleOpenUrl(url:URL,  options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthController.isValidRedirectUri(url)) {
            if let authorizeWithTalkCompletionHandler = AUTH_CONTROLLER.authorizeWithTalkCompletionHandler {
                authorizeWithTalkCompletionHandler(url)
            }
        }
        return false
    }
    
    // MARK: Login with Web Cookie

    ///:nodoc: 카카오 계정 페이지에서 로그인을 하기 위한 지원스펙 입니다.
    public func authorizeWithAuthenticationSession(accountParameters: [String:String]? = nil,
                                                   completion: @escaping (OAuthToken?, Error?) -> Void) {
        return self.authorizeWithAuthenticationSession(agtToken: nil,
                                                       scopes: nil,
                                                       channelPublicIds:nil,
                                                       serviceTerms:nil,
                                                       accountParameters: accountParameters,
                                                       completion: completion )
    }    
    
    /// :nodoc: iOS 11 이상에서 제공되는 (SF/ASWeb)AuthenticationSession 을 이용하여 로그인 페이지를 띄우고 쿠키 기반 로그인을 수행합니다. 이미 사파리에에서 로그인하여 카카오계정의 쿠키가 있다면 이를 활용하여 ID/PW 입력 없이 간편하게 로그인할 수 있습니다.
    public func authorizeWithAuthenticationSession(prompts : [Prompt]? = nil,
                                                   state: String? = nil,
                                                   loginHint: String? = nil,
                                                   nonce: String? = nil,
                                                   completion: @escaping (OAuthToken?, Error?) -> Void) {
        return self.authorizeWithAuthenticationSession(prompts: prompts,
                                                       state:state,
                                                       agtToken: nil,
                                                       scopes: nil,
                                                       channelPublicIds: nil,
                                                       serviceTerms:nil,
                                                       loginHint: loginHint,
                                                       nonce:nonce,
                                                       completion: completion )
    }
    
    /// :nodoc: 카카오싱크 전용입니다. 자세한 내용은 카카오싱크 전용 개발가이드를 참고하시기 바랍니다.
    public func authorizeWithAuthenticationSession(prompts : [Prompt]? = nil,
                                                   state: String? = nil,
                                                   channelPublicIds: [String]? = nil,
                                                   serviceTerms: [String]? = nil,
                                                   loginHint: String? = nil,
                                                   nonce: String? = nil,
                                                   completion: @escaping (OAuthToken?, Error?) -> Void) {
        return self.authorizeWithAuthenticationSession(prompts: prompts,
                                                       state:state,
                                                       agtToken: nil,
                                                       scopes: nil,
                                                       channelPublicIds: channelPublicIds,
                                                       serviceTerms:serviceTerms,
                                                       loginHint:loginHint,
                                                       nonce: nonce,
                                                       completion: completion)
    }
    
    /// :nodoc:
    public func authorizeWithAuthenticationSession(scopes:[String],
                                                   nonce: String? = nil,
                                                   completion: @escaping (OAuthToken?, Error?) -> Void) {
        
        AuthApi.shared.agt { [weak self] (agtToken, error) in
            guard let strongSelf = self else {
                completion(nil, SdkError()) //내부에러
                return
            }
            
            if let error = error {
                completion(nil, error)
                return
            }
            else {
                strongSelf.authorizeWithAuthenticationSession(agtToken: agtToken, scopes: scopes, nonce:nonce) { (oauthToken, error) in
                    if let topVC = UIApplication.getMostTopViewController() {
                        let topVCName = "\(type(of: topVC))"
                        SdkLog.d("top vc: \(topVCName)")
                        
                        if topVCName == "SFAuthenticationViewController" {
                            DispatchQueue.main.asyncAfter(deadline: .now() + AuthController.delayForAuthenticationSession) {
                                if let topVC1 = UIApplication.getMostTopViewController() {
                                    let topVCName1 = "\(type(of: topVC1))"
                                    SdkLog.d("top vc: \(topVCName1)")
                                }
                                completion(oauthToken, error)
                            }
                        }
                        else {
                            SdkLog.d("top vc: \(topVCName)")
                            completion(oauthToken, error)
                        }
                    }
                }
            }
        }
    }
    
    /// :nodoc:
    func authorizeWithAuthenticationSession(prompts: [Prompt]? = nil,
                                            state: String? = nil,
                                            agtToken: String? = nil,
                                            scopes:[String]? = nil,
                                            channelPublicIds: [String]? = nil,
                                            serviceTerms: [String]? = nil,
                                            loginHint: String? = nil,
                                            accountParameters: [String:String]? = nil,
                                            nonce: String? = nil,
                                            completion: @escaping (OAuthToken?, Error?) -> Void) {
        
        let authenticationSessionCompletionHandler : (URL?, Error?) -> Void = {
            [weak self] (callbackUrl:URL?, error:Error?) in
            
            guard let callbackUrl = callbackUrl else {
                if #available(iOS 12.0, *), let error = error as? ASWebAuthenticationSessionError {
                    if error.code == ASWebAuthenticationSessionError.canceledLogin {
                        SdkLog.e("The authentication session has been canceled by user.")
                        completion(nil, SdkError(reason: .Cancelled, message: "The authentication session has been canceled by user."))
                        return
                    } else {
                        SdkLog.e("An error occurred on executing authentication session.\n reason: \(error)")
                        completion(nil, SdkError(reason: .Unknown, message: "An error occurred on executing authentication session."))
                        return
                    }
                } else if let error = error as? SFAuthenticationError, error.code == SFAuthenticationError.canceledLogin {
                    SdkLog.e("The authentication session has been canceled by user.")
                    completion(nil, SdkError(reason: .Cancelled, message: "The authentication session has been canceled by user."))
                    return
                } else {
                    SdkLog.e("An unknown authentication session error occurred.")
                    completion(nil, SdkError(reason: .Unknown, message: "An unknown authentication session error occurred."))
                    return
                }
            }
            
            SdkLog.d("callback url: \(callbackUrl)")
            
            let parseResult = callbackUrl.oauthResult()
            if let code = parseResult.code {
                SdkLog.i("code:\n \(String(describing: code))\n\n" )
                
                AuthApi.shared.token(code: code, codeVerifier: self?.codeVerifier) { (token, error) in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    else {
                        if let token = token {
                            completion(token, nil)
                            return
                        }
                    }
                }
            }
            else {
                let error = parseResult.error ?? SdkError(reason: .Unknown, message: "Failed to parse redirect URI.")
                SdkLog.e("redirect URI error: \(error)")
                completion(nil, error)
                return
            }
        }
        
        let parameters = self.makeParameters(prompts: prompts,
                                             state: state,
                                             agtToken: agtToken,
                                             scopes: scopes,
                                             channelPublicIds: channelPublicIds,
                                             serviceTerms: serviceTerms,
                                             loginHint: loginHint,
                                             nonce: nonce)
        
        var url: URL? = SdkUtils.makeUrlWithParameters(Urls.compose(.Kauth, path:Paths.authAuthorize), parameters:parameters)
        
        if let accountParameters = accountParameters, !accountParameters.isEmpty {
            var _parameters = [String:Any]()
            for (key, value) in accountParameters {
                _parameters[key] = value
            }
            _parameters["continue"] = url?.absoluteString
            url = SdkUtils.makeUrlWithParameters(Urls.compose(.Auth, path:Paths.kakaoAccountsLogin), parameters:_parameters)
        }
        
        if let url = url {
            SdkLog.d("\n===================================================================================================")
            SdkLog.d("request: \n url:\(url)\n")
            
            if #available(iOS 12.0, *) {
                let authenticationSession = ASWebAuthenticationSession(url: url,
                                                                       callbackURLScheme: (try! KakaoSDK.shared.scheme()),
                                                                       completionHandler:authenticationSessionCompletionHandler)
                if #available(iOS 13.0, *) {
                    authenticationSession.presentationContextProvider = AUTH_CONTROLLER.presentationContextProvider as? ASWebAuthenticationPresentationContextProviding
                    if agtToken != nil {
                        authenticationSession.prefersEphemeralWebBrowserSession = true
                    }
                }
                AUTH_CONTROLLER.authenticationSession = authenticationSession
                (AUTH_CONTROLLER.authenticationSession as? ASWebAuthenticationSession)?.start()
                
            }
            else {
                AUTH_CONTROLLER.authenticationSession = SFAuthenticationSession(url: url,
                                                                               callbackURLScheme: (try! KakaoSDK.shared.scheme()),
                                                                               completionHandler:authenticationSessionCompletionHandler)
                (AUTH_CONTROLLER.authenticationSession as? SFAuthenticationSession)?.start()
            }
        }
    }
}



extension AuthController {
    //Rx 공통 Helper
    
    /// :nodoc:
    public func makeParametersForTalk(prompts: [Prompt]? = nil,
                                      state: String? = nil,
                                      channelPublicIds: [String]? = nil,
                                      serviceTerms: [String]? = nil,
                                      nonce: String? = nil)  -> [String:Any] {
        self.resetCodeVerifier()
        
        var parameters = [String:Any]()
        parameters["client_id"] = try! KakaoSDK.shared.appKey()
        parameters["redirect_uri"] = KakaoSDK.shared.redirectUri()
        parameters["response_type"] = Constants.responseType
        parameters["headers"] = ["KA": Constants.kaHeader].toJsonString()
        
        var extraParameters = [String: Any]()
        
        if let prompts = prompts {
            let promptsValues : [String]? = prompts.map { $0.rawValue }
            if let prompt = promptsValues?.joined(separator: ",") {
                extraParameters["prompt"] = prompt
            }
        }
        if let state = state {
            extraParameters["state"] = state
        }
        if let channelPublicIds = channelPublicIds?.joined(separator: ",") {
            extraParameters["channel_public_id"] = channelPublicIds
        }
        if let serviceTerms = serviceTerms?.joined(separator: ",")  {
            extraParameters["service_terms"] = serviceTerms
        }
        if let nonce = nonce {
            extraParameters["nonce"] = nonce
        }
        
        if let approvalType = KakaoSDK.shared.approvalType().type {
            extraParameters["approval_type"] = approvalType
        }
        
        self.codeVerifier = SdkCrypto.shared.generateCodeVerifier()
        
        if let codeVerifier = self.codeVerifier {
            SdkLog.d("code_verifier: \(codeVerifier)")
            if let codeChallenge = SdkCrypto.shared.sha256(string:codeVerifier) {
                extraParameters["code_challenge"] = SdkCrypto.shared.base64url(data:codeChallenge)
                SdkLog.d("code_challenge: \(SdkCrypto.shared.base64url(data:codeChallenge))")
                extraParameters["code_challenge_method"] = "S256"
            }
        }
        
        if !extraParameters.isEmpty {
            parameters["params"] = extraParameters.toJsonString()
        }
        
        return parameters
    }
    
    
    public func makeParameters(prompts : [Prompt]? = nil,
                               state: String? = nil,
                               agtToken: String? = nil,
                               scopes:[String]? = nil,
                               channelPublicIds: [String]? = nil,
                               serviceTerms: [String]? = nil,
                               loginHint: String? = nil,
                               nonce: String? = nil) -> [String:Any]
    {
        self.resetCodeVerifier()
        
        var parameters = [String:Any]()
        parameters["client_id"] = try! KakaoSDK.shared.appKey()
        parameters["redirect_uri"] = KakaoSDK.shared.redirectUri()
        parameters["response_type"] = Constants.responseType
        parameters["ka"] = Constants.kaHeader
        
        if let approvalType = KakaoSDK.shared.approvalType().type {
            parameters["approval_type"] = approvalType
        }
        
        if let agt = agtToken {
            parameters["agt"] = agt
            
            if let scopes = scopes {
                parameters["scope"] = scopes.joined(separator:" ")
            }
        }
        
        if let prompts = prompts {
            let promptsValues : [String]? = prompts.map { $0.rawValue }
            if let prompt = promptsValues?.joined(separator: ",") {
                parameters["prompt"] = prompt
            }
        }
        
        if let state = state {
            parameters["state"] = state
        }
        
        if let channelPublicIds = channelPublicIds?.joined(separator: ",") {
            parameters["channel_public_id"] = channelPublicIds
        }
        
        if let serviceTerms = serviceTerms?.joined(separator: ",")  {
            parameters["service_terms"] = serviceTerms
        }
        
        if let loginHint = loginHint {
            parameters["login_hint"] = loginHint
        }
        
        if let nonce = nonce {
            parameters["nonce"] = nonce
        }
        
        self.codeVerifier = SdkCrypto.shared.generateCodeVerifier()
        if let codeVerifier = self.codeVerifier {
            SdkLog.d("code_verifier: \(codeVerifier)")
            if let codeChallenge = SdkCrypto.shared.sha256(string:codeVerifier) {
                parameters["code_challenge"] = SdkCrypto.shared.base64url(data:codeChallenge)
                SdkLog.d("code_challenge: \(SdkCrypto.shared.base64url(data:codeChallenge))")
                parameters["code_challenge_method"] = "S256"
            }
        }
        
        return parameters
    }
}



extension URL {
    // SDK에서 state 제공 계획은 없지만 OAuth 표준이므로 파싱해둔다.
    public func oauthResult() -> (code: String?, error: Error?, state: String?) {
        var parameters = [String: String]()
        if let queryItems = URLComponents(string: self.absoluteString)?.queryItems {
            for item in queryItems {
                parameters[item.name] = item.value
            }
        }
        
        let state = parameters["state"]
        if let code = parameters["code"] {
            return (code, nil, state)
        } else {
            if parameters["error"] == nil {
                parameters["error"] = "unknown"
                parameters["error_description"] = "Invalid authorization redirect URI."
            }
            if parameters["error"] == "cancelled" {
                // 간편로그인 취소버튼 예외처리
                return (nil, SdkError(reason: .Cancelled, message: "The KakaoTalk authentication has been canceled by user."), state)
            } else {
                return (nil, SdkError(parameters: parameters), state)
            }
        }
    }
}

@available(iOS 13.0, *)
class DefaultPresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow ?? ASPresentationAnchor()
    }
}

// MARK: Cert Login
extension AuthController {

    /// :nodoc:
    public func certAuthorizeWithTalk(prompts: [Prompt]? = nil,
                                      state: String? = nil,
                                      channelPublicIds: [String]? = nil,
                                      serviceTerms: [String]? = nil,
                                      nonce: String? = nil,
                                      completion: @escaping (CertTokenInfo?, Error?) -> Void) {
        
        AUTH_CONTROLLER.authorizeWithTalkCompletionHandler = { (callbackUrl) in
            let parseResult = callbackUrl.oauthResult()
            if let code = parseResult.code {
                AuthApi.shared.certToken(code: code, codeVerifier: self.codeVerifier) { (certTokenInfo, error) in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    else {
                        completion(certTokenInfo, nil)
                        return
                    }
                }
            }
            else {
                let error = parseResult.error ?? SdkError(reason: .Unknown, message: "Failed to parse redirect URI.")
                SdkLog.e("Failed to parse redirect URI.")
                completion(nil, error)
                return
            }
        }
        
        var certPrompts: [Prompt] = [.Cert]
        if let prompts = prompts {
            certPrompts = prompts + certPrompts
        }
        
        let parameters = self.makeParametersForTalk(prompts:certPrompts,
                                                    state:state,
                                                    channelPublicIds: channelPublicIds,
                                                    serviceTerms: serviceTerms,
                                                    nonce: nonce)

        guard let url = SdkUtils.makeUrlWithParameters(Urls.compose(.TalkAuth, path:Paths.authTalk), parameters: parameters) else {
            SdkLog.e("Bad Parameter.")
            completion(nil, SdkError(reason: .BadParameter))
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { (result) in
            if (result) {
                SdkLog.d("카카오톡 실행: \(url.absoluteString)")
            }
            else {
                SdkLog.e("카카오톡 실행 취소")
                completion(nil, SdkError(reason: .Cancelled, message: "The KakaoTalk authentication has been canceled by user."))
                return
            }
        }
    }
    
    /// :nodoc:
    public func certAuthorizeWithAuthenticationSession(prompts: [Prompt]? = nil,
                                                       state: String? = nil,
                                                       agtToken: String? = nil,
                                                       scopes:[String]? = nil,
                                                       channelPublicIds: [String]? = nil,
                                                       serviceTerms: [String]? = nil,
                                                       loginHint: String? = nil,
                                                       nonce: String? = nil,
                                                       completion: @escaping (CertTokenInfo?, Error?) -> Void) {
        
        let authenticationSessionCompletionHandler : (URL?, Error?) -> Void = {
            [weak self] (callbackUrl:URL?, error:Error?) in
            
            guard let callbackUrl = callbackUrl else {
                if #available(iOS 12.0, *), let error = error as? ASWebAuthenticationSessionError {
                    if error.code == ASWebAuthenticationSessionError.canceledLogin {
                        SdkLog.e("The authentication session has been canceled by user.")
                        completion(nil, SdkError(reason: .Cancelled, message: "The authentication session has been canceled by user."))
                        return
                    } else {
                        SdkLog.e("An error occurred on executing authentication session.\n reason: \(error)")
                        completion(nil, SdkError(reason: .Unknown, message: "An error occurred on executing authentication session."))
                        return
                    }
                } else if let error = error as? SFAuthenticationError, error.code == SFAuthenticationError.canceledLogin {
                    SdkLog.e("The authentication session has been canceled by user.")
                    completion(nil, SdkError(reason: .Cancelled, message: "The authentication session has been canceled by user."))
                    return
                } else {
                    SdkLog.e("An unknown authentication session error occurred.")
                    completion(nil, SdkError(reason: .Unknown, message: "An unknown authentication session error occurred."))
                    return
                }
            }
            
            SdkLog.d("callback url: \(callbackUrl)")
            
            let parseResult = callbackUrl.oauthResult()
            if let code = parseResult.code {
                SdkLog.i("code:\n \(String(describing: code))\n\n" )
                
                AuthApi.shared.certToken(code: code, codeVerifier: self?.codeVerifier) { (certTokenInfo, error) in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    else {
                        completion(certTokenInfo, nil)
                        return
                    }
                }
            }
            else {
                let error = parseResult.error ?? SdkError(reason: .Unknown, message: "Failed to parse redirect URI.")
                SdkLog.e("redirect URI error: \(error)")
                completion(nil, error)
                return
            }
        }
        
        var certPrompts: [Prompt] = [.Cert]        
        if let prompts = prompts {
            certPrompts = prompts + certPrompts
        }
        
        let parameters = self.makeParameters(prompts: certPrompts,
                                             state: state,
                                             agtToken: agtToken,
                                             scopes: scopes,
                                             channelPublicIds: channelPublicIds,
                                             serviceTerms: serviceTerms,
                                             loginHint: loginHint,
                                             nonce: nonce)
        
        if let url = SdkUtils.makeUrlWithParameters(Urls.compose(.Kauth, path:Paths.authAuthorize), parameters:parameters) {
            SdkLog.d("\n===================================================================================================")
            SdkLog.d("request: \n url:\(url)\n parameters: \(parameters) \n")
            
            if #available(iOS 12.0, *) {
                let authenticationSession = ASWebAuthenticationSession(url: url,
                                                                       callbackURLScheme: (try! KakaoSDK.shared.scheme()),
                                                                       completionHandler:authenticationSessionCompletionHandler)
                if #available(iOS 13.0, *) {
                    authenticationSession.presentationContextProvider = AUTH_CONTROLLER.presentationContextProvider as? ASWebAuthenticationPresentationContextProviding
                    if agtToken != nil {
                        authenticationSession.prefersEphemeralWebBrowserSession = true
                    }
                }
                AUTH_CONTROLLER.authenticationSession = authenticationSession
                (AUTH_CONTROLLER.authenticationSession as? ASWebAuthenticationSession)?.start()
                
            }
            else {
                AUTH_CONTROLLER.authenticationSession = SFAuthenticationSession(url: url,
                                                                               callbackURLScheme: (try! KakaoSDK.shared.scheme()),
                                                                               completionHandler:authenticationSessionCompletionHandler)
                (AUTH_CONTROLLER.authenticationSession as? SFAuthenticationSession)?.start()
            }
        }
    }
}

extension AuthApi {    
    /// :nodoc:
    public func certToken(code: String,
                          codeVerifier: String? = nil,
                          redirectUri: String = KakaoSDK.shared.redirectUri(),
                          completion:@escaping (CertTokenInfo?, Error?) -> Void) {
                API.responseData(.post,
                                Urls.compose(.Kauth, path:Paths.authToken),
                                parameters: ["grant_type":"authorization_code",
                                             "client_id":try! KakaoSDK.shared.appKey(),
                                             "redirect_uri":redirectUri,
                                             "code":code,
                                             "code_verifier":codeVerifier,
                                             "ios_bundle_id":Bundle.main.bundleIdentifier,
                                             "approval_type":KakaoSDK.shared.approvalType().type].filterNil(),
                                sessionType:.Auth,
                                apiType: .KAuth) { (response, data, error) in
                                    if let error = error {
                                        completion(nil, error)
                                        return
                                    }
                                    
                                    if let data = data {
                                        if let certOauthToken = try? SdkJSONDecoder.custom.decode(CertOAuthToken.self, from: data) {                                            
                                            let oauthToken = OAuthToken(accessToken: certOauthToken.accessToken,
                                                                        expiresIn: certOauthToken.expiresIn,
                                                                        expiredAt: certOauthToken.expiredAt,
                                                                        tokenType: certOauthToken.tokenType,
                                                                        refreshToken: certOauthToken.refreshToken,
                                                                        refreshTokenExpiresIn: certOauthToken.refreshTokenExpiresIn,
                                                                        refreshTokenExpiredAt: certOauthToken.refreshTokenExpiredAt,
                                                                        scope: certOauthToken.scope,
                                                                        scopes: certOauthToken.scopes,
                                                                        idToken: certOauthToken.idToken)
                                            
                                            if let txId = certOauthToken.txId {
                                                AUTH.tokenManager.setToken(oauthToken)
                                                
                                                let certTokenInfo = CertTokenInfo(token: oauthToken, txId: txId)
                                                completion(certTokenInfo, nil)
                                            }
                                            else {
                                                completion(nil, SdkError(reason: .Unknown, message: "certToken - txId is nil."))
                                            }
                                            return
                                        }
                                        else {
                                            completion(nil, SdkError(reason: .Unknown, message: "certToken - token parsing error."))
                                            return
                                        }
                                    }
                    
                                    completion(nil, SdkError(reason: .Unknown, message: "certToken - data is nil."))
                                }
    }
}
