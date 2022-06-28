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

import CommonCrypto

public class SdkCrypto {
    public static let shared = SdkCrypto()
    
    let iteration : Int
    var seed : Data = Data()
    var iv : Data?
    
    init() {
        self.iteration = 10000
    }
    
    func createSeed() -> Data? {
        guard let appId = Bundle.main.bundleIdentifier else {
            SdkLog.e("Invalid AppId")
            return nil
        }
        guard let seed = self.sha256(string: appId), seed.count == 32 else {
            SdkLog.e("Invalid Seed")
            return nil
        }
        return seed
    }
    
    func key() -> Data? {
        if let seed = createSeed() {
            self.seed = seed
            //SdkLog.d("seed: \(self.seed)")
            
            guard seed.count == 32 else {
                SdkLog.e("invalid seed length.")
                return nil
            }
            self.iv = seed.subdata(in: 0..<16)
            //SdkLog.d("iv: \(self.iv?.hexEncodedString() ?? "iv is nil?")")
        }
        else { return nil }
        
        guard let venderId = UIDevice.current.identifierForVendor?.uuidString else {
            SdkLog.e("venderId is nil.")
            return nil
        }
        //SdkLog.d("venderId: \(venderId)")
        
        let password = "SDK-\(venderId)"
        let salt =  seed.subdata(in: 16..<seed.count)
        //SdkLog.d("salt: \(salt.hexEncodedString())")
        
        return pbkdf2(algorithm: CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256), password: password, salt: salt, keyByteCount: size_t(kCCKeySizeAES256), rounds: self.iteration)
    }
    
//for test
//    public func encrypt(string: String) -> Data? {
//        return self.encrypt(data: string.data(using: .utf8))
//    }
    
//    public func decrypt(data: Data?) -> String? {
//        guard let decryptedData = self.decrypt(data: data) else { return nil }
//        return String(bytes: decryptedData, encoding: .utf8)
//    }
    
    public func encrypt(data: Data?) -> Data? {
        return crypt(data: data,
                     key:self.key(),
                     keyLength: size_t(kCCKeySizeAES256),
                     iv:self.iv,
                     operation: CCOperation(kCCEncrypt),
                     option: CCOptions(kCCOptionPKCS7Padding))
    }
    
    public func decrypt(data: Data?) -> Data? {
        return crypt(data: data,
                     key:self.key(),
                     keyLength: size_t(kCCKeySizeAES256),
                     iv:self.iv,
                     operation: CCOperation(kCCDecrypt),
                     option: CCOptions(kCCOptionPKCS7Padding))
    }
    
    public func encryptForMigration(data: Data?) -> Data? {
        guard let venderId = UIDevice.current.identifierForVendor?.uuidString else {
            SdkLog.e("venderId is nil.")
            return nil
        }
        //SdkLog.d("venderId: \(venderId)")
        let key = self.sha256(string:"SDK-\(venderId)")
        //SdkLog.d("key: \(key?.hexEncodedString() ?? "key is nil?")")
        
        return self.encryptForMigration(data: data, key: key)
    }
    
    public func encryptForMigration(data: Data?, key: Data?) -> Data? {
        return crypt(data: data,
                     key:key,
                     keyLength: size_t(kCCKeySizeAES256),
                     iv:nil,
                     operation: CCOperation(kCCEncrypt),
                     option: CCOptions(kCCOptionECBMode|kCCOptionPKCS7Padding))
    }
    
    public func decryptForMigration(data: Data?) -> Data? {
        guard let venderId = UIDevice.current.identifierForVendor?.uuidString else {
            SdkLog.e("venderId is nil.")
            return nil
        }
        //SdkLog.d("venderId: \(venderId)")
        
        let key = self.sha256(string:"SDK-\(venderId)")
        //SdkLog.d("key: \(key?.hexEncodedString() ?? "key is nil?")")
        
        return self.decryptForMigration(data: data, key: key)
    }

    public func decryptForMigration(data: Data?, key: Data?) -> Data? {
        return crypt(data: data,
                     key:key,
                     keyLength: size_t(kCCKeySizeAES256),
                     iv:nil,
                     operation: CCOperation(kCCDecrypt),
                     option: CCOptions(kCCOptionECBMode|kCCOptionPKCS7Padding))
    }
    
    func crypt(data:Data?, key: Data?, keyLength: Int, iv: Data?, operation: CCOperation, option: CCOptions) -> Data? {

        guard let data = data else { return nil }
        //SdkLog.d("data: \(data.hexEncodedString())")
        
        guard let key = key else { return nil }
        //SdkLog.d("key: \(key.hexEncodedString())")
            
        var resultLength :size_t = 0

        let keyBytes = self.dataToBytes(data: key)
        let dataBytes = self.dataToBytes(data: data)
        let ivBytes = ( iv != nil ) ? self.dataToBytes(data:iv!) : nil
            
        let cryptLength = size_t(data.count + kCCBlockSizeAES128)
        var cryptData = Data(count:cryptLength)
        
        let cryptBytes = cryptData.withUnsafeMutableBytes { (tempBytes) -> UnsafeMutableRawPointer? in
            return UnsafeMutableRawPointer(tempBytes.bindMemory(to: UInt8.self).baseAddress)
        }
        
        let cryptStatus = CCCrypt(operation,
                            CCAlgorithm(kCCAlgorithmAES),
                            option,
                            keyBytes, keyLength,
                            ivBytes,
                            dataBytes, data.count, //data in
                            cryptBytes, cryptLength, //data out
                            &resultLength) //data move
        
        if (Int32(cryptStatus) != Int32(kCCSuccess)) {
            SdkLog.e("== operation : \(operation) -- crypt failed : \(cryptStatus)")
            return nil
        }
        
        cryptData.removeSubrange(resultLength..<cryptData.count)
        return cryptData
    }
}

