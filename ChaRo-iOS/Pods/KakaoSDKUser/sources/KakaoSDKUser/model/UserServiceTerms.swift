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

/// 사용자가 동의한 약관 조회 API 응답 클래스 입니다.
/// - seealso: `UserApi.serviceTerms()`
public struct UserServiceTerms : Codable {
    
    // MARK: Fields
    
    /// 사용자 아이디
    public let userId: Int64?
    
    /// 사용자가 동의한 3rd의 약관 항목들
    /// - seealso: `ServiceTerms`
    public let allowedServiceTerms: [ServiceTerms]?
    
    /// 앱에 사용 설정된 서비스 약관 목록들
    public let appServiceTerms: [AppServiceTerms]?
}

/// 3rd party 서비스 약관 정보 클래스 입니다.
/// - seealso: `UserServiceTerms`
public struct ServiceTerms : Codable {
    
    // MARK: Fields
    
    /// 3rd에서 동의한 약관의 항목들을 정의한 값
    public let tag: String
    
    /// 동의한 시간. 약관이 여러번 뜨는 구조라면, 마지막으로 동의한 시간.
    public let agreedAt: Date
}


/// 앱에 사용 설정된 서비스 약관 목록
/// - seealso: `AppServiceTerms`
public struct AppServiceTerms : Codable {
    
    // MARK: Fields
    
    /// 3rd에서 동의한 약관의 항목들을 정의한 값
    public let tag: String
    
    /// 약관을 생성한 시간
    public let createdAt: Date
    
    /// 약관을 수정한 시간
    public let updatedAt: Date
}
