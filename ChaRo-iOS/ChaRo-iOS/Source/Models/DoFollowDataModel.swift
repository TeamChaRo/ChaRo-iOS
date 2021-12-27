import Foundation

// MARK: - DoFollowDataModel
struct DoFollowDataModel: Codable {
    let success: Bool
    let msg: String
    let data: DoFollowData
}

// MARK: - DataClass
struct DoFollowData: Codable {
    let isFollow: Bool
}
