//
//  SearchKeywordDataMadel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/13.
//

import Foundation


// MARK: - SearchKeywordDataModel
struct SearchResultDataModel: Codable{
    let success: Bool
    let msg: String
    let data: [KeywordResult]?
    
    init(from decoder : Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        msg = (try? values.decode(String.self, forKey: .msg)) ?? ""
        data = (try? values.decode([KeywordResult].self, forKey: .data)) ?? []
    }
}

struct SearchKeywordDataModel: Codable {
    let userId: String
    let searchHistory: [SearchHistory]

    enum CodingKeys: String, CodingKey {
        case userId
        case searchHistory
    }
    
    func toJSON() -> [String: Any] {
        var history:[[String: Any]] = []
        
        for item in searchHistory {
            history.append(item.toJSON())
        }
        
        return ["userId" : userId,
                "searchHistory" : history]
    }
    
    
}

// MARK: - SearchHistory
struct SearchHistory: Codable {
    let title, address, latitude, longitude: String
    
    func toJSON() -> [String: Any] {
        return [ "title" : title as Any,
                 "address" : address as Any,
                 "latitude" : latitude as Any,
                 "longitude" : longitude as Any]
    }
}

struct KeywordResult: Codable {
    let title, address, latitude, longitude: String
    let year, month, day: String

    func getAddressModel() -> AddressDataModel {
        return AddressDataModel(title: latitude,
                                address: longitude,
                                latitude: address,
                                longitude: title)
    }
    
    
}
