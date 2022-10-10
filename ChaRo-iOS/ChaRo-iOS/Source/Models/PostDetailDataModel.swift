//
//  PostDetailDataModel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/15.
//

import Foundation
import TMapSDK
import UIKit

//// MARK: - Datum
struct PostDetailDataModel: Codable {
    let postId: Int?
    let title: String?
    let author: String?
    let authorEmail: String?
    let profileImage: String?
    
    let isAuthor: Bool?
    let isStored: Int?
    let isFavorite: Int?
    let isParking: Bool?

    let parkingDesc: String?
    let courseDesc: String?

    let province: String?
    let region: String?
    let themes: [String]?

    let likesCount: Int?

    let createdAt: String?
    let images: [String]?
    let course: [Course]?
    let warnings: [Bool]?
    
    //2022-06-13T16:35:31.000Z
    func getCreatedTimeText() -> String {
        let timeText = createdAt?.split(separator: "T").first?.description ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = dateFormatter.date(from: timeText) ?? Date()
        let koreaDateFormatter = DateFormatter()
        koreaDateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let convertedString = koreaDateFormatter.string(from: convertedDate)
        return convertedString
    }
    
}

// MARK: - DataClass
struct PostDetailData: Codable {
    let images: [String]
    let province: String
    let isParking: Bool
    let parkingDesc, courseDesc: String
    let themes: [String]
    let warnings: [Bool]
    let author: String
    let isAuthor: Bool
    let profileImage: String
    let likesCount, isFavorite, isStored: Int
    let course: [Course]
}

// MARK: - Course
struct Course: Codable {
    let address, latitude, longitude: String?
    
    func getPoint() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(latitude ?? "0") ?? 0.0,
                                      longitude: Double(longitude ?? "0") ?? 0.0)
    }
}
