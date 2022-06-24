//  Copyright 2019 Kakao Corp.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

/// 카카오 로그인을 통해 발급 받은 토큰입니다.
///
/// 이 토큰을 이용하여 로그인 기반 API를 호출할 수 있습니다. 카카오 SDK를 이용하여 로그인에 성공하면 발급된 토큰을 SDK 내부에 설정된 `TokenManagable` 구현체를 통해 저장합니다. 이후 로그인 기반 API(ex. 사용자관리)를 호출하면 해당 토큰을 읽어오며 API 요청 Authorization 헤더에 자동 입력됩니다.
public struct OAuthToken: Codable {
    
    // MARK: Fields
    
    /// :nodoc: 토큰 타입. 현재는 "Bearer" 타입만 사용됩니다.
    public let tokenType: String

    /// 액세스 토큰
    public let accessToken: String
    
    /// :nodoc: 액세스 토큰의 남은 만료시간 (단위: 초)
    public let expiresIn: TimeInterval
    
    /// 액세스 토큰의 만료 시각
    public let expiredAt: Date
    
    /// 리프레시 토큰
    public let refreshToken: String
    
    /// :nodoc: 리프레시 토큰의 남은 만료시간 (단위: 초)
    public let refreshTokenExpiresIn: TimeInterval
    
    /// 리프레시 토큰의 만료 시각
    public let refreshTokenExpiredAt: Date
    
    public let scope: String? //space delimited string
    
    /// 현재까지 사용자로부터 획득에 성공한 scope (동의항목) 목록. 인증코드를 통한 토큰 신규 발급 시점에만 저장되며 이후 같은 값으로 유지됩니다. 토큰 갱신으로는 최신정보로 업데이트되지 않습니다.
    public let scopes: [String]?
    
    /// OpenID Connect 확장 기능을 통해 발급되는 ID 토큰, Base64 인코딩된 사용자 인증 정보 포함
    public let idToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken, expiresIn, tokenType, refreshToken, refreshTokenExpiresIn, scope, idToken
    }
    
    
    // MARK: Initializers
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.accessToken = try values.decode(String.self, forKey: .accessToken)
        self.expiresIn = try values.decode(TimeInterval.self, forKey: .expiresIn)
        self.expiredAt = Date().addingTimeInterval(self.expiresIn)
        self.tokenType = try values.decode(String.self, forKey: .tokenType)
        self.refreshToken = try values.decode(String.self, forKey: .refreshToken)
        self.refreshTokenExpiresIn = try values.decode(TimeInterval.self, forKey: .refreshTokenExpiresIn)
        self.refreshTokenExpiredAt = Date().addingTimeInterval(self.refreshTokenExpiresIn)
        self.scope = try? values.decode(String.self, forKey: .scope)
        self.scopes = scope?.components(separatedBy:" ")
        self.idToken = try? values.decode(String.self, forKey: .idToken)
    }
    
    public init(accessToken: String,
                expiresIn: TimeInterval? = nil,
                expiredAt: Date? = nil,
                tokenType: String,
                refreshToken: String,
                refreshTokenExpiresIn: TimeInterval? = nil,
                refreshTokenExpiredAt: Date? = nil,
                scope: String?,
                scopes: [String]?,
                idToken: String? = nil) {
        
        self.accessToken = accessToken
        self.expiresIn = (expiresIn != nil) ? expiresIn! : 0
        
        if let expiredAt = expiredAt {
            self.expiredAt = expiredAt
        }
        else {
            self.expiredAt = (self.expiresIn == 0) ? Date(timeIntervalSince1970: 0) : Date().addingTimeInterval(self.expiresIn)
        }
        
        self.tokenType = tokenType
        self.refreshToken = refreshToken
        self.refreshTokenExpiresIn = (refreshTokenExpiresIn != nil) ? refreshTokenExpiresIn! : 0
        if let refreshTokenExpiredAt = refreshTokenExpiredAt {
            self.refreshTokenExpiredAt = refreshTokenExpiredAt
        }
        else {
            self.refreshTokenExpiredAt = (self.refreshTokenExpiresIn == 0) ? Date(timeIntervalSince1970: 0) : Date().addingTimeInterval(self.refreshTokenExpiresIn)
        }
        self.scope = scope
        self.scopes = scopes
        self.idToken = idToken
    }
    
    static func ==(left:OAuthToken, right:OAuthToken) -> Bool {
        if (left.accessToken == right.accessToken) {
            return true
        }
        else {
            return false
        }
    }
    
    static func !=(left:OAuthToken, right:OAuthToken) -> Bool {
        if (left.accessToken != right.accessToken) {
            return true
        }
        else {
            return false
        }
    }
    
