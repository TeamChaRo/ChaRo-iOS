//
//  CreatePostDataModel.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/14.
//

import Foundation

struct CreatePostDataModel: Decodable {
    let success: Bool
    let message: String
//    let data: UserData?

    enum CodingKeys: String, CodingKey {
        case success
        case message
//        case data
    }

    init(from decoder : Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
//        data = (try? values.decode(UserData.self, forKey: .data)) ?? nil
    }
}

struct WritePostData {
    let title: String
    let userId: String
    let province: String
    let region: String
    let theme: [String]
    let warning: [Bool]
    let isParking: Bool
    let parkingDesc: String
    let courseDesc: String
    let course: [Address]
}

struct Address {
    let address: String
    let latitude: String
    let longtitude: String
}
