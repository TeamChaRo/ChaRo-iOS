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

/// 사용자 정보 요청 API 응답으로 제공되는 사용자 정보 최상위 클래스입니다.
/// - seealso: `UserApi.me(propertyKeys:secureResource:)`
public struct User : Codable {
    
    // MARK: Fields
    
    /// 카카오 플랫폼 내에서 사용되는 사용자의 고유 아이디입니다.
    ///
    /// 서로 다른 앱키로 로그인한 경우 동일한 카카오계정이라 하더라도 다른 값이 부여됩니다. 연결 끊기(unlink) 후 다시 로그인할 때 **사용자 아이디 고정**이 비활성화 상태인 경우 새로운 값으로 재발급됩니다.
    ///
    /// - note:
    /// 2018년 9월 19일부터 신규로 생성되는 앱에 대해 **사용자 아이디 고정**을 자동으로 활성화하고 있습니다. https://devtalk.kakao.com/t/api/58481?u=karl.lee&source_topic_id=60227
    public let id: Int64?
    
    /// 앱 별로 제공되는 사용자 정보 데이터베이스입니다.
    ///
    /// 이 데이터베이스를 통해 서비스에서 사용되는 사용자의 각종 정보를 저장하는 DB로 활용할 수 있으며 카카오 서비스에 등록된 사용자의 프로필 정보를 제공 받을 수도 있습니다.
    /// 로그인한 사용자의 카카오계정 프로필에 있는 닉네임과 프로필 이미지 정보를 앱 연결 시점에 복사하여 초기값으로 제공되며 이후 해당 카카오계정 프로필에 변경이 발생한 경우 변경된 정보와 동기화되지 않습니다.
    ///
    /// - note:
    /// **실시간 프로필** 정보를 원하는 경우 `Profile`을 참고하시기 바랍니다.
    ///
    /// 기본 제공되는 사용자 프로필 정보의 키 이름은 아래와 같습니다.
    ///
    /// - nickname : 카카오계정에 설정된 닉네임
    /// - profile_image : 프로필 이미지 URL 문자열
    /// - thumbnail_image : 썸네일 사이즈의 프로필 이미지 URL 문자열
    ///
    /// 프로필 또는 다른 정보를 추가 저장하거나 기본 제공되는 정보를 수정하고 싶은 경우 `UserApi`의 updateProfile 메소드를 사용할 수 있습니다.
    public let properties: [String:String]?
    
    /// 사용자의 카카오계정 정보
    ///
    /// 이메일, 프로필 정보 등이 제공됩니다. 이 필드를 통해 내려 받을 수 있는 정보가 하나도 없을 경우 nil이 될 수 있습니다.
    /// - seealso: `Account`
    public let kakaoAccount: Account?
    
    /// 앱이 그룹에 속해 있는 경우 그룹 내 사용자 식별 토큰입니다. 앱의 그룹정보가 변경될 경우 토큰 값도 변경됩니다. 제휴를 통해 권한이 부여된 특정 앱에만 제공됩니다.
    public let groupUserToken: String?
    
    ///해당 서비스에 연결 완료된 시각
    public let connectedAt : Date?
    
    ///'카카오싱크 간편가입창'을 통해 카카오 로그인 한 시각
    public let synchedAt : Date?
    
    /// 사용자가 앱에 연결되어 있는지 여부를 나타냅니다. **자동 연결** 설정이 활성화되어 있는 경우 값이 내려오지 않으므로 앱에 연결되어 있다고 가정해도 무방합니다.
    public let hasSignedUp: Bool?
}

// MARK: Enumerations

/// 연령대(한국 나이) 정보 열거형
public enum AgeRange : String, Codable {
    /// 0세 ~ 9세
    case Age0_9  = "0~9"
    /// 10세 ~ 14세
    case Age10_14 = "10~14"
    /// 15세 ~ 19세
    case Age15_19 = "15~19"
    /// 20세 ~ 29세
    case Age20_29 = "20~29"
    /// 30세 ~ 39세
    case Age30_39 = "30~39"
    /// 40세 ~ 49세
    case Age40_49 = "40~49"
    /// 50세 ~ 59세
    case Age50_59 = "50~59"
    /// 60세 ~ 69세
    case Age60_69 = "60~69"
    /// 70세 ~ 79세
    case Age70_79 = "70~79"
    /// 80세 ~ 89세
    case Age80_89 = "80~89"
    /// 90세 이상
    case Age90_Above = "90~"
}

/// 성별 정보 열거형
public enum Gender : String, Codable {
    /// 남자
    case Male = "male"
    /// 여자
    case Female = "female"
}

/// 생일의 양력/음력 열거형
public enum BirthdayType : String, Codable {
    /// 양력
    case Solar = "SOLAR"
    /// 음력
    case Lunar = "LUNAR"
}

/// 카카오계정에 등록된 사용자 개인정보를 제공합니다.
/// - seealso: `User.kakaoAccount`
///
/// 내려오는 실제 정보는 https://accounts.kakao.com 으로 접속하여 해당 계정으로 로그인한 후 확인하실 수 있습니다.
///
/// 이 클래스에서 제공하는 카카오계정의 모든 개인정보는 사용자의 동의를 받지 않은 경우 nil이 반환됩니다. 개인정보 필드의 값이 없으면 해당 필드와 매칭되는 {property}NeedsAgreement 속성 값을 확인하여 사용자에게 정보 제공에 대한 동의를 요청하고 정보 획득을 시도해 볼 수 있습니다. {property}NeedsAgreement 값이 true인 경우 새로운 동의 요청이 가능한 상태이며 KOSession의 updateScopes 메소드를 이용하여 동의를 받을 수 있습니다. 동의를 받은 후 user/me를 다시 호출하면 해당 값이 반환될 것입니다. {property}NeedsAgreement 값이 false인 경우 사용자의 계정에 해당 정보가 없어서 값을 얻을 수 없음을 의미합니다.
///
/// - important:
///  [내 애플리케이션] > [제품 설정] > [카카오 로그인] > [동의항목] 에서 **선택 동의**로 설정된 정보의 동의 요청은 매우 주의해야 합니다. 추가 항목 동의 받기로 값을 필수로 획득하는 행위는 반드시 서비스 가입과 관계 없는 특정 시나리오에서 시도해야 합니다. 사용자가 동의하지 않아도 서비스 이용에 지장이 없어야 합니다.

