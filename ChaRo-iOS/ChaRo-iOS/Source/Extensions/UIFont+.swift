//
//  Extension+UIFont.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/06/29.
//

import UIKit

struct AppFontName {
    static let thin = "NotoSansCJKkr-Thin"
    static let light = "NotoSansCJKkr-Light"
    static let regular = "NotoSansCJKkr-Regular"
    static let medium = "NotoSansCJKkr-Medium"
    static let bold = "NotoSansCJKkr-Bold"
    static let black = "NotoSansCJKkr-Black"
}

extension UIFont {
    
    @objc class func notoSansThinFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.thin, size: size)!
    }

    @objc class func notoSansLightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.light, size: size)!
    }
    
    @objc class func notoSansRegularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }
    
    @objc class func notoSansMediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.medium, size: size)!
    }
    
    @objc class func notoSansBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }
    
    @objc class func notoSansBlackFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.black, size: size)!
    }
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}


extension UIFont {

    @objc convenience init(myCoder aDecoder: NSCoder) {
        if let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor {
            if let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String {
                var fontName = ""
                switch fontAttribute {
                case "CTFontRegularUsage":
                    fontName = AppFontName.regular
                case "CTFontEmphasizedUsage", "CTFontBoldUsage":
                    fontName = AppFontName.bold
                case "CTFontObliqueUsage":
                    fontName = AppFontName.black
                default:
                    fontName = AppFontName.regular
                }
                self.init(name: fontName, size: fontDescriptor.pointSize)!
            }
            else {
                self.init(myCoder: aDecoder)
            }
        }
        else {
            self.init(myCoder: aDecoder)
        }
    }

     class func overrideInitialize() {
        if self == UIFont.self {
           let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:)))
           let mySystemFontMethod = class_getClassMethod(self, #selector(notoSansThinFont(ofSize:)))
           method_exchangeImplementations(systemFontMethod!, mySystemFontMethod!)

           let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:)))
           let myBoldSystemFontMethod = class_getClassMethod(self, #selector(notoSansBoldFont(ofSize:)))
           method_exchangeImplementations(boldSystemFontMethod!, myBoldSystemFontMethod!)

           let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:)))
           let myItalicSystemFontMethod = class_getClassMethod(self, #selector(notoSansBlackFont(ofSize:)))
           method_exchangeImplementations(italicSystemFontMethod!, myItalicSystemFontMethod!)

           let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))) // Trick to get over the lack of UIFont.init(coder:))
           let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:)))
           method_exchangeImplementations(initCoderMethod!, myInitCoderMethod!)
    }
  }
}
