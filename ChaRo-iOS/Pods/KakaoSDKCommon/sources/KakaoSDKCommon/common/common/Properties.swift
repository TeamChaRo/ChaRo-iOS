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

public class Properties {
    static let sdkVersionKey = "com.kakao.sdk.version"
    
    public static func saveCodable<T: Codable>(key: String, data:T?) {
        if let encoded = try? JSONEncoder().encode(data) {
            SdkLog.d("save-plain : \(encoded as NSData)")
            guard let crypted = SdkCrypto.shared.encrypt(data: encoded) else { return }
            SdkLog.d("save-crypted : \(crypted as NSData)")
            UserDefaults.standard.set(crypted, forKey:key)
            UserDefaults.standard.synchronize()
        }
    }
    
    public static func loadCodable<T: Codable>(key: String) -> T? {
        if let data = UserDefaults.standard.data(forKey: key) {
            SdkLog.d("load-crypted : \(data as NSData)")
            guard let plain = SdkCrypto.shared.decrypt(data: data) else { return nil }
            SdkLog.d("load-plain : \(plain as NSData)")
            return try? JSONDecoder().decode(T.self, from:plain)
        }
        return nil
    }
    
    public static func delete(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func save(key: String, string:String?) {
        UserDefaults.standard.set(string, forKey:key)
        UserDefaults.standard.synchronize()
    }
    
    static func load(key: String) -> String? {
        UserDefaults.standard.string(forKey:key)
    }
    
    public static func markedSdkVersion() -> String? {
        return Properties.load(key: sdkVersionKey)
    }
    
    public static func markSdkVersion() {
        Properties.save(key: Properties.sdkVersionKey, string: KakaoSDK.shared.sdkVersion())
    }
}