public struct Account : Codable {
    
    // MARK: Fields
    
    /// profile 제공에 대한 사용자 동의 필요 여부
    public let profileNeedsAgreement: Bool?
    /// profile 닉네임 제공에 대한 사용자 동의 필요 여부
    public let profileNicknameNeedsAgreement: Bool?    
    /// profile 이미지 제공에 대한 사용자 동의 필요 여부
    public let profileImageNeedsAgreement: Bool?
    
    /// 카카오계정에 등록한 프로필 정보
    /// - seealso: `Profile`
    public let profile: Profile?
    
    /// 카카오계정 이름에 대한 사용자 동의 필요 여부
    public let nameNeedsAgreement: Bool?
    /// 카카오계정 이름
    public let name: String?
    
    /// email 제공에 대한 사용자 동의 필요 여부
    public let emailNeedsAgreement: Bool?
    /// 카카오계정에 등록된 이메일의 유효성
    public let isEmailValid: Bool?
    /// 카카오계정에 이메일 등록 시 이메일 인증을 받았는지 여부
    public let isEmailVerified: Bool?
    /// 카카오계정에 등록된 이메일
    public let email: String?
    
    /// ageRange 제공에 대한 사용자 동의 필요 여부
    public let ageRangeNeedsAgreement: Bool?
    /// 연령대
    /// - seealso: `AgeRange`
    public let ageRange: AgeRange?
    /// birthyear 제공에 대한 사용자 동의 필요 여부
    public let birthyearNeedsAgreement: Bool?
    /// 출생 연도 (YYYY)
    public let birthyear: String?
    /// birthday 제공에 대한 사용자 동의 필요 여부
    public let birthdayNeedsAgreement: Bool?
    /// 생일 (MMDD)
    public let birthday: String?
    /// 생일의 양력/음력
    public let birthdayType: BirthdayType?
    
    /// gender 제공에 대한 사용자의 동의 필요 여부
    public let genderNeedsAgreement: Bool?
    /// 성별
    /// - seealso: `Gender`
    public let gender: Gender?
    
    /// phoneNumber 제공에 대한 사용자 동의 필요 여부
    public let phoneNumberNeedsAgreement: Bool?
    /// 카카오톡에서 인증한 전화번호
    public let phoneNumber: String?
    
    /// ci 제공에 대한 사용자의 동의 필요 여부
    public let ciNeedsAgreement: Bool?
    /// 암호화된 사용자 확인값
    public let ci: String?    
    /// ci 발급시간
    public let ciAuthenticatedAt: Date?
    

    
    /// legalName 제공에 대한 사용자 동의 필요 여부
    public let legalNameNeedsAgreement : Bool?
    
    /// 실명
    public let legalName : String?
        
    /// legalBirthDate 제공에 대한 사용자 동의 필요 여부
    public let legalBirthDateNeedsAgreement : Bool?
    
    /// 법정생년월일
    public let legalBirthDate : String?
    
    /// legalGender 제공에 대한 사용자 동의 필요 여부
    public let legalGenderNeedsAgreement : Bool?
    
    /// 법정성별
    public let legalGender : Gender?
    
    ///한국인 여부 제공에 대한 사용자 동의 필요 여부
    public let isKoreanNeedsAgreement : Bool?
    
    ///한국인 여부
    public let isKorean : Bool?
}

/// 카카오계정에 등록된 사용자의 프로필 정보를 제공합니다.
/// - seealso: `Account.profile`
public struct Profile : Codable {
    
    // MARK: Fields

    /// 사용자의 닉네임
    public let nickname: String?
    
    /// 카카오계정에 등록된 프로필 이미지 URL
    ///
    /// 사용자가 프로필 이미지를 등록하지 않은 경우 nil이 내려옵니다. 사용자가 등록한 프로필 이미지가 사진인 경우 640 * 640 규격의 이미지가, 동영상인 경우 480 * 480 규격의 스냅샷 이미지가 제공됩니다.
    public let profileImageUrl: URL?
    
    /// 카카오계정에 등록된 프로필 이미지의 썸네일 규격 이미지 URL
    ///
    /// 사용자가 프로필 이미지를 등록하지 않은 경우 nil이 내려옵니다. 사용자가 등록한 프로필 이미지가 사진인 경우 110 * 110 규격의 이미지가, 동영상인 경우 100 * 100 규격의 스냅샷 이미지가 제공됩니다.
    public let thumbnailImageUrl: URL?
    
    /// 사용자 프로필 기본 이미지 여부
    public let isDefaultImage: Bool?
    
    enum CodingKeys : String, CodingKey {
        case nickname, profileImageUrl, thumbnailImageUrl, isDefaultImage
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        nickname = try? values.decode(String.self, forKey: .nickname)
        profileImageUrl = URL(string: (try? values.decode(String.self, forKey: .profileImageUrl)) ?? "")
        thumbnailImageUrl = URL(string: (try? values.decode(String.self, forKey: .thumbnailImageUrl)) ?? "")
        isDefaultImage = try? values.decode(Bool.self, forKey: .isDefaultImage)
    }
}
