import Foundation
import Alamofire

struct DoFollowService {
    
    static let shared = DoFollowService()
    let header : HTTPHeaders = ["Content-Type" : "application/json"]
    
    
    private func makeParameter(follower: String, followed: String) -> Parameters {
        return  [ "follower" : follower, "followed" : followed]
    }
    
    func followService(follower: String,
                            followed: String,
                            completion: @escaping (NetworkResult<Any>) -> Void){
        
        let dataRequest = AF.request(Constants.followURL,
                                     method: .post,
                                     parameters: makeParameter(follower: follower,
                                                               followed: followed),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData{ dataResponse in
//            dump(dataRequest)
            switch dataResponse.result{
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return}
                guard let value = dataResponse.value  else {return}
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
                
            case .failure(_): completion(.pathErr)
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
        guard let decodedData = try? decoder.decode(DoFollowDataModel.self, from: data)
        else {return .pathErr}
        print("팔로우상태: ",decodedData.data.isFollow)
        // 우선 PersonDataModel 형태로 decode(해독)을 한번 거칩니다. 실패하면 pathErr
        // 해독에 성공하면 Person data를 success에 넣어줍니다.
        
        
        return .success(decodedData)

    }
    
}
