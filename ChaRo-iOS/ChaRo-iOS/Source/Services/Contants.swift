//
//  Contants.swift
//  ChaRo-iOS
//
//  Created by 서강준 on 2021/07/12.
//

import Foundation

struct Constants {
    
    // MARK: - BASE URL
    static let baseURL = "http://3.139.62.132:5000"
    
    static let userId = "jieun1211"
    
    // MARK: - Feature URL
    ///1. 홈 데이터 URL 여기에 + 유저 아이디(111,222,333) 해줘야 함 // 일단은 111로 해놓을겡~!
    static let HomeURL = baseURL + "/getMain/" + userId
    static let CreatePostURL = baseURL + "/writePost"
    
    ///2. 더보기 뷰 URL
    static let detailURL = baseURL + "/preview/like/" + userId + "/"
    
    ///3.더보기 최신순 URL
    static let newDetailURL = baseURL + "/preview/new/" + userId + "/"
    
    ///4.
    static let ThemeLikeURL = baseURL + "/preview/like/\(userId)/1?value="
    static let ThemeNewURL = baseURL + "/preview/new/\(userId)/1?value="
    static let likeURL = baseURL + "/post/like"
    
    static let myPageLikeURL = baseURL + "/myPage/like/" + userId
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
