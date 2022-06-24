//
//  NotificationListModel.swift
//  ChaRo-iOS
//
//  Created by hwangJi on 2022/03/22.
//

import Foundation

enum NotificationType: String, Codable {
    case post = "post"
    case following = "following"
}

// MARK: - NotificationListModel
struct NotificationListModel: Codable {
    let pushID, isRead, postID: Int?
    let token: String?
    let image: String?
    let title, body, month, day, type: String?
    let followed: Bool?

    enum CodingKeys: String, CodingKey {
        case pushID = "push_id"
        case isRead = "is_read"
        case postID = "postId"
        case token, image, title, body, month, day, type, followed
    }
    
    /// 알림 날짜 표시 형식에 맞춰 convert하는 함수
    func convertNotiDateString(month: String, day: String) -> String {
        return month + "월 " + day + "일"
    }
}