//    static func ==(left:OAuthToken, right:OAuthToken) -> Bool {
//        if (left.accessToken == right.accessToken &&
//            left.expiresIn == right.expiresIn &&
//            left.tokenType == right.tokenType &&
//            left.refreshToken == right.refreshToken &&
//            left.refreshTokenExpiresIn == right.refreshTokenExpiresIn &&
//            left.scope == right.scope) {
//            return true
//        }
//        else {
//            return false
//        }
//    }
//    
//    static func !=(left:OAuthToken, right:OAuthToken) -> Bool {
//        if (left.accessToken != right.accessToken ||
//            left.expiresIn != right.expiresIn ||
//            left.tokenType != right.tokenType ||
//            left.refreshToken != right.refreshToken ||
//            left.refreshTokenExpiresIn != right.refreshTokenExpiresIn ||
//            left.scope != right.scope) {
//            return true
//        }
//        else {
//            return false
//        }
//    }
}

/// :nodoc:
public struct Token: Codable {
    public let accessToken: String
    public let expiresIn: TimeInterval
    public let tokenType: String
    public let refreshToken: String?
    public let refreshTokenExpiresIn: TimeInterval?
    public let scope: String? //space delimited string
    public let scopes: [String]?
    public let idToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken, expiresIn, tokenType, refreshToken, refreshTokenExpiresIn, scope, idToken
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try values.decode(String.self, forKey: .accessToken)
        expiresIn = try values.decode(TimeInterval.self, forKey: .expiresIn)
        tokenType = try values.decode(String.self, forKey: .tokenType)
        refreshToken = try? values.decode(String.self, forKey: .refreshToken)
        refreshTokenExpiresIn = try? values.decode(TimeInterval.self, forKey: .refreshTokenExpiresIn)
        scope = try? values.decode(String.self, forKey: .scope)
        scopes = scope?.components(separatedBy:" ")
        idToken = try? values.decode(String.self, forKey: .idToken)
    }
}


/// :nodoc: internal use only
public struct CertOAuthToken: Codable {
    public let tokenType: String
    public let accessToken: String
    public let expiresIn: TimeInterval
    public let expiredAt: Date
    public let refreshToken: String
    public let refreshTokenExpiresIn: TimeInterval
    public let refreshTokenExpiredAt: Date
    public let scope: String? //space delimited string
    public let scopes: [String]?
    public let txId: String?
    public let idToken: String?
    
    
    enum CodingKeys: String, CodingKey {
        case accessToken, expiresIn, tokenType, refreshToken, refreshTokenExpiresIn, scope, txId, idToken
    }
    
    
    // MARK: Initializers
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.accessToken = try values.decode(String.self, forKey: .accessToken)
        self.expiresIn = try values.decode(TimeInterval.self, forKey: .expiresIn)
        self.expiredAt = Date().addingTimeInterval(self.expiresIn)
        self.tokenType = try values.decode(String.self, forKey: .tokenType)
        self.refreshToken = try values.decode(String.self, forKey: .refreshToken)
        self.refreshTokenExpiresIn = try values.decode(TimeInterval.self, forKey: .refreshTokenExpiresIn)
        self.refreshTokenExpiredAt = Date().addingTimeInterval(self.refreshTokenExpiresIn)
        self.scope = try? values.decode(String.self, forKey: .scope)
        self.scopes = scope?.components(separatedBy:" ")
        self.txId = try? values.decode(String.self, forKey: .txId)
        self.idToken = try? values.decode(String.self, forKey: .idToken)
    }
}

/// 카카오톡 인증 로그인을 통해 발급 받은 토큰 및 전자서명 접수번호 입니다.
public struct CertTokenInfo: Codable {
    ///토큰 정보
    public let token: OAuthToken
    
    ///전자서명 접수번호
    public let txId: String
    
    public init(token:OAuthToken,
                txId:String) {
        self.token = token
        self.txId = txId
    }
}
