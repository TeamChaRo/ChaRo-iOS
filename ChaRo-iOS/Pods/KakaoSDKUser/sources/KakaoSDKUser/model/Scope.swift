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

// MARK: Enumerations

///동의 항목 타입
public enum ScopeType: String, Codable {
    ///개인정보 보호 동의 항목
    case Privacy = "PRIVACY"
    
    ///접근권한 관리 동의 항목
    case Service = "SERVICE"
}

/// 동의 항목별 정보
public struct Scope : Codable {
    // MARK: Fields
    
    /// 동의 항목 ID
    public let id: String
    
    /// 사용자 동의 화면에 출력되는 동의 항목 이름 또는 설명
    public let displayName: String

    /// 동의 항목 타입
    public let type: ScopeType

    ///동의 항목의 현재 사용 여부
    ///사용자가 동의했으나 현재 앱에 설정되어 있지 않은 동의 항목의 경우 false
    public let using: Bool
    
    ///카카오가 관리하지 않는 위임 동의 항목인지 여부
    ///현재 사용 중인 동의 항목이고, 위임 동의 항목인 경우에만 응답에 포함
    public let delegated: Bool?

    ///사용자 동의 여부
    ///동의한 경우 true, 동의하지 않은 경우 false
    public let agreed: Bool

    ///동의 항목의 동의 철회 가능 여부
    ///사용자가 동의한 동의 항목인 경우에만 응답에 포함
    public let revocable : Bool?

}


/// 사용자 동의 내역
public struct ScopeInfo : Codable {
    
    // MARK: Fields
    
    ///회원번호
    public let id: Int64
    
    ///해당 앱의 동의 항목(Scope) 목록 (empty 일 경우가 있음)
    public let scopes: [Scope]?
}
