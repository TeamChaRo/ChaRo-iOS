//
//  ThemeDataModel.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/12.
//

import Foundation

// MARK: - Status
struct ThemeDataModel: Codable {
    let success: Bool
    let msg: String
    let data: Drive
}

// MARK: - TotalDrive
struct TotalDrive: Codable {
    let lastId: Int
    let lastCount: Int
    let drive: [Drive]
}


