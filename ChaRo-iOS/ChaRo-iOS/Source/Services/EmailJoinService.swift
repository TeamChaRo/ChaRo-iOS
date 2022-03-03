//
//  EmailJoinService.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/09.
//

import Foundation
import Alamofire

struct EmailJoinService {
    
    static let shared = EmailJoinService()
    
    func EmailJoin(userEmail: String,
                   password: String,
                   nickname: String,
                   marketingPush: Bool,
                   marketingEmail: Bool,
                   image: UIImage, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let parameters: [String: Any] = [
            "userEmail": userEmail,
            "nickname": nickname,
            "password": password,
            "emailAgree": marketingEmail,
            "pushAgree": marketingPush,
        ]
        
        var test: [String: Any] = [:]
        
        let header: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
                test.updateValue(value, forKey: "\(key)")
            }
           
            if let imageData = image.jpegData(compressionQuality: 1) {
                multipartFormData.append(imageData, withName: "image", fileName: "gg.jpeg", mimeType: "image/jpeg")
                test.updateValue(imageData, forKey: "profileImage")
            }
            
            print(test)
        
            
        }, to: Constants.JoinURL
        , usingThreshold: UInt64.init()
        , method: .post
        , headers: header).response { dataResponse in
            
            switch dataResponse.result {
            case .success:
                print("----- 데이터 요청 성공")
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value!)
                print(statusCode)
                completion(networkResult)
                
            case .failure: completion(.pathErr)
            }

        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
       
        guard let decodedData = try? decoder.decode(LikeDataModel.self, from: data)
        else {
            return .pathErr
        }

        switch statusCode {
        case 200...299: return .success("회원가입 성공 되엇군 !!!!!!!!")
        case 400...499: return .requestErr("리퀘스트에러")
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    
}
