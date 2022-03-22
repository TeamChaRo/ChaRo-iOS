//
//  NotificationListModel.swift
//  ChaRo-iOS
//
//  Created by hwangJi on 2022/03/22.
//

import Foundation

// MARK: - NotificationListModel
struct NotificationListModel: Codable {
    let pushID, pushCode, isRead: Int
    let token: String
    let image: String
    let title, body, month, day: String

    enum CodingKeys: String, CodingKey {
        case pushID = "push_id"
        case pushCode = "push_code"
        case isRead = "is_read"
        case token, image, title, body, month, day
    }
}

/// 알림 날짜 표시 형식에 맞춰 convert하는 함수
func convertNotiDateString(month: String, day: String) -> String {
    return month + "/" + day
}
