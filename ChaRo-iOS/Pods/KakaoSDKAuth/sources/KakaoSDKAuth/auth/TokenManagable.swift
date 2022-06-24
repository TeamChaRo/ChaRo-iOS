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

/// 카카오 로그인 API를 통해 발급 받은 토큰을 관리하는 프로토콜입니다.
///
/// 카카오에서 제공하는 Open API 중 Authorization 헤더에 토큰을 입력해야 하는 로그인 기반 API를 호출할 때, SDK 내부적으로 이 프로토콜을 통하여 토큰 저장 및 읽기를 수행합니다.
/// 카카오 SDK에서는 개발자의 편의를 위하여 기본 관리자를 제공하고 있습니다.
///
/// - seealso: `TokenManager`
///
/// ## 커스텀 토큰 관리자
/// TokenManagable 프로토콜을 구현하여 직접 토큰 관리자를 구현할 수 있습니다.
///

public protocol TokenManagable {
    
    // MARK: Methods
    
    /// 토큰을 저장합니다.
    func setToken(_ token:OAuthToken?)
    
    /// 저장된 토큰을 가져옵니다.
    func getToken() -> OAuthToken?
    
    /// 저장된 토큰을 삭제합니다.
    func deleteToken()
}
