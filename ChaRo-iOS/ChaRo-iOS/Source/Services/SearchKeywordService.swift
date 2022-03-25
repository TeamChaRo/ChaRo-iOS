//
//  SearchKeywordService.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/13.
//

import Foundation
import Alamofire


struct SearchKeywordService {
    
    static let shared = SearchKeywordService()
    let header : HTTPHeaders = ["Content-Type" : "application/json"]
    
    private func makeParameter(userId: String, keywords: [SearchHistory]) -> Parameters {
        let post = SearchKeywordDataModel(userId: userId, searchHistory: keywords)
        return  post.toJSON()
    }
    
    func postSearchKeywords(userId: String,
                            keywords: [SearchHistory],
                            completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let dataRequest = AF.request(Constants.searchKeywordURL,
                                     method: .post,
                                     parameters: makeParameter(userId: userId, keywords: keywords),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        print("검색어 post!!!!!!!")
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
    
    func getSearchKeywords(userId : String,
                           completion: @escaping (NetworkResult<Any>) -> Void) {
       
        let dataRequeat = AF.download(Constants.searchKeywordURL+"/\(userId)",
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      headers: header)
        
        dataRequeat.responseData{ dataResponse in
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
        
        guard let decodeData = try? decoder.decode(SearchResultDataModel.self, from: data) else {
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
