//
//  LikeService.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/13.
//

import Foundation
import Alamofire

struct LikeService {
    static let shared = LikeService()
    
    private func makeParameter(userId : String, postId : Int) -> Parameters
    {
        return ["userId" : userId,
                "postId" : postId ]
    }
    
    func Like(userId : String,
              postId : Int,
              completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        let dataRequest = AF.request(Constants.likeURL,
                                     method: .post,
                                     parameters: makeParameter(userId: userId, postId: postId),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        
        dataRequest.responseData { dataResponse in
            
            switch dataResponse.result {
            case .success:
                
                print("----- 데이터 요청 성공")
                guard let statusCode = dataResponse.response?.statusCode else {return}
                print(dataRequest.response?.statusCode)
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
