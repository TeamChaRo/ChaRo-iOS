//
//  GenericResponse.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/11/21.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    let success: Bool
    let msg: String
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case success
        case msg = "message"
        case data
    }
    
    init(from decoder : Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        msg = (try? values.decode(String.self, forKey: .msg)) ?? ""
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
    }
}
