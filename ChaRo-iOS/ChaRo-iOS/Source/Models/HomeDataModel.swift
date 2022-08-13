// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct HomeDataModel: Codable {
    let success: Bool
    let msg: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let banner: [Banner]
    let todayCharoDrive, trendDrive: Drive
    let customTitle: String
    let customDrive: Drive
    let localTitle: String
    let localDrive: Drive
}

// MARK: - Banner
struct Banner: Codable {
    let bannerTitle: String
    let bannerImage: String
    let bannerTag: String
}

// MARK: - Drive
struct Drive: Codable {
    let lastID, lastCount: Int
    let drive: [DriveElement]

    enum CodingKeys: String, CodingKey {
        case lastID = "lastId"
        case lastCount, drive
    }
}

// MARK: - DriveElement
struct DriveElement: Codable {
    let postID: Int
    let title: String
    let image: String
    let region, theme: String
    let warning: String?
    let year, month, day: String
    var isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title, image, region, theme, warning, year, month, day, isFavorite
    }
}

//enum Warning: String, Codable {
//    case 사람많음 = "사람많음"
//    case 산길포함 = "산길포함"
//    case 초보힘듦 = "초보힘듦"
//}
