//
//  SocialJoinService.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/18.
//

import Foundation
import Alamofire

struct SocialJoinService {
    static let shared = SocialJoinService()

    private func makeAppleParameter(email : String, pushAgree : Bool, emailAgree: Bool) -> Parameters
    {
        return ["userEmail" : email,
                "pushAgree": pushAgree,
                "emailAgree": emailAgree]
    }
    
    private func makeGoogleParameter(email : String, profileImage: String, pushAgree: Bool, emailAgree: Bool) -> Parameters
    {
        return ["userEmail" : email,
                "profileImage": profileImage,
                "pushAgree": pushAgree,
                "emailAgree": emailAgree]
    }
    
    private func makeKakaoParameter(email : String, profileImage: String, pushAgree: Bool, emailAgree: Bool, nickname: String) -> Parameters
    {
        return [ "userEmail": email,
                 "profileImage": profileImage,
                 "nickname": nickname,
                 "pushAgree": pushAgree,
                 "emailAgree": emailAgree]
    }
    
    func appleJoin(email: String,
                   pushAgree: Bool,
                   emailAgree: Bool,
                   completion : @escaping (NetworkResult<Any>) -> Void) {
        
        
        let URL = Constants.appleLoginURL
        let header : HTTPHeaders = ["Content-Type": "application/json"]

        
        let dataRequest = AF.request(URL,
                                     method: .post,
                                     parameters: makeAppleParameter(email: email,
                                                                    pushAgree: pushAgree,
                                                                    emailAgree: emailAgree),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        
        dataRequest.responseData { dataResponse in
            
            
            switch dataResponse.result {
            case .success:
            
                print("애플 회원가입----- 데이터 요청 성공")
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                
                print(statusCode)
                print(value)
                
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
                
            case .failure: completion(.pathErr)
                
            }
        }
        
    }
    
    func googleJoin(email: String,
                    profileImage: String,
                    pushAgree: Bool,
                    emailAgree: Bool,
                    completion : @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = Constants.googleLoginURL
        let header : HTTPHeaders = ["Content-Type": "application/json"]

        
        let dataRequest = AF.request(URL,
                                     method: .post,
                                     parameters: makeGoogleParameter(email: email,
                                                                     profileImage: profileImage,
                                                                     pushAgree: pushAgree,
                                                                     emailAgree: emailAgree),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        print(makeGoogleParameter(email: email,
                                  profileImage: profileImage,
                                  pushAgree: pushAgree,
                                  emailAgree: emailAgree))
        
        dataRequest.responseData { dataResponse in
            
            
            switch dataResponse.result {
            case .success:
                print("구글 회원가입----- 데이터 요청 성공")
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
                
            case .failure: completion(.pathErr)
                
            }
        }
        
        
    }
    
    func kakaoJoin(email: String,
                   profileImage: String,
                   pushAgree: Bool,
                   emailAgree: Bool,
                   nickname: String,
                   completion : @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = Constants.kakaoLoginURL
        let header : HTTPHeaders = ["Content-Type": "application/json"]

        
        let dataRequest = AF.request(URL,
                                     method: .post,
                                     parameters: makeKakaoParameter(email: email,
                                                                    profileImage: profileImage, pushAgree: pushAgree, emailAgree: emailAgree, nickname: nickname),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        
        dataRequest.responseData { dataResponse in
            
            
            switch dataResponse.result {
            case .success:
                
                print("카카오 회원가입----- 데이터 요청 성공")
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
                
            case .failure: completion(.pathErr)
                
            }
        }
        
        
        
        
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(LoginDataModel.self, from: data)
        else {
            print("패쓰에러")
            return .pathErr
        }
        
        switch statusCode {
        case 200...299, 404, 401:
            print("소셜 회원가입 --- 데이터 받기 성공")
            return .success(decodedData.data)
            
        case 400: return .requestErr(decodedData.msg)
        case 500: return .serverErr
        default: return .networkFail
        }
        
    }

}
