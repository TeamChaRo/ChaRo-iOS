//
//  NotificationService.swift
//  ChaRo-iOS
//
//  Created by hwangJi on 2022/03/22.
//

import Foundation
import Alamofire

struct NotificationService {
    
    static let shared = NotificationService()
    let header : HTTPHeaders = ["Content-Type" : "application/json"]
    
    private func makeParameter(pushId : Int) -> Parameters
    {
        return ["pushId" : pushId]
    }
    
    // MARK: Service
    /// [GET] 전체 알림 리스트 조회
    func getNotificationList(completion: @escaping (NetworkResult<Any>) -> Void) {
        let dataRequest = AF.request(Constants.notificationListURL + Constants.userEmail,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.value else { return }
                let networkResult = self.judgeStatus(type: [NotificationListModel].self, by: statusCode, value)
                completion(networkResult)
            case .failure(_): completion(.pathErr)
            }
        }
    }
    
    /// [POST] 새로 온 알림을 클릭했을 때 읽음 처리
    func postNotificationIsRead(pushId: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let dataRequest = AF.request(Constants.notificationReadURL,
                                     method: .post,
                                     parameters: makeParameter(pushId: pushId),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.value else { return }
                let networkResult = self.judgeStatus(type: String.self, by: statusCode, value)
                completion(networkResult)
            case .failure(_): completion(.pathErr)
            }
        }
    }
    
    // MARK: Judge
    private func judgeStatus<T: Codable>(type: T.Type, by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodeData = try? decoder.decode(GenericResponse<T>.self, from: data) else {
            return .pathErr
        }
        switch statusCode {
        case 200: return .success(decodeData.data ?? "None-Data")
        case 400: return .requestErr(decodeData)
        case 500: return .serverErr
        default:
            return .networkFail
        }
    }
}
