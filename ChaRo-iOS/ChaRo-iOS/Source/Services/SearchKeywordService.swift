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
    let header: HTTPHeaders = ["Content-Type": "application/json"]
    
    private func makeParameter(keywords: [SearchHistory]) -> Parameters {
        let body = SearchKeywordDataModel(userEmail: Constants.userEmail, searchHistory: keywords)
        return  body.toJSON()
    }
    
    func postSearchKeywords(keywords: [SearchHistory], completion: @escaping (NetworkResult<Any>) -> Void) {
        let dataRequest = AF.request(Constants.saveSearchedHistory,
                                     method: .post,
                                     parameters: makeParameter(keywords: keywords),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        dataRequest.responseData{ dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return}
                guard let value = dataResponse.value  else {return}
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
            case .failure(_): completion(.pathErr)
            }
        }
    }
    
    func getSearchKeywords(userId: String,
                           completion: @escaping (NetworkResult<Any>) -> Void) {
       
        let dataRequeat = AF.download(Constants.searchKeywordURL,
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      headers: header)
        
        dataRequeat.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode,
                      let value = dataResponse.value else { return }
                let networkResult = self.judgeStatus(type: [KeywordResult].self, by: statusCode, value)
                completion(networkResult)
            case .failure(_): completion(.pathErr)
            }
        }
    }
    
    private func judgeStatus<T: Codable>(type: T.Type, by statusCode: Int, _ data: Data) ->  NetworkResult<Any> {
        guard let decodeData = try? JSONDecoder().decode(GenericResponse<T>.self, from: data) else {
            return .pathErr
        }
        
        switch statusCode {
        case 200: return .success(decodeData.data)
        case 400: return .requestErr(decodeData)
        case 500: return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        guard let decodeData = try? JSONDecoder().decode(SearchResultDataModel.self, from: data) else {
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
