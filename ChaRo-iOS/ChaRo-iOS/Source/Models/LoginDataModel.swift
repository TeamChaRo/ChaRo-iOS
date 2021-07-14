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
    let data: User
}

// MARK: - UserData
struct User: Codable {
    let userID, nickname, token: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, token
    }
}
