//
//  IsDuplicatedNicknameService.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/06.
//

import Foundation
import Alamofire

struct IsDuplicatedNicknameService {
    static let shared = IsDuplicatedNicknameService()
    
//    private func makeParameter(email : String) -> Parameters
//    {
//        return ["nickname" : email]
//    }
    
    func getNicknameInfo(nickname: String, completion : @escaping (NetworkResult<Any>) -> Void)
    {
        
        let URL = Constants.duplicateNicknameURL
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        let dataRequest = AF.request(URL + nickname,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        print(URL + nickname)
        
        dataRequest.responseData { dataResponse in
            
            
            switch dataResponse.result {
            case .success:
                
                print("----- 데이터 요청 성공")
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
            print("패쓰에러")
            return .pathErr
        }
        
        print("일단 여기까지 왔음")
        switch statusCode {
        case 200:
            print("--- 데이터 받기 성공")
            return .success(decodedData.success)
        case 400: return .requestErr(decodedData.msg)
        case 500: return .serverErr
        default: return .networkFail
        }
        
    }
}
