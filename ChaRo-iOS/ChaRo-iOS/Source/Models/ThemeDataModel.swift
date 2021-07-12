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
    let data: TotalDrive
}

// MARK: - TotalDrive
struct TotalDrive: Codable {
    let totalCourse: Int
    let drive: [Drive]
}

// MARK: - Drive
struct Drive: Codable {
    let postId: Int
    let title: String
    let image: String
    let isFavorite: Bool
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case postId = "postId"
        case title, image, isFavorite, tags
    }
}

