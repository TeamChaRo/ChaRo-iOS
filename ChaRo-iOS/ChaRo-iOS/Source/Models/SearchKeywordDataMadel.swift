//
//  SearchKeywordDataMadel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/13.
//

import Foundation


// MARK: - SearchKeywordDataModel
struct SearchPostResultDataModel: Codable{
    let success: Bool
    let msg: String
    
    init(from decoder : Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        msg = (try? values.decode(String.self, forKey: .msg)) ?? ""
    }
    
}

struct SearchKeywordDataModel: Codable {
    let userId: String
    let searchHistory: [SearchHistory]

    enum CodingKeys: String, CodingKey {
        case userId
        case searchHistory
    }
    
    
}

// MARK: - SearchHistory
struct SearchHistory: Codable {
    let title, address, latitude, longitude: String
}
