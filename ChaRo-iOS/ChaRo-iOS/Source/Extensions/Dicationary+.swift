//
//  Dicationary+.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/10/04.
//

import Foundation

extension Dictionary where Value: Equatable {
    func getKey(by value: Value) -> Key? {
        return first(where: { $1 == value })?.key
    }
}
