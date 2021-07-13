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
    
    private func makeParameter(userId : String, postId : String) -> Parameters
        {
            return ["userId" : userId,
                    "postId" : postId]
        }
        
        func login(userId : String,
                   postId : String,
                   completion : @escaping (NetworkResult<Any>) -> Void)
        {
            let header : HTTPHeaders = ["Content-Type": "application/json"]
            let dataRequest = AF.request(Constants.likeURL,
                                         method: .post,
                                         parameters: makeParameter(userId: userId, postId: postId),
                                         encoding: JSONEncoding.default,
                                         headers: header)
            
            
            dataRequest.responseData { dataResponse in
                
                dump(dataResponse)
                
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
            else { return .pathErr}
            
            switch statusCode {
                
            case 200: return .success(decodedData.msg)
            case 400: return .requestErr(decodedData.msg)
            case 500: return .serverErr
            default: return .networkFail
            }
        }
        
    
}
