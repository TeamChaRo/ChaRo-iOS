// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let homeDataModel = try? newJSONDecoder().decode(HomeDataModel.self, from: jsonData)

import Foundation

// MARK: - HomeDataModel
struct HomeDataModel: Codable {
    let success: Bool
    let msg: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let banner: [Banner]
    let todayCharoDrive, trendDrive: [Drive]
    let customThemeTitle: String
    let customThemeDrive: [Drive]
    let localTitle: String
    let localDrive: [Drive]
}

// MARK: - Banner
struct Banner: Codable {
    let bannerTitle: String
    let bannerImage: String
    let bannerTag: String
}

// MARK: - Drive
struct Drive: Codable {
    let postID: Int
    let title: String
    let image: String
    let isFavorite: Bool
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title, image, isFavorite, tags
    }
}

enum Tag: String, Codable {
    case 바다 = "바다"
    case 부산 = "부산"
    case 사람많음 = "사람많음"
    case 여름 = "여름"
    case 초보힘듦 = "초보힘듦"
}
