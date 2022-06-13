//
//  Contants.swift
//  ChaRo-iOS
//
//  Created by 서강준 on 2021/07/12.
//

import Foundation

struct Constants {
    
    // MARK: - BASE URL
    static let baseURL = "http://52.79.108.141:5000"
    
    static let userId = UserDefaults.standard.string(forKey: "userId") ?? "ios@gmail.com"
    static let nickName = UserDefaults.standard.string(forKey: "nickname") ?? "지으니"
    static let profileName = UserDefaults.standard.string(forKey: "profileImage") ?? "https://charo-image.s3.ap-northeast-2.amazonaws.com/dummy/jieun.JPG"
    static let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? "ios@gmail.com"

    
    // MARK: - Feature URL
    ///1. 홈 데이터 URL 여기에 + 유저 아이디(111,222,333) 해줘야 함 // 일단은 111로 해놓을겡~!
    static let HomeURL = baseURL + "/post/main/" + userId
    static let CreatePostURL = baseURL + "/writePost"
    
    ///2. 더보기 뷰 URL
    static let detailURL = baseURL + "/preview/like/" + userId + "/"
    
    ///3.더보기 최신순 URL
    static let newDetailURL = baseURL + "/preview/new/" + userId + "/"
    
    ///4.
    static let ThemeLikeURL = baseURL + "/post/preview/like/\(userId)/1?value="
    static let ThemeNewURL = baseURL + "/post/preview/new/\(userId)/1?value="
    static let likeURL = baseURL + "/post/like"
    
    ///myPage
    static let myPageURL = baseURL + "/user/myPage/"
    static let myPageLikeURL = baseURL + "/user/myPage/like/" + userId
    static let myPageNewURL = baseURL + "/user/myPage/new/" + userId
    
    ///otherMyPage
    static let otherMyPageURL = baseURL + "/user/myPage/like/"
    static let otherMyPageNewURL = baseURL + "/user/myPage/new/"
    static let followURL = baseURL + "/user/follow/"
    static let followCheckURL = baseURL + "/user/follow/check?userEmail="
    static let getFollowURL = baseURL + "/user/follow?myPageEmail="
    
    ///필터 검색 결과 조회
    static let searchPostURL = baseURL + "/post/search/"
    
    /// 최근 검색 결과 관련
    static let searchKeywordURL = baseURL + "/post/readHistory/" + userEmail
    static let saveSearchedHistory = baseURL + "/post/saveHistory"

    /// 게시물 상세보기
    static let detailPostURL = baseURL + "/post/detail/" + userEmail + "/"
    static let detailPostLikeListURL = baseURL + "/post/likes/"
    
    /// 저장하기
    static let saveURL = baseURL + "/post/save"
    
    //- 이메일 중복체크, 인증, 닉네임 중복체크
    static let duplicateEmailURL = baseURL + "/user/check/email/"
    static let validateEmailURL = baseURL + "/user/auth"
    static let duplicateNicknameURL = baseURL + "/user/check/nickname/"
    
    //회원가입, 로그인, 소셜로그인
    static let JoinURL = baseURL + "/user/register"
    static let loginURL = baseURL + "/user/login"
    static let snsLoginURL = baseURL + "/user/socialLogin"
    
    //카카오, 구글, 애플 로그인
    static let kakaoLoginURL = baseURL + "/user/register/kakao"
    static let googleLoginURL = baseURL + "/user/register/google"
    static let appleLoginURL = baseURL + "/user/register/apple"
    
    //비밀번호, 프로필 수정
    static let updatePassword = baseURL + "/user/password?"
    static let updateProfile = baseURL + "/user/"
    static let findPassword = baseURL + "/user/password/"
    /// 알림
    static let notificationListURL = baseURL + "/push/"
}
