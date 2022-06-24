// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let detailModel = try? newJSONDecoder().decode(DetailModel.self, from: jsonData)

import Foundation

// MARK: - DetailModel
struct DetailModel: Codable {
    let success: Bool
    let msg: String
    let data: DetailDataClass
}

// MARK: - DataClass
struct DetailDataClass: Codable {
    let lastID: Int
    let drive: [DetailDrive]

    enum CodingKeys: String, CodingKey {
        case lastID = "lastId"
        case drive
    }
}

// MARK: - Drive
struct DetailDrive: Codable {
    let postID: Int
    let title: String
    let image: String
    let region, theme: String
    let warning: String?
    let year, month, day: String
    let isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title, image, region, theme, warning, year, month, day, isFavorite
    }
}

//
//// This file was generated from JSON Schema using quicktype, do not modify it directly.
//// To parse the JSON, add this file to your project and do:
////
////   let plansDetailDataModel = try? newJSONDecoder().decode(PlansDetailDataModel.self, from: jsonData)
//
//import Foundation
//
//// MARK: - PlansDetailDataModel
//struct PlansDetailDataModel: Codable {
//    let success: Bool
//    let msg: String
//    let data: DataClass
//}
//
//// MARK: - DataClass
//struct DataClass: Codable {
//    let lastID: Int
//    let drive: [Drive]
//
//    enum CodingKeys: String, CodingKey {
//        case lastID = "lastId"
//        case drive
//    }
//}
//
//// MARK: - Drive
//struct Drive: Codable {
//    let postID: Int
//    let title: String
//    let image: String
//    let region, theme: String
//    let warning: String?
//    let year, month, day: String
//    let isFavorite: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case postID = "postId"
//        case title, image, region, theme, warning, year, month, day, isFavorite
//    }
//}
