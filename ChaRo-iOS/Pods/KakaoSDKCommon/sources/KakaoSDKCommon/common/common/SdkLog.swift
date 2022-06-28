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

/// :nodoc: 로그레벨입니다.
/// - verbose: Log type verbose
/// - info: Log type info
/// - debug: Log type debug
/// - warning: Log type warning
/// - error: Log type error
public enum LogEvent: String {
    case v = "[🔬]" // verbose
    case d = "[💬]" // debug
    case i = "[ℹ️]" // info
    case w = "[⚠️]" // warning
    case e = "[‼️]" // error
}

/// :nodoc: 로그레벨입니다.
public enum LogLevel : Int {
    case v = 0
    case d = 1
    case i = 2
    case w = 3
    case e = 4
}

/// :nodoc: SdkLog 클래스 입니다.
open class SdkLog {
    public static let shared = SdkLog()
    
    public let maxLogs = 10
    
    var _debugLogs = [String]()
    public var debugLogs : [String] {
        get {
            return _debugLogs
        }
    }
    
    public var debugLog : String {
        get {
            if let appVersion = Bundle.main.object(forInfoDictionaryKey:"CFBundleShortVersionString") as? String {
                return "\("==== sdk version: \(KakaoSDK.shared.sdkVersion())\n")\("==== app version: \(appVersion)\n\n\n")\(_debugLogs.joined(separator: "\n"))"
            }
            else {
                return _debugLogs.joined(separator: "\n")
            }
        }
    }
    
    public let developLoglevel : LogLevel
    public let releaseLogLevel : LogLevel
    
    public init(developLogLevel : LogLevel = LogLevel.d, releaseLogLevel: LogLevel = LogLevel.i) {
        self.developLoglevel = developLogLevel
        self.releaseLogLevel = releaseLogLevel
    }

    class var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }

    class var simpleDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd hh:mm:ssSSS"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    public func clearLog() {
        _debugLogs.removeAll()
    }

    public class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    class func sdkprint(_ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function, logEvent:LogEvent = LogEvent.e, printLogLevel: LogLevel = LogLevel.e) {
        // Only allowing in DEBUG mode
        #if DEBUG
        if (printLogLevel.rawValue >= SdkLog.shared.developLoglevel.rawValue) {
            Swift.print("\(Date().toString()) \(logEvent.rawValue)[\(SdkLog.sourceFileName(filePath: filename)) \(line):\(column)] -> \(object)")
        }
        #endif
        
        if KakaoSDK.shared.isLoggingEnable() {
            if (printLogLevel.rawValue >= SdkLog.shared.releaseLogLevel.rawValue) {
                if (SdkLog.shared._debugLogs.count >= SdkLog.shared.maxLogs) {
                    SdkLog.shared._debugLogs.removeFirst()
                }
                
                SdkLog.shared._debugLogs.append("\(Date().toSimpleString()) \(logEvent.rawValue) -> \(object)")
            }
        }
    }
    
    public class func v( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        sdkprint(object, filename: filename, line: line, column: column, funcName: funcName, logEvent: LogEvent.v, printLogLevel: LogLevel.v)
    }
    
    public class func d( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        sdkprint(object, filename: filename, line: line, column: column, funcName: funcName, logEvent: LogEvent.d, printLogLevel: LogLevel.d)
    }
    
    public class func i( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        sdkprint(object, filename: filename, line: line, column: column, funcName: funcName, logEvent: LogEvent.i, printLogLevel: LogLevel.i)
    }
    
    public class func w( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        sdkprint(object, filename: filename, line: line, column: column, funcName: funcName, logEvent: LogEvent.w, printLogLevel: LogLevel.w)
    }
    
    public class func e( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        sdkprint(object, filename: filename, line: line, column: column, funcName: funcName, logEvent: LogEvent.e, printLogLevel: LogLevel.e)
    }
}

extension Date {
    public func toString() -> String {
        return SdkLog.dateFormatter.string(from: self as Date)
    }
    
    public func toSimpleString() -> String {
        return SdkLog.simpleDateFormatter.string(from: self as Date)
    }
}
