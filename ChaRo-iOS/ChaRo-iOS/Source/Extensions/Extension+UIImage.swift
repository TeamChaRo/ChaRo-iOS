//
//  Extension+UIImage.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/06.
//

import Foundation
import UIKit

extension UIImage {
    
    func aspectFitImage(inRect rect: CGRect) -> UIImage? {
            let width = self.size.width
            let height = self.size.height
            let aspectWidth = rect.width / width
            let aspectHeight = rect.height / height
            let scaleFactor = aspectWidth > aspectHeight ? rect.size.height / height : rect.size.width / width

            UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
            self.draw(in: CGRect(x: 0.0, y: 0.0, width: width * scaleFactor, height: height * scaleFactor))

            defer {
                UIGraphicsEndImageContext()
            }

            return UIGraphicsGetImageFromCurrentImageContext()
        }
    
}
