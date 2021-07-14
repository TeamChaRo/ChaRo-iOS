//
//  UserData.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/15.
//

import Foundation

struct UserInfo {
    
    static let shared = UserInfo()
    
    var id: String?
    var nickname: String?
    var token: String?
    
    private init() { }
    
}
