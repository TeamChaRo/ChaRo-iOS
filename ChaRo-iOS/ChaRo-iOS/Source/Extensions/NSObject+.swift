//
//  NSObject.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/02/22.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
