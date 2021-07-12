//
//  GetThemeDataService.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/12.
//

import Foundation
import Alamofire


struct GetThemeDataService {
    
    static let shared = GetThemeDataService()
    
    func getThemeInfo(theme: String, completion : @escaping (NetworkResult<Any>) -> Void)
        {
        
            let URL = "http://3.139.62.132:5000/preview/like/111/1?value=\(theme)"
            let header : HTTPHeaders = ["Content-Type": "application/json"]
            
            let dataRequest = AF.request(URL,
                                         method: .get,
                                         encoding: JSONEncoding.default,
                                         headers: header)
            
            
            dataRequest.responseData { dataResponse in
                
                
                switch dataResponse.result {
                
                case .success:
                    
                    guard let statusCode = dataResponse.response?.statusCode else {return}
                    guard let value = dataResponse.value else {return}
                    print("success ----")
                    let networkResult = self.judgeStatus(by: statusCode, value)
                    completion(networkResult)
                
                case .failure: completion(.pathErr)
                    
                }
            }
                                                
        }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
              
        let decoder = JSONDecoder()
        print("judge---")
        guard let decodedData = try? decoder.decode(ThemeDataModel.self, from: data)
        else { return .pathErr}
            switch statusCode {
            
            case 200:
                print("judge success ---")
                return .success(decodedData.data)
            case 400: return .pathErr
            case 500: return .serverErr
            default: return .networkFail
            }
        }
    
//    private func isValidData(data : Data) -> NetworkResult<Any> {
//
////            let decoder = JSONDecoder()
////
////            guard let decodedData = try? decoder.decode(ThemeDataModel.self, from: data)
////            else { return .pathErr}
//            // 우선 PersonDataModel 형태로 decode(해독)을 한번 거칩니다. 실패하면 pathErr
//
//            // 해독에 성공하면 Person data를 success에 넣어줍니다.
//
//
//        }
        
        
}
