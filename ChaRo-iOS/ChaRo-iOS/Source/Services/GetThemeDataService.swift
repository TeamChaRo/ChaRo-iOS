//
//  GetThemeDataService.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/12.
//

import Foundation
import Alamofire

enum Filter {
    case like
    case new
}

struct GetThemeDataService {
    
    static let shared = GetThemeDataService()
    
    func getThemeInfo(theme: String, filter: Filter, completion: @escaping (NetworkResult<Any>) -> Void)
        {
        
        var URL = ""
        
        switch filter {
        
        case Filter.like:
            URL = Constants.ThemeLikeURL + "\(theme)"
            
            break
        case Filter.new:
            URL = Constants.ThemeNewURL + "\(theme)"
            break
        }
        
            let header: HTTPHeaders = ["Content-Type": "application/json"]
            
            let dataRequest = AF.request(URL,
                                         method: .get,
                                         encoding: JSONEncoding.default,
                                         headers: header)
            
            
            dataRequest.responseData { dataResponse in
                
                
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
        guard let decodedData = try? decoder.decode(ThemeDataModel.self, from: data)
        else { return .pathErr}
            switch statusCode {
            
            case 200:
                return .success(decodedData.data)
            case 400: return .pathErr
            case 500: return .serverErr
            default: return .networkFail
            }
        }

        
}
