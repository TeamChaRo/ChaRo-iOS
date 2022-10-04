//
//  CreatePostDataModel.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/14.
//

import Foundation

struct CreatePostDataModel: Codable {
    let success: Bool
    let msg: String
}

struct WritePostData: Codable {
    let title: String
    let userEmail: String
    let province: String
    let region: String
    var theme: [String]
    let warning: [String]
    let isParking: Bool
    let parkingDesc: String
    let courseDesc: String
    var course: [Address]
    
    func changeThemeToKorean() -> [String] {
        var themeList: [String] = []
        theme.forEach {
            if let koreaTheme = CommonData.themeDict.getKey(by: $0) {
                themeList.append(koreaTheme)
            }
        }
        return themeList
    }
}

struct Address: Codable {
    let address: String
    let latitude: String
    let longitude: String
}
