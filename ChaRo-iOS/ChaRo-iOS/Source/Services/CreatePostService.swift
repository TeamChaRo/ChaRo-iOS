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
    
    private func makeParameter(title: String, userId: String, province: String, region: String, theme: [String], warning: [Bool], isParking: Bool, parkingDesc: String, courseDesc: String, course: [Address]) -> Parameters {
        
        return ["title": title,
                "userId": userId,
                "province": province,
                "region": region,
                "theme": theme,
                "warning": warning,
                "isParking": isParking,
                "parkingDesc": parkingDesc,
                "courseDesc": courseDesc,
                "course": course
        ]
    }
    
    func createPost(model: WritePostData, image: [UIImage], completion: @escaping (NetworkResult<Any>) -> Void){
        
        let header: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data(model.title.utf8), withName: "title")
            multipartFormData.append(Data(model.userId.utf8), withName: "userId")
            multipartFormData.append(Data(model.province.utf8), withName: "province")
            multipartFormData.append(Data(model.region.utf8), withName: "region")
            model.theme.map{ multipartFormData.append(Data($0.utf8), withName: "theme") }
            model.warning.map{ multipartFormData.append(Data(String($0).utf8), withName: "warning") }
            multipartFormData.append(Data(String(model.isParking).utf8), withName: "isParking")
            multipartFormData.append(Data(model.parkingDesc.utf8), withName: "parkingDesc")
            multipartFormData.append(Data(model.courseDesc.utf8), withName: "courseDesc")
            model.course.map {
                multipartFormData.append(Data($0.address.utf8), withName: "course[address]")
                multipartFormData.append(Data($0.latitude.utf8), withName: "course[latitude]")
                multipartFormData.append(Data($0.longtitude.utf8), withName: "course[longtitude]")
            }
            image.map{
                if let imageData = $0.jpegData(compressionQuality: 1){
                    multipartFormData.append(imageData, withName: "image", fileName: ".jpeg", mimeType: "image/jpeg")
                }
            }

        }, to: Constants.CreatePostURL, usingThreshold:  UInt64.init(), method: .post, headers: header).response { dataResponse in
            
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
