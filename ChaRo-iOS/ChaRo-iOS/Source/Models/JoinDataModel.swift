//
//  JoinDataModel.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/09.
//

import Foundation

struct JoinDataModel: Codable {
    let success: Bool
    let msg: String
    let data: JoinUserModel
}

struct JoinUserModel: Codable {
    let email: String
    let nickname: String
    let profileImage: String
    let marketingPush: Bool
    let marketingEmail: Bool
}
