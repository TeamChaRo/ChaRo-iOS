//
//  String+.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2022/04/26.
//

import Foundation

extension String {
    
    public func isOnlyHanguel() -> Bool {
        // String -> Array
        let arr = Array(self)
        // 정규식 pattern. 한글만 있어야함
        let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣ]$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            var index = 0
            while index < arr.count { // string 내 각 문자 하나하나 마다 정규식 체크 후 충족하지 못한것은 제거.
                let results = regex.matches(in: String(arr[index]), options: [], range: NSRange(location: 0, length: 1))
                if results.count == 0 {
                    return false
                } else {
                    index += 1
                }
            }
        }
        return true
    }
}
