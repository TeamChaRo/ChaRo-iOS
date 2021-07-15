// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let myPageDataModel = try? newJSONDecoder().decode(MyPageDataModel.self, from: jsonData)

import Foundation

// MARK: - MyPageDataModel
struct MyPageDataModel: Codable {
    let success: Bool
    let msg: String
    let data: MyPageClass
}

// MARK: - DataClass
struct MyPageClass: Codable {
    let userInformation: UserInformation
    let writtnTotal: Int
    let writtenPost: [Post]
    let savedTotal: Int
    let savedPost: [Post]
}

// MARK: - Post
struct Post: Codable {
    let postID: Int
    let title: String
    let image: String
    let tags: [String]
    let favoriteNum, saveNum: Int
    let year, month, day: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title, image, tags, favoriteNum, saveNum, year, month, day
    }
}

// MARK: - UserInformation
struct UserInformation: Codable {
    let nickname: String
    let profileImage: String
    let following, follower: [String]
}
