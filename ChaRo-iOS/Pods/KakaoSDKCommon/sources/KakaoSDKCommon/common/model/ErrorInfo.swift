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

/// API 호출 시 발생하는 에러 정보입니다.
/// - seealso: `ApiFailureReason`
public struct ErrorInfo : Codable {
    
    /// 에러 코드
    public let code: ApiFailureReason
    
    /// 에러 메시지
    public let msg: String
    
    /// 사용자에게 API 호출에 필요한 동의를 받지 못하여 `ApiFailureReason.InsufficientScope` 에러가 발생한 경우 필요한 scope 목록이 내려옵니다. 이 scope 목록으로 추가 항목 동의 받기를 요청해야 합니다.
    public let requiredScopes: [String]?
    
    /// :nodoc: API 타입
    public let apiType: String?
    
    public let allowedScopes: [String]?

    public init(code: ApiFailureReason, msg:String, requiredScopes:[String]?) {
        self.code = code
        self.msg = msg
        self.requiredScopes = requiredScopes
        self.apiType = nil
        self.allowedScopes = nil
    }
}
