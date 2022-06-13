//
//  DeleteAccountService.swift
//  ChaRo-iOS
//
//  Created by hwangJi on 2022/04/26.
//

import Foundation
import Alamofire

struct DeleteAccountService {
    
    static let shared = DeleteAccountService()
    let header : HTTPHeaders = ["Content-Type" : "application/json"]
    
    // MARK: Service
    /// [DELETE] 회원 탈퇴
    func deleteAccount(completion: @escaping (NetworkResult<Any>) -> Void) {
        let dataRequest = AF.request(Constants.deleteAccountURL,
                                     method: .delete,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.value else { return }
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
            case .failure(_): completion(.pathErr)
            }
        }
    }
    
    // MARK: Judge
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodeData = try? decoder.decode(GenericResponse<String>.self, from: data) else {
            return .pathErr
        }
        switch statusCode {
        case 200: return .success(true)
        case 400: return .requestErr(decodeData)
        case 500: return .serverErr
        default:
            return .networkFail
        }
    }
}
