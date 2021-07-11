//
//  NetworkResult.swift
//  ChaRo-iOS
//
//  Created by Jack on 2021/07/12.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
