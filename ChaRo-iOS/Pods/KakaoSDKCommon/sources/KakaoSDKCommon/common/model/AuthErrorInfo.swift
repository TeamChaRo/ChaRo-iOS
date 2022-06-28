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

/// 로그인 요청에서 사용되는 OAuth 에러를 나타냅니다.
/// - seealso: `AuthFailureReason`
public struct AuthErrorInfo : Codable {
    
    /// 에러 코드
    public let error: AuthFailureReason
    
    /// 에러 메시지
    public let errorDescription: String?
    
}
