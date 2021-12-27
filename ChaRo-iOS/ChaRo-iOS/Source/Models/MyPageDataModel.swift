//import Foundation
//
//// MARK: - MyPageDataModel
//struct MyPageDataModel: Codable {
//    let success: Bool
//    let msg: String
//    let data: MyPageClass
//}
//
//// MARK: - DataClass
//struct MyPageClass: Codable {
//    let userInformation: UserInformation
//    let writtenTotal: Int
//    let writtenPost: [Post]
//    let savedTotal: Int
//    let savedPost: [Post]
//}
//
//// MARK: - UserInformation
//struct UserInformation: Codable {
//    let nickname: String
//    let profileImage: String
//    let following, follower: Int
//}
//
//// MARK: - WrittenPost
//struct Post: Codable {
//    let postID: Int
//    let title: String
//    let image: String
//    let tags: [String]
//    let favoriteNum, saveNum: Int
//    let year, month, day: String
//
//    enum CodingKeys: String, CodingKey {
//        case postID = "postId"
//        case title, image, tags, favoriteNum, saveNum, year, month, day
//    }
//}


import Foundation

// MARK: - MyPageDataModel
struct MyPageDataModel: Codable {
    let success: Bool
    let msg: String
    let data: MyPageDataClass
}

// MARK: - DataClass
struct MyPageDataClass: Codable {
    let userInformation: UserInformation
    let writtenPost, savedPost: MyPagePost
}

// MARK: - Post
struct MyPagePost: Codable {
    let lastID, lastCount: Int
    let drive: [MyPageDrive]

    enum CodingKeys: String, CodingKey {
        case lastID = "lastId"
        case lastCount, drive
    }
}

// MARK: - Drive
struct MyPageDrive: Codable {
    var postID: Int = 0
    var title: String = ""
    var image: String = ""
    var region: String = ""
    var theme: String = ""
    var warning: String? = ""
    var year: String = ""
    var month: String = ""
    var day: String = ""
    var isFavorite: Bool = false
    var favoriteNum: Int = 0
    var saveNum: Int = 0

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title, image, region, theme, warning, year, month, day, isFavorite, favoriteNum, saveNum
    }

    
}

// MARK: - UserInformation
struct UserInformation: Codable {
    let nickname: String
    let profileImage: String
    let following, follower: Int
}
