//
//  UserDataModel.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/15.
//

import Foundation

// MARK: - LoginDataModel
struct LoginDataModel: Codable {
    let success: Bool
    let msg: String
    let data: UserData?
    
    enum CodingKeys: String, CodingKey {
        case success
        case msg
        case data
    }
    
    init(from decoder : Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        msg = (try? values.decode(String.self, forKey: .msg)) ?? ""
        data = (try? values.decode(UserData.self, forKey: .data)) ?? nil
    }
}

// MARK: - UserData
struct UserData: Codable {
    
    let userId: String
    let nickname: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "userID"
        case nickname = "user_nickname"
        case token = ""
    }
}


//
//import Foundation
//
//// MARK: - LoginDataModel
//struct LoginDataModel: Codable {
//    let success: Bool
//    let message: String
//    let data: UserData?
//
//    enum CodingKeys: String, CodingKey {
//        case success
//        case message
//        case data
//    }
//
//    init(from decoder : Decoder) throws
//    {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
//        message = (try? values.decode(String.self, forKey: .message)) ?? ""
//        data = (try? values.decode(UserData.self, forKey: .data)) ?? nil
//    }
//}
//
//// MARK: - UserData
//struct UserData: Codable {
//    let userID: Int
//    let userNickname, token: String
//
//    enum CodingKeys: String, CodingKey {
//        case userID = "UserId"
//        case userNickname = "user_nickname"
//        case token
//    }
//}