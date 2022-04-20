//
//  SocialLoginService.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/06.
//

import Foundation
import Alamofire

struct SocialLoginService {
    
    static let shared = SocialLoginService()
    
    private func makeParameter(email : String) -> Parameters
    {
        return ["userEmail" : email]
    }
    
    
    func socialLogin(email : String, completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        let dataRequest = AF.request(Constants.snsLoginURL,
                                     method: .post,
                                     parameters: makeParameter(email: email),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        
        dataRequest.responseData { dataResponse in
            
            switch dataResponse.result {
            
            case .success:
                
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.value else { return }
                
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
                
            case .failure: completion(.pathErr)
                
            }
        }
        
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        
        print(data)
        
        guard let decodedData = try? decoder.decode(LoginDataModel.self, from: data)
        else {
            return .pathErr
        }
        
        print(decodedData)
        print(statusCode)
        
        switch statusCode {
        
        case 200, 401:
            return .success(decodedData.success)
            
        case 400:
            print(decodedData.msg)
            return .requestErr(decodedData.msg)
            
        case 500:
            return .serverErr
            
        default: return .networkFail
        }
    }
}
