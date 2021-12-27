//
//  UserData.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/15.
//

import Foundation

class UserInfo {
    
    static let shared = UserInfo()
    
    var email: String?
    var nickname: String?
    var profileImage: String?
    var token: String?
    
    private init() { }
    
}
