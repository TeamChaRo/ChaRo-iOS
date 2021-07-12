//
//  Extension+UIColor.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/06/29.
//

import UIKit


extension UIColor {
    
    @nonobjc class var white: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    
    @nonobjc class var gray10: UIColor {
        return UIColor(red: 248.0 / 255.0, green: 249.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray20: UIColor {
        return UIColor(red: 221.0 / 255.0, green: 226 / 255.0, blue: 229 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray30: UIColor {
        return UIColor(red: 172.0 / 255.0, green: 181.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray40: UIColor {
        return UIColor(red: 136.0 / 255.0, green: 144.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gray50: UIColor {
        return UIColor(red: 73.0 / 255.0, green: 80.0 / 255.0, blue: 87.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var mainOrange: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 130.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var mainMint: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 138 / 255.0, blue: 123 / 255.0, alpha: 1.0)
    }
    
    
    @nonobjc class var mainBlue: UIColor {
        return UIColor(red: 15.0 / 255.0, green: 111.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var mainlightBlue: UIColor {
        return UIColor(red: 157.0 / 255.0, green: 195.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var mainDeepBlue: UIColor {
        return UIColor(red: 23.0 / 255.0, green: 33.0 / 255.0, blue: 188.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var mainBlack: UIColor {
        return UIColor(red: 33.0 / 255.0, green: 36.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        var hexFormatted: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: CGFloat(1.0))
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
