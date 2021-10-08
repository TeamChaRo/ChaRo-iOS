//
//  JoinDataModel.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/09.
//

import Foundation


struct JoinDataModel: Codable {
    let password: String
    let userEmail: String
    
    let nickname: String
    let marketingPush: Bool
    let marketingEmail: Bool
}
