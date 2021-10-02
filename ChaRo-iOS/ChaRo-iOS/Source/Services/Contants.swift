//
//  Contants.swift
//  ChaRo-iOS
//
//  Created by 서강준 on 2021/07/12.
//

import Foundation

struct Constants {
    
    // MARK: - BASE URL
    static let baseURL = "http://charo-server.o-r.kr"
    
    static let userId = UserDefaults.standard.string(forKey: "userId") ?? "ios@gmail.com"
    static let nickName = UserDefaults.standard.string(forKey: "nickname") ?? "지으니"
    static let profileName = UserDefaults.standard.string(forKey: "profileImage") ?? "https://charo-image.s3.ap-northeast-2.amazonaws.com/dummy/jieun.JPG"

    
    // MARK: - Feature URL
    ///1. 홈 데이터 URL 여기에 + 유저 아이디(111,222,333) 해줘야 함 // 일단은 111로 해놓을겡~!
    static let HomeURL = baseURL + "/post/main/" + userId
    static let CreatePostURL = baseURL + "/writePost"
    
    ///2. 더보기 뷰 URL
    static let detailURL = baseURL + "/preview/like/" + userId + "/"
    
    ///3.더보기 최신순 URL
    static let newDetailURL = baseURL + "/preview/new/" + userId + "/"
    
    ///4.
    static let ThemeLikeURL = baseURL + "/preview/like/\(userId)/1?value="
    static let ThemeNewURL = baseURL + "/preview/new/\(userId)/1?value="
    static let likeURL = baseURL + "/post/like"
    
    static let myPageLikeURL = baseURL + "/user/myPage/like/" + userId
    static let myPageNewURL = baseURL + "/myPage/new/" + userId
    
    
    ///필터 검색 결과 조회
    static let searchPostURL = baseURL + "/search/"
    
    /// 최근 검색 결과 관련
    static let searchKeywordURL = baseURL + "/searchHistory"

    /// 게시물 상세보기
    static let detailPostURL = baseURL + "/postDetail/" + userId + "/"
    
    static let loginURL = baseURL + "/sign/signIn"
    
    /// 저장하기
    static let saveURL = baseURL + "/post/save"
}
