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
    
    private func makeParameter(region: String, theme: String, warning: String ) -> Parameters {
        return  ["region" : region, "theme": theme, "warning" : warning , "userEmail" : Constants.userEmail]
    }
    
    func postSearchKeywords(region: String,
                            theme: String,
                            warning: String,
                            type: String,
                            completion: @escaping (NetworkResult<Any>) -> Void) {
        let parameter = makeParameter(region: region,
                                      theme: theme,
                                      warning: warning)
        let dataRequest = AF.request(Constants.searchPostURL+type,
                                     method: .post,
                                     parameters: makeParameter(region: region,
                                                               theme: theme,
                                                               warning: warning),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData{ dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return}
                guard let value = dataResponse.value  else {return}
                let networkResult = self.judgeStatus(type: Drive.self, by: statusCode, value)
                completion(networkResult)
            case .failure(_): completion(.pathErr)
            }
        }
    }
    
    func getPostDetail(postId : Int,
                        completion: @escaping (NetworkResult<Any>) -> Void) {
        let dataRequeat = AF.download(Constants.detailPostURL+"\(postId)",
                                      method: .get,
                                      encoding: JSONEncoding.default,
                                      headers: header)
        
        dataRequeat.responseData{ dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.value else { return }
                let networkResult = self.judgeStatus(type: PostDetailDataModel.self, by: statusCode, value)
                completion(networkResult)
                
            case .failure(_): completion(.pathErr)
            }
        }
    }
    
    func getPostLikeList(postId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let dateRequest = AF.request(Constants.detailPostLikeListURL + "\(postId)",
                                     method: .get,
                                     parameters: ["userEmail" : Constants.userEmail],
                                     encoding: URLEncoding.queryString)
        dateRequest.responseData{ dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return}
                guard let value = dataResponse.value  else {return}
                let networkResult = self.judgeStatus(type: [Follow].self, by: statusCode, value)
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
}
