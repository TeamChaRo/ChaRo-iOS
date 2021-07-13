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
    
    // MARK: - Feature URL
    ///1. 홈 데이터 URL 여기에 + 유저 아이디(111,222,333) 해줘야 함 // 일단은 111로 해놓을겡~!
    static let HomeURL = baseURL + "/getMain/111"
    
    ///2. 더보기 뷰 URL
    static let detailURL = baseURL + "/preview/like/111/"
    
    ///3.더보기 최신순 URL
    static let newDetailURL = baseURL + "/preview/new/111/"
    static let searchKeywordURL = baseURL + "/searchHistory"
}
