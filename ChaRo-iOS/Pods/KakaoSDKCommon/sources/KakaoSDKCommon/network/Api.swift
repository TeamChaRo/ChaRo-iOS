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

public let API = Api.shared

public enum SessionType {
    case Auth       //KA
    case Api        //KA
    case AuthApi    //Token (withRetrier)
    case RxAuthApi  //Token
    case PartnerAuthApi
}

//public enum ApiType {
//    case KApi
//    case KAuth
//}

public class Api {
    public static let shared = Api()
    
    public let encoding : URLEncoding
    
    public var sessions : [SessionType:Session] = [SessionType:Session]()
    
    public init() {
        self.encoding = URLEncoding(boolEncoding: .literal)
        initSession()
    }
}

extension Api {    
    private func initSession() {
        let apiSessionConfiguration : URLSessionConfiguration = URLSessionConfiguration.default
        apiSessionConfiguration.tlsMinimumSupportedProtocol = .tlsProtocol12
        addSession(type: .Api, session:Session(configuration: apiSessionConfiguration, interceptor: ApiRequestAdapter()))
        
        let authSessionConfiguration : URLSessionConfiguration = URLSessionConfiguration.default
        authSessionConfiguration.tlsMinimumSupportedProtocol = .tlsProtocol12
        addSession(type: .Auth, session:Session(configuration: authSessionConfiguration, interceptor: ApiRequestAdapter()))
    }
    
    public func addSession(type:SessionType, session:Session) {
        if self.sessions[type] == nil {
            self.sessions[type] = session
        }
        
//        SdkLog.d("<<<<<<< sessions: \(self.sessions)   count: \(self.sessions.count)")
    }
    
    public func session(_ sessionType: SessionType) -> Session {
        return sessions[sessionType] ?? sessions[.Api]!
    }
}

extension Api {
    public func getSdkError(error: Error) -> SdkError? {
        if let aferror = error as? AFError {
            switch aferror {
            case .responseValidationFailed(let reason):
                switch reason {
                case .customValidationFailed(let error):
                    return error as? SdkError
                default:
                    break
                }
            default:
                break
            }
        }
        return nil
    }
    
    public func getRequestRetryFailedError(error:Error) -> SdkError? {
        if let aferror = error as? AFError {
            switch aferror {
            case .requestRetryFailed(let retryError, _):
                return retryError as? SdkError
            default:
                break
            }
        }
        return nil
    }
    
    public func responseData(_ HTTPMethod: Alamofire.HTTPMethod,
                      _ url: String,
                      parameters: [String: Any]? = nil,
                      headers: [String: String]? = nil,
                      sessionType: SessionType = .AuthApi,
                      apiType: ApiType,
                      logging: Bool = true,
                      completion: @escaping (HTTPURLResponse?, Data?, Error?) -> Void) {
        
        API.session(sessionType)
            .request(url, method:HTTPMethod, parameters:parameters, encoding:API.encoding, headers:(headers != nil ? HTTPHeaders(headers!):nil) )
            .validate({ (request, response, data) -> Request.ValidationResult in
                if let data = data {
                    
                    var json : Any? = nil
                    do {
                        json = try JSONSerialization.jsonObject(with:data, options:[])
                    } catch {
                        SdkLog.e(error)
                    }
                    
                    SdkLog.d("===================================================================================================")
                    SdkLog.d("session: \n type: \(sessionType)\n\n")
                    SdkLog.i("request: \n method: \(HTTPMethod)\n url:\(url)\n headers:\(String(describing: headers))\n parameters: \(String(describing: parameters)) \n\n")
                    (logging) ? SdkLog.i("response:\n \(String(describing: json))\n\n" ) : SdkLog.i("response: - \n\n")
                    
                    if let sdkError = SdkError(response: response, data: data, type: apiType) {
                        return .failure(sdkError)
                    }
                    else {
                        return .success(Void())
                    }
                }
                else {
                    return .failure(SdkError(reason: .Unknown, message: "data is nil."))
                }
            })
            .responseData { [unowned self] response in
                if let afError = response.error, let retryError = self.getRequestRetryFailedError(error:afError) {
                    SdkLog.e("response:\n api error: \(retryError)")
                    completion(nil, nil, retryError)
                }
                else if let afError = response.error, self.getSdkError(error:afError) == nil {
                    //일반에러
                    SdkLog.e("response:\n not api error: \(afError)")
                    completion(nil, nil, afError)                    
                }
                else if let data = response.data, let response = response.response {
                    if let sdkError = SdkError(response: response, data: data, type: apiType) {
                        completion(nil, nil, sdkError)
                        return
                    }
                    
                    completion(response, data, nil)
                }
                else {
                    //data or response 가 문제
                    SdkLog.e("response:\n error: response or data is nil.")
                    completion(nil, nil, SdkError(reason: .Unknown, message: "response or data is nil."))
                }
            }
    }
    
