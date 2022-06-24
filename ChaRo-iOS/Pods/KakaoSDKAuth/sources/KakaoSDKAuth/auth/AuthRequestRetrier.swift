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
import Alamofire
import KakaoSDKCommon

public class AuthRequestRetrier : RequestInterceptor {
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    private var isRefreshing = false
    
    private var errorLock = NSLock()

    public init() {
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        errorLock.lock() ; defer { errorLock.unlock() }
        
        var logString = "request retrier:"        

        if let sdkError = API.getSdkError(error: error) {
            if !sdkError.isApiFailed {
                SdkLog.e("\(logString)\n error:\(error)\n not api error -> pass through\n\n")
                completion(.doNotRetryWithError(SdkError(message:"not api error -> pass through")))
                return
            }

            switch(sdkError.getApiError().reason) {
            case .InvalidAccessToken:
                logString = "\(logString)\n reason:\(error)\n token: \(String(describing: AUTH.tokenManager.getToken()))"
                SdkLog.e("\(logString)\n\n")

                if shouldRefreshToken(request) {
                    //SdkLog.d("---------------------------- enqueue completion\n request: \(request) \n\n")
                    requestsToRetry.append(completion)

                    if !isRefreshing {
                        isRefreshing = true
                            
                        //SdkLog.d("<<<<<<<<<<<<<< start token refresh\n request: \(String(describing:request))\n\n")
                        AuthApi.shared.refreshToken { [unowned self] (token, error) in
                            
                            if let error = error {
                                //token refresh failure.
                                SdkLog.e(" refreshToken error: \(error). retry aborted.\n request: \(request) \n\n")
                                
                                //pending requests all cancel
                                self.requestsToRetry.forEach {
                                    $0(.doNotRetryWithError(error))
                                }                              }
                            else {
                                //token refresh success.
                                //SdkLog.d(">>>>>>>>>>>>>> refreshToken success\n request: \(request) \n\n")
                                
                                //proceed all pending requests.
                                self.requestsToRetry.forEach {
                                    $0(.retry)
                                }
                            }
                            
                            self.requestsToRetry.removeAll() //reset all stored completion
                            self.isRefreshing = false
                        }
                    }
                }
                else {                    
                    let sdkError = SdkError(reason: .TokenNotFound)
                    SdkLog.e(" should not refresh: \(sdkError)  -> pass through \n")
                    completion(.doNotRetryWithError(sdkError))
                }
            case .InsufficientScope:
                logString = "\(logString)\n reason:\(error)\n token: \(String(describing: AUTH.tokenManager.getToken()))"
                SdkLog.e("\(logString)\n\n")
                
                if let requiredScopes = sdkError.getApiError().info?.requiredScopes {
                    DispatchQueue.main.async {
                        AuthController.shared.authorizeWithAuthenticationSession(scopes: requiredScopes) { (_, error) in
                            if let error = error {
                                completion(.doNotRetryWithError(error))
                            }
                            else {
                                completion(.retry)
                            }
                        }
                    }
                }
                else {
                    SdkLog.e("\(logString)\n reason:\(sdkError)\n requiredScopes not exist -> pass through \n\n")
                    completion(.doNotRetryWithError(SdkError(apiFailedMessage:"requiredScopes not exist")))
                }
            case .RequiredAgeVerification:
                SdkLog.e("\(logString)\n reason:\(sdkError)\n not handled error -> pass through partnerAuthRetrier \n\n")
                completion(.doNotRetry)
            default:
                SdkLog.e("\(logString)\n reason:\(sdkError)\n not handled error -> pass through \n\n")
                completion(.doNotRetryWithError(sdkError))
            }
        }
        else {
            SdkLog.e("\(logString)\n not handled error -> pass through \n\n")
            completion(.doNotRetry)
        }
    }
    
    private func shouldRefreshToken(_ request: Request) -> Bool  {
        guard AUTH.tokenManager.getToken()?.refreshToken != nil else {
            SdkLog.e(" refresh token not exist. retry aborted.\n\n")
            return false
        }

        return true
    }
}
