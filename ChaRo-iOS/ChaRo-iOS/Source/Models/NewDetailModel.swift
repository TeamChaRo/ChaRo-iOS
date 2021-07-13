// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let detailModel = try? newJSONDecoder().decode(DetailModel.self, from: jsonData)

import Foundation

// MARK: - DetailModel
struct NewDetailModel: Codable {
    let success: Bool
    let msg: String
    let data: NewDetailDataClass
}

// MARK: - DataClass
struct NewDetailDataClass: Codable {
    let totalCourse: Int
    let drive: [NewDetailDrive]
}

// MARK: - Drive
struct NewDetailDrive: Codable {
    let postID: Int
    let image: String
    let title: String
    let isFavorite: Bool
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case image, isFavorite, tags, title
    }
}