    public func upload(_ HTTPMethod: Alamofire.HTTPMethod,
                       _ url: String,
                       images: [UIImage?] = [],
                       parameters: [String: Any]? = nil,                    //현재 authapi인 story만 쓰고 있고 나중을 위해 열어둠
                       headers: [String: String]? = nil,                    //현재 authapi인 story만 쓰고 있고 나중을 위해 열어둠
                       needsAccessToken: Bool = true,                       //현재 authapi인 story만 쓰고 있고 나중을 위해 열어둠
                       needsKAHeader: Bool = false,                         //현재 authapi인 story만 쓰고 있고 나중을 위해 열어둠
                       sessionType: SessionType = .AuthApi,   //현재 authapi인 story만 쓰고 있고 나중을 위해 열어둠
                       apiType: ApiType,
                       completion: @escaping (HTTPURLResponse?, Data?, Error?) -> Void) {

        API.session(sessionType)
            .upload(multipartFormData: { (formData) in
                images.forEach({ (image) in
                    if let imageData = image?.pngData() {
                        formData.append(imageData, withName: "file", fileName:"image.png",  mimeType: "image/png")
                    }
                    else if let imageData = image?.jpegData(compressionQuality: 1) {
                        formData.append(imageData, withName: "file", fileName:"image.jpg",  mimeType: "image/jpeg")
                    }
                    else {
                    }
                })
                parameters?.forEach({ (arg) in
                    guard let data = String(describing: arg.value).data(using: .utf8) else {
                        return
                    }
                    formData.append(data, withName: arg.key)
                })                
            }, to: url, method: HTTPMethod, headers: (headers != nil ? HTTPHeaders(headers!):nil))
            .uploadProgress(queue: .main, closure: { (progress) in
                SdkLog.i("upload progress: \(String(format:"%.2f", 100.0 * progress.fractionCompleted))%")
            })
            .validate { (request, response, data) -> DataRequest.ValidationResult in
                if let data = data {
                    var json : Any? = nil
                    do {
                        json = try JSONSerialization.jsonObject(with:data, options:[])
                    } catch {
                        SdkLog.e("response:\n error: \(error)") //json parsing error
                        return .failure(error)
                    }
                    
                    SdkLog.d("===================================================================================================")
                    SdkLog.i("request:\n method: \(HTTPMethod)\n url:\(url)\n headers:\(String(describing: headers))\n images:\(String(describing: images))\n parameters:\(String(describing: parameters))\n")
                    SdkLog.i("response:\n \(String(describing: json))\n\n" )
                    
                    if let sdkError = SdkError(response: response, data: data, type: apiType) {
                        return .failure(sdkError)
                    }
                    else {
                        return .success(Void())
                    }
                }
                else {
                    return .failure(SdkError())
                }
            }
            .responseData { (response) in
                if let afError = response.error, let retryError = self.getRequestRetryFailedError(error:afError) {
                    SdkLog.e("response:\n api error: \(retryError)")
                    completion(nil, nil, retryError)
                }
                else if let afError = response.error, self.getSdkError(error:afError) == nil {
                    //일반에러
                    SdkLog.e("response:\n not api error: \(afError)")
                    completion(nil, nil, afError)
                }
                else if let data = response.data, let response = response.response {
                    if let sdkError = SdkError(response: response, data: data, type: apiType) {
                        completion(nil, nil, sdkError)
                        return
                    }
                    
                    completion(response, data, nil)
                }
                else {
                    //data or response 가 문제
                    SdkLog.e("response:\n error: response or data is nil.")
                    completion(nil, nil, SdkError(reason: .Unknown, message: "response or data is nil."))
                    return
                }
            }
    }
}
