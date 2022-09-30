//
//  UpdatePasswordService.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2022/03/25.
//
import Foundation
import Alamofire


struct UpdatePasswordService {
    static let shared = UpdatePasswordService()

    func putNewPassword(password: String, completion : @escaping (NetworkResult<Any>) -> Void)
    {

        //TODO: - UserDefault 에 저장된 유저의 email로 변경예정
        let userEmail = (UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.userEmail)) ?? ""
        let original = Constants.updatePassword + "userEmail=\(userEmail)&newPassword=\(password)"
        let header : HTTPHeaders = ["Content-Type": "application/json"]

        guard let target = original.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }

        guard let url = URL(string: target) else {
            return
        }

        let dataRequest = AF.request(url,
                                     method: .put,
                                     encoding: JSONEncoding.default,
                                     headers: header)


        dataRequest.responseData { dataResponse in


            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value)
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
