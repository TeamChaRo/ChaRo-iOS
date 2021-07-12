//
//  NetworkResult.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/13.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
