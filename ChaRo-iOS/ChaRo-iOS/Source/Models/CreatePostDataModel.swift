//
//  CreatePostDataModel.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/14.
//

import Foundation

struct CreatePostDataModel: Codable {
    let success: Bool
    let message: String
    let data: WritePostData
}

struct WritePostData: Codable {
    let title: String
    let userEmail: String
    let province: String
    let region: String
    let theme: [String]
    let warning: [String]
    let isParking: Bool
    let parkingDesc: String
    let courseDesc: String
    var course: [Address]
}

struct Address: Codable {
    let address: String
    let latitude: String
    let longtitude: String
}
