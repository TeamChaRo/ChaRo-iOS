//
//  DateComponents+.swift
//  ChaRo-iOS
//
//  Created by hwangJi on 2022/06/13.
//

import Foundation
 
extension DateComponents {
    
    /// DateComponents를 "YYYY.MM.dd" String으로 반환하는 메서드
    public func convertDateComponentsToString() -> String {
        let date = Calendar.current.date(from: self) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        
        return dateFormatter.string(from: date)
    }
}
