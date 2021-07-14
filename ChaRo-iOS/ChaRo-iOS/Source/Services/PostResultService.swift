//
//  PostResultService.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/14.
//

import Foundation
import Alamofire

struct PostResultService {
    
    static let shared = PostResultService()
    let header : HTTPHeaders = ["Content-Type" : "application/json"]
    
    
    //userId, region, theme, warning
    private func makeParameter(userId: String, region: String, theme: String, warning: String ) -> Parameters {
        return  [ "userId" : userId, "region" : region, "theme": theme, "warning" : warning ]
    }
    
    func postSearchKeywords(userId: String,
                            region: String,
                            theme: String,
                            warning: String,
                            type: String,
                            completion: @escaping (NetworkResult<Any>) -> Void){
        
        let dataRequest = AF.request(Constants.searchPostURL+type,
                                     method: .post,
                                     parameters: makeParameter(userId: userId,
                                                               region: region,
                                                               theme: theme,
                                                               warning: warning),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData{ dataResponse in
            switch dataResponse.result{
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return}
                guard let value = dataResponse.value  else {return}
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
                
            case .failure(_): completion(.pathErr)
            }
        }
    }
    
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodeData = try? decoder.decode(DetailModel.self, from: data) else {
            return .pathErr
        }
        
        switch statusCode {
        case 200: return .success(decodeData)
        case 400: return .requestErr(decodeData)
        case 500: return .serverErr
        default:
            return .networkFail
        }
    }
}
