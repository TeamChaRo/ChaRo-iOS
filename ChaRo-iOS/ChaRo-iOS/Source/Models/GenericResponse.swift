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
}
