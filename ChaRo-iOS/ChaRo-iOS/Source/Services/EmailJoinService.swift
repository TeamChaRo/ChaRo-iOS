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
    
    func EmailJoin(model: JoinDataModel, image: UIImage, completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let parameters: [String: Any] = [
            "userEmail": model.userEmail,
            "nickname": model.nickname,
            "password": model.password,
            "marketingEmail": model.marketingEmail,
            "marketingPush": model.marketingPush,
        ]
        
        let header: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
            }
           
            if let imageData = image.jpegData(compressionQuality: 1) {
                multipartFormData.append(imageData, withName: "profileImage", fileName: ".jpeg", mimeType: "image/jpeg")
            }
            
        }, to: Constants.JoinURL
        , usingThreshold: UInt64.init()
        , method: .post
        , headers: header).response { dataResponse in
            
            switch dataResponse.result {
            case .success:
                
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value!)
                completion(networkResult)
                
            case .failure: completion(.pathErr)
            }

        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(CreatePostDataModel.self, from: data)
        else { return .pathErr}
        
        switch statusCode {
        case 200...299: return .success(decodedData.message)
        case 400...499: return .requestErr(decodedData.message)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    
}