///:nodoc:
extension SdkCrypto {
    public func generateCodeVerifier() -> String? {
        let uuid = UUID().uuidString
        if let codeVerifierData = self.sha512(string: uuid) {
            return self.base64(data: codeVerifierData).replacingOccurrences(of: "=", with: "")
        }
        return nil
    }
    
    func sha512(data: Data) -> Data? {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA512($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    
    func sha512(string: String) -> Data? {
        guard let data = string.data(using: String.Encoding.utf8) else {
            SdkLog.e("Invalid Seed.")
            return nil
        }
        return self.sha512(data: data)
    }
    
    public func base64(data: Data) -> String {
        return data.base64EncodedString(options: [.endLineWithCarriageReturn, .endLineWithLineFeed])
    }
    
    public func base64url(data: Data) -> String {
        let base64url = self.base64(data:data)
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64url
    }
    
    public func sha256(data: Data) -> Data? {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    
    public func sha256(string: String) -> Data? {
        guard let data = string.data(using: String.Encoding.utf8) else {
            SdkLog.e("Invalid Seed.")
            return nil
        }
        return self.sha256(data: data)
    }
}

///:nodoc:
extension SdkCrypto {
    // MARK: - Helper ---------------------------------------------------------------------------------
    
    func dataToBytes(data:Data) -> UnsafeRawPointer? {
        data.withUnsafeBytes { (dataBytes) -> UnsafeRawPointer? in
            return UnsafeRawPointer(dataBytes.bindMemory(to: UInt8.self).baseAddress)
        }
    }
    
    func pbkdf2(algorithm :CCPBKDFAlgorithm, password: String, salt: Data, keyByteCount: Int, rounds: Int) -> Data? {
        guard let passwordData = password.data(using:String.Encoding.utf8) else {
            return nil
        }
        var derivedKeyData = Data(repeating:0, count:keyByteCount)
        let count = derivedKeyData.count
        let derivationStatus = derivedKeyData.withUnsafeMutableBytes {derivedKeyBytes in
            salt.withUnsafeBytes { saltBytes in
                
                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password, passwordData.count,
                    saltBytes.bindMemory(to: UInt8.self).baseAddress, salt.count,
                    algorithm,
                    UInt32(rounds),
                    derivedKeyBytes.bindMemory(to: UInt8.self).baseAddress, count)
            }
        }
        if (derivationStatus != 0) {
            SdkLog.e("key generation failed : \(derivationStatus)")
            return nil
        }
        
        return derivedKeyData
    }
}
