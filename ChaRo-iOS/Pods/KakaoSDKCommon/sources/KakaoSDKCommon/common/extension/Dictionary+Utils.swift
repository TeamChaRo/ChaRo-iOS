//  Copyright 2019 Kakao Corp.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

extension Dictionary {
    public var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              // ! optional unwrapping [ ]
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              // ! optional unwrapping [ ]
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
    public var urlQueryItems: [URLQueryItem]? {        
        let queryItems = self.map { (key, value) in
            URLQueryItem(name: String(describing: key),
                         value: String(describing: value))
        }
        return queryItems
    }
}

extension Dictionary where Key == String, Value == Any? {
    public func filterNil() -> [String:Any]? {
        let filteredNil = self.filter({ $0.value != nil }).mapValues({ $0! })
        return (!filteredNil.isEmpty) ? filteredNil : nil
    }
}

extension Dictionary where Key == String, Value: Any {
    public func toJsonString() -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options:[]) {
            return String(data:data, encoding: .utf8)
        }
        else {
            return nil
        }
    }
}

public extension Dictionary {
    mutating func merge(_ dictionary: [Key: Value]) {
        for (key, value) in dictionary {
            self[key] = value
        }
    }
}

