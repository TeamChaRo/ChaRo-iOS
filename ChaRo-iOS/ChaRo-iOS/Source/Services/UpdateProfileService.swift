//
//  UpdateProfileService.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2022/03/25.
//

import Foundation
import Alamofire


struct UpdateProfileService {
    static let shared = UpdateProfileService()

    func putNewProfile(nickname: String, newImage: UIImage, completion : @escaping (NetworkResult<Any>) -> Void)
    {

        //TODO: - UserDefault 에 저장된 유저의 email로 변경예정
        let userEmail = "you@gmail.com"
        let originImageURL = ""
        var newImageURL = ""

        let header: HTTPHeaders = ["Content-Type": "multipart/form-data"]

        let parameters: [String: Any] = [
            "userEmail": userEmail,
            "image": newImage,
            "originImage": nickname,
            "newNickname": nickname,
        ]

        var dicParameters: [String: Any] = [:]

        AF.upload(multipartFormData: { multipartFormData in

            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
                dicParameters.updateValue(value, forKey: "\(key)")
            }

            if let imageData = newImage.jpegData(compressionQuality: 1) {
                multipartFormData.append(imageData, withName: "image", fileName: "gg.jpeg", mimeType: "image/jpeg")
                dicParameters.updateValue(imageData, forKey: "image")
            }

        }, to: Constants.updateProfile
                  , usingThreshold: UInt64.init()
                  , method: .put
                  , headers: header).response { dataResponse in

            switch dataResponse.result {
            case .success:
                print("프로필 수정 ----- 데이터 요청 성공")
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


        print(data)

        guard let decodedData = try? decoder.decode(LikeDataModel.self, from: data)
        else {
            return .pathErr
        }

        print(statusCode)

        switch statusCode {
        case 200...299:
            return .success(decodedData.success)
        case 400: return .requestErr(decodedData.msg)
        case 409: return .success(decodedData.success)
        case 500: return .serverErr
        default: return .networkFail
        }

    }

}
