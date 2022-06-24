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
import UIKit

public class Constants {
    static public let responseType = "code"
    
    static public let kaHeader : String = generateKaHeader()
    static func generateKaHeader() -> String {
    
        let sdkVersion = KakaoSDK.shared.sdkVersion()

        let sdkType = KakaoSDK.shared.sdkType().rawValue
        
        let osVersion = UIDevice.current.systemVersion
        
        var langCode = Locale.current.languageCode
        if (Locale.preferredLanguages.count > 0) {
            if let preferredLanguage = Locale.preferredLanguages.first {                
                if let languageCode = Locale.components(fromIdentifier:preferredLanguage)[NSLocale.Key.languageCode.rawValue] {
                    langCode = languageCode
                }
            }
        }
        let countryCode = Locale.current.regionCode
        
        let lang = "\(langCode ?? "")-\(countryCode ?? "")"
        let resX = "\(Int(UIScreen.main.bounds.width))"
        let resY = "\(Int(UIScreen.main.bounds.height))"
        let device = UIDevice.current.model.replacingOccurrences(of: " ", with: "_")
        let appBundleId = Bundle.main.bundleIdentifier
        let appVersion = self.appVersion()
        
        return "sdk/\(sdkVersion) sdk_type/\(sdkType) os/ios-\(osVersion) lang/\(lang) res/\(resX)x\(resY) device/\(device) origin/\(appBundleId ?? "") app_ver/\(appVersion ?? "")"
    }
    
    static public func appVersion() -> String? {
        var appVersion = Bundle.main.object(forInfoDictionaryKey:"CFBundleShortVersionString") as? String
        if appVersion == nil {
            appVersion = Bundle.main.object(forInfoDictionaryKey:(kCFBundleVersionKey as String)) as? String
        }
        appVersion = appVersion?.replacingOccurrences(of: " ", with: "_")
        return appVersion
    }
}

///:nodoc:
public enum SdkType : String {
    case Swift = "swift"
    case RxSwift = "rx_swift"
}

///:nodoc:
public class ApprovalType {
    public static let shared = ApprovalType()
    public var type : String?
    
    public init() {
        self.type = nil
    }
}

///:nodoc:
public enum ApiType {
    case KApi
    case KAuth
}
