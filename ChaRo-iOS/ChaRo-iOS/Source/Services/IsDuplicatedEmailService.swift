//
//  IsDuplicatedEmailService.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import Foundation
import Alamofire


struct IsDuplicatedEmailService {
    static let shared = IsDuplicatedEmailService()
    
    func getEmailInfo(email: String, completion : @escaping (NetworkResult<Any>) -> Void)
    {
        
        let original = Constants.duplicateEmailURL + email
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        guard let target = original.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        guard let url = URL(string: target) else {
            return
        }
                
        let dataRequest = AF.request(url,
                                     method: .get,
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
        
        guard let decodedData = try? decoder.decode(LikeDataModel.self, from: data)
        else {
            return .pathErr
        }
        
        switch statusCode {
        case 200...299:
            return .success(decodedData.success)
        case 400: return .requestErr(decodedData.msg)
        case 409: return .success(decodedData.success)
        case 500: return .serverErr
        default: return .networkFail
        }
        
    }
    
}
