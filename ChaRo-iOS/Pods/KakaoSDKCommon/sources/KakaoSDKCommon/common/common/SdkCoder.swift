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

public class SdkJSONEncoder : JSONEncoder {
    public static var `default`: SdkJSONEncoder { return SdkJSONEncoder() }
    public static var `custom`: SdkJSONEncoder { return SdkJSONEncoder(useCustomStrategy:true) }
    
   init(useCustomStrategy:Bool = false) {
        super.init()
        if (useCustomStrategy) {
            self.keyEncodingStrategy = .convertToSnakeCase
        }
    }
}

public class SdkJSONDecoder : JSONDecoder {
    public static var `default`: SdkJSONDecoder { return SdkJSONDecoder() }
    public static var `custom`: SdkJSONDecoder { return SdkJSONDecoder(useCustomStrategy:true) }
    public static var `customIso8601Date`: SdkJSONDecoder { return SdkJSONDecoder(useCustomStrategy:true, dateStrategy: .iso8601) }
    public static var `customSecondsSince1970`: SdkJSONDecoder { return SdkJSONDecoder(useCustomStrategy:true, dateStrategy: .secondsSince1970) }
    
    init(useCustomStrategy:Bool = false, dateStrategy: DateDecodingStrategy? = nil) {
        super.init()
        if (useCustomStrategy) {
            self.keyDecodingStrategy = .convertFromSnakeCase
        }
        if let dateStrategy = dateStrategy {
            self.dateDecodingStrategy = dateStrategy
        }
    }
}
