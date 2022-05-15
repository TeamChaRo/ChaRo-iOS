//
//  FindPasswordService.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2022/05/11.
//

import Foundation
import Alamofire

struct FindPasswordService {
    static let shared = FindPasswordService()
    
    func sendTempPassword(email: String, completion : @escaping (NetworkResult<Any>) -> Void)
    {
        
        let original = Constants.findPassword + email
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
                
                print("----- 비밀번호 찾기 : 데이터 요청 성공")
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
        
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data)
        else {
            print("비밀번호 찾기 : 패쓰에러")
            return .pathErr
        }
        
        switch statusCode {
        case 200...299:
            return .success(decodedData.data)
        case 400: return .requestErr(decodedData.msg)
        case 500: return .serverErr
        default: return .networkFail
        }
        
    }
}

