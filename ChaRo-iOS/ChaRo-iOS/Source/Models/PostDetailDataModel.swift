//
//  PostDetailDataModel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/15.
//

import Foundation

// MARK: - Welcome
struct PostDatailDataModel: Codable {
    let success: Bool
    let msg: String
    let data: [PostDetail]
}

// MARK: - Datum
struct PostDetail: Codable {
    let title, author: String
    let isAuthor: Bool
    let profileImage: String
    let postingYear, postingMonth, postingDay: String
    let isStored, isFavorite: Bool
    let likesCount: Int
    let images: [String]
    let province, city: String
    let themes: [String]
    let source: String
    let wayPoint: [String]
    let destination: String
    let longtitude, latitude: [String]
    let isParking: Bool
    let parkingDesc: String
    let warnings: [Bool]
    let courseDesc: String
}
