//
//  ImageLiterals.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/02/22.
//

import UIKit

enum ImageLiterals {
    //MARK: - icon
    static var icHeartActive: UIImage{ .load(name: "icHeartActive") }
    static var icHeartInactive: UIImage{ .load(name: "icHeartInactive") }
    static var icScrapActive: UIImage{ .load(name: "icSaveActive") }
    static var icScrapInactive: UIImage{ .load(name: "icSaveInactive") }
    static var icShare: UIImage{ .load(name: "icShare") }
    
    //MARK: - image
    
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = name
        return image
    }
    
    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
