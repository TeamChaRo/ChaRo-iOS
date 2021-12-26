//
//  PostDetailDataModel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/15.
//

import Foundation
import TMapSDK

// MARK: - Welcome
struct PostDatailDataModel: Codable {
    let success: Bool
    let msg: String
    let data: PostDetailData?
}

//// MARK: - Datum
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
    let address, latitude, longitude: String
    
    func getPoint() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
    }
}
