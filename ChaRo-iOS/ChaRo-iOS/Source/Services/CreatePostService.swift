//
//  CreatePostService.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/14.
//

import Foundation
import Alamofire

struct CreatePostService {
    
    static let shared = CreatePostService()
    private func makeParameter(title: String, userId: String, theme: [String], warning: [Bool], isParking: Bool, image: [UIImage]) -> Parameters {
        return ["userId": userId,
                "theme": theme,
                "warning": warning,
                "isParking": isParking,
                "image": image
        ]
    }
//    private func makeParameter(title: String, userId: String, province: String, region: String, theme: [String], warning: [Bool], isParking: Bool, parkingDesc: String, courseDesc: String, course: [Address], image: [UIImage]) -> Parameters {
//        return ["title": title,
//                "userId": userId,
//                "province": province,
//                "region": region,
//                "theme": theme,
//                "warning": warning,
//                "isParking": isParking,
//                "parkingDesc": parkingDesc,
//                "courseDesc": courseDesc,
//                "course": course,
//                "image": image
//        ]
//    }
    
//    func createPost(title: String, userId: String, province: String, region: String, theme: [String], warning: [Bool], isParking: Bool, parkingDesc: String, course: [Address], image: [UIImage], completion: @escaping (NetworkResult<Any>) -> Void){
//
//        let header: HTTPHeaders = ["Content-Type": "multipart/form-data"]
//
//
//
//        var num = 0
//        AF.upload(multipartFormData: { multipartFormData in
//            for img in image{
//                if let imageData = img.jpegData(compressionQuality: 1){
//                    multipartFormData.append(imageData,withName: "postImage\(num)",fileName: ".jpeg",mimeType: "image/jpeg")
//                }
//                num += 1
//            }
//        }, to: Constants.CreatePostURL, usingThreshold:  UInt64.init(), method: .post,
//        headers: header).response { response in
//
//
//
//            guard let statusCode = response.response?.statusCode else { return }
//
//            let networkResult = self.judge(by: statusCode)
//            completion(networkResult)
//
//
//        }
//    }
            
    func createPost(userId: String, theme: [String], warning: [Bool], isParking: Bool, image: [UIImage], completion: @escaping (NetworkResult<Any>) -> Void){
        
        let header: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        
        var num = 0
        print("===업로드시작====")
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(userId.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"userId")
            multipartFormData.append(theme.description.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"theme")
            multipartFormData.append(warning.description.data(using: .utf8, allowLossyConversion: false)!, withName :"warning")
            multipartFormData.append(isParking.description.data(using: .utf8, allowLossyConversion: false)!, withName :"isParking")
            for img in image{
                if let imageData = img.jpegData(compressionQuality: 1){
                    multipartFormData.append(imageData,withName: "image",fileName: ".jpeg",mimeType: "image/jpeg")
                }
                num += 1
                print("===이미지전송완료!====")
            }
            
            print("===멀티파트폼 완료====")
            print(multipartFormData)
        }, to: Constants.CreatePostURL, usingThreshold:  UInt64.init(), method: .post, headers: header).response { dataResponse in
            
            print("===Response받는중====")
            print(dataResponse)
            
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
