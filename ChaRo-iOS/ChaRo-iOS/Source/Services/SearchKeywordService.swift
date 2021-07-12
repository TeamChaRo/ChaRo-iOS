//
//  SearchKeywordService.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/13.
//

import Foundation
import Alamofire
import SwiftyJSON


struct SearchKeywordService {
    
    static let shared = SearchKeywordService()
    
    private func makeParameter(userId: String, keywords: [SearchHistory]) -> Parameters {
        let encoder = JSONEncoder()
        
        let jsonData = try! encoder.encode(keywords)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        return ["userId" : userId,
                "searchHistory": jsonString]
    }
    
    func postSearchKeywords(userId: String,
                                    keywords: [SearchHistory],
                                    completion: @escaping (NetworkResult<Any>) -> Void){
        
        let param = makeParameter(userId: userId, keywords: keywords)
        print(param)
        print("----------------------")
        let header : HTTPHeaders = ["Content-Type" : "application/json"]
        let dataRequest = AF.request(Constants.searchKeywordURL,
                                     method: .post,
                                     parameters: makeParameter(userId: userId, keywords: keywords),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        print("request 성공")
        
        dataRequest.responseData{ dataResponse in
            print("데이터 받기")
            dump(dataResponse)
            
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
        
        guard let decodeData = try? decoder.decode(SearchPostResultDataModel.self, from: data) else {
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
