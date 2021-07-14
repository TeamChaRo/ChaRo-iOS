//
//  LoginService.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/15.
//

import Foundation
import Alamofire

struct LoginService {
    
    static let shared = LoginService()
        
        private func makeParameter(id : String, password : String) -> Parameters
        {
            return ["id" : id,
                    "password" : password]
        }
        
        func login(id : String,
                   password : String,
                   completion : @escaping (NetworkResult<Any>) -> Void)
        {
            let header : HTTPHeaders = ["Content-Type": "application/json"]
            let dataRequest = AF.request(Constants.loginURL,
                                         method: .post,
                                         parameters: makeParameter(id: id, password: password),
                                         encoding: JSONEncoding.default,
                                         headers: header)
            
            
            dataRequest.responseData { dataResponse in
                                
                switch dataResponse.result {
                case .success:
                    
                    guard let statusCode = dataResponse.response?.statusCode else {return}
                    guard let value = dataResponse.value else {return}
                    let networkResult = self.judgeStatus(by: statusCode, value)
                    completion(networkResult)
                
                case .failure: completion(.pathErr)
                    
                }
            }
                                                
        }
        
        private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
            
            let decoder = JSONDecoder()
            
            guard let decodedData = try? decoder.decode(LoginDataModel.self, from: data)
            else { return .pathErr}
            
            switch statusCode {
                
            case 200: return .success(decodedData.msg)
            case 400: return .requestErr(decodedData.msg)
            case 500: return .serverErr
            default: return .networkFail
            }
        }
}
