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

/// 토큰 정보 요청 API 응답 클래스 입니다.
/// - seealso: `UserApi.accessTokenInfo()`
public struct AccessTokenInfo: Codable {
    
    // MARK: Fields
    /// 앱 아이디
    public let appId: Int64
    
    /// 사용자 아이디
    public let id: Int64?
    
    /// 더 이상 사용하지 않는 프로퍼티 입니다. 대신 expriresIn을 사용해주세요.
    /// 해당 액세스 토큰의 남은 만료시간 (단위: milli-second)
    @available(*, deprecated, message: "대신 expiresIn 을 사용해주세요.")
    public let expiresInMillis: Int64?
    
    /// 해당 액세스 토큰의 남은 만료시간 (단위: second)
    public let expiresIn: Int64
}
