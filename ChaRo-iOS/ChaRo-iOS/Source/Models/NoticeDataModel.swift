//
//  NoticeDataModel.swift
//  ChaRo-iOS
//
//  Created by hwangJi on 2022/04/26.
//

import Foundation

struct NoticeDataModel {
    let title: String
    let date: DateComponents
    let content: String
    var open = false
    
    func convertDateToString(dateComponents: DateComponents) -> String {
        let date = Calendar.current.date(from: dateComponents) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        
        return dateFormatter.string(from: date)
    }
}
