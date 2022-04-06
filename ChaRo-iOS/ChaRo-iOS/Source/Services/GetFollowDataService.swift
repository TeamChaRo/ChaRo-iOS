//MARK: made by Jack

import Alamofire
import Foundation

struct GetFollowDataService
{
    
    static let followData = GetFollowDataService()
    func getRecommendInfo(otherId: String, userId: String, completion : @escaping (NetworkResult<Any>) -> Void) {
        // completion 클로저를 @escaping closure로 정의합니다.
        let dataRequest = AF.request(Constants.getFollowURL + userId + "&userEmail=" + otherId,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: ["Content-Type": "application/json"])

        dataRequest.responseData { dataResponse in
            //dump(dataResponse)
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
            case .failure: completion(.pathErr)
                print("실패 사유")
            }
        }
                                            
    }
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200: return isValidData(data: data)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    private func isValidData(data : Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GetFollowDataModel.self, from: data)
        else {return .pathErr}
        return .success(decodedData)

    }
    
}
