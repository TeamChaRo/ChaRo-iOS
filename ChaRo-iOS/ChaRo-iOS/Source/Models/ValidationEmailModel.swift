//
//  ValidationEmailModel.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/06.
//

import Foundation

struct ValidationEmailModel: Codable {
    let success: Bool
    let msg, data: String
}

