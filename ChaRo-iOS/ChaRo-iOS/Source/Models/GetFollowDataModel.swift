import Foundation

// MARK: - DoFollowDataModel
struct GetFollowDataModel: Codable {
    let success: Bool
    let msg: String
    let data: followData
}

// MARK: - DataClass
struct followData: Codable {
    let follower, following: [Follow]
}

// MARK: - Follow
struct Follow: Codable {
    let nickname, userEmail: String
    let image: String
    let isFollow: Bool

    enum CodingKeys: String, CodingKey {
        case nickname, userEmail, image
        case isFollow = "is_follow"
    }
}
