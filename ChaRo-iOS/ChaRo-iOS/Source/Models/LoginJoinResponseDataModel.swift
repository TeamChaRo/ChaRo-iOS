//
//  LoginJoinResponseDataModel.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/18.
//

import Foundation

struct LoginJoinResponseDataModel : Codable {
    let success: Bool
    let msg: String
    let data: UserInitialInfo
}

struct UserInitialInfo : Codable {
    let email: String
    let nickname: String
    let profileImage: String
}
