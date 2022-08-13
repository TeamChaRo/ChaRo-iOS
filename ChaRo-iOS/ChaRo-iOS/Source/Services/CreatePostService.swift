//
//  CreatePostService.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/14.
//

import UIKit
import Alamofire

struct CreatePostService {
    
    static let shared = CreatePostService()
    
    private func makeParameter(
        title: String,
        userEmail: String,
        province: String,
        region: String,
        theme: [String],
        warning: [String],
        isParking: Bool,
        parkingDesc: String,
        courseDesc: String,
        course: [Address]
    ) -> Parameters {
        
        return [
            "title": title,
            "userEmail": userEmail,
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
    
    func createPost(model: WritePostData, image: [UIImage], completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let header: HTTPHeaders = ["Content-Type": "multipart-form"]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(Data(model.title.utf8), withName: "title")
                multipartFormData.append(Data(model.userEmail.utf8), withName: "userEmail")
                multipartFormData.append(Data(model.province.utf8), withName: "province")
                multipartFormData.append(Data(model.region.utf8), withName: "region")

                model.theme.map{ multipartFormData.append(Data($0.utf8), withName: "theme") }

                model.warning.map{ multipartFormData.append(Data(String($0).utf8), withName: "warning") }
                multipartFormData.append(Data(String(model.isParking).utf8), withName: "isParking")
                multipartFormData.append(Data(model.parkingDesc.utf8), withName: "parkingDesc")
                multipartFormData.append(Data(model.courseDesc.utf8), withName: "courseDesc")

                for (index, data) in model.course.enumerated() {
                    multipartFormData.append(Data(data.address.utf8), withName: "course[\(index)][address]")
                    multipartFormData.append(Data(data.latitude.utf8), withName: "course[\(index)][latitude]")
                    multipartFormData.append(Data(data.longitude.utf8), withName: "course[\(index)][longitude]")
                }

                image.map {
                    if let imageData = $0.jpegData(compressionQuality: 1) {
                        multipartFormData.append(imageData, withName: "image", fileName: ".jpeg", mimeType: "image/jpeg")
                    }
                }
            },
            to: Constants.CreatePostURL,
            usingThreshold: UInt64.init(),
            method: .post,
            headers: header
        ).response { dataResponse in
            
            switch dataResponse.result {
            case .success:
                print("[Success] /post/write 작성하기 데이터 요청 성공")
                guard let statusCode = dataResponse.response?.statusCode,
                      let value = dataResponse.value,
                      let data = value
                else { return }

                let networkResult = self.judgeStatus(
                    by: statusCode,
                    data
                )

                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }
    }

    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()

        guard let decodedData = try? decoder.decode(CreatePostDataModel.self, from: data)
        else { return .pathErr }

        switch statusCode {
        case 200...299:
            print("[Success] 작성하기 Post 요청 데이터 받기 성공")
            return .success(decodedData.msg)
        case 400...499:
            return .requestErr(decodedData.msg)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
