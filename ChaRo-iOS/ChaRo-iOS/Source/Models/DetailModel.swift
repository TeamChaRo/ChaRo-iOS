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
    let totalCourse: Int
    let drive: [DetailDrive]
}

// MARK: - Drive
struct DetailDrive: Codable {
    let postID: Int
    let title: String
    let image: String
    let isFavorite: Bool
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case image, isFavorite, tags, title
    }
}
