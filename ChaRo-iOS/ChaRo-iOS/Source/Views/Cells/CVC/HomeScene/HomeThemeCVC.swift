//
//  HomeThemeCVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/04.
//

import UIKit

enum ThemeLocation {
    case HomeThemeTVC
    case ThemeTopTVC
}

class HomeThemeCVC: UICollectionViewCell {
    
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var highLightView: UIView!
    
    static let identifier = "HomeThemeCVC"
    var location: ThemeLocation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setImageView()
        
    }
    
    //선택되었을 때 글자와 border 색을 변경합니다.
    override var isSelected: Bool {
        willSet {
            if newValue {
                if location == .HomeThemeTVC {
                    
                    themeImageView.layer.borderColor = UIColor.mainBlue.cgColor
                    highLightView.backgroundColor = .mainBlue
                    themeLabel.textColor = .mainBlue
                    
                } else {
                    
                    themeImageView.layer.borderColor = UIColor.mainBlue.cgColor
                    themeImageView.layer.borderWidth = 1
                    highLightView.backgroundColor = .mainBlue
                    themeLabel.textColor = .mainBlue
                    
                }
                
            } else {
                
                if location == .HomeThemeTVC {
                    themeLabel.textColor = .gray50
                } else {
                    themeLabel.textColor = .gray40
                }
                
                themeImageView.layer.borderWidth = 0
                highLightView.backgroundColor = .white

            }
            
        }

    }
    
    
    //재사용을 위해 값을 false 로 변경합니다.
    override func prepareForReuse() {
        isSelected = false
    }
    
    
    private func setImageView() {
        themeImageView.clipsToBounds = true
        themeImageView.layer.cornerRadius = themeImageView.frame.size.height / 2
    }
    
    
    public func setThemeTitle(name: String) {
        themeLabel.text = name
    }
    
    public func setData() {
        
        
    }

}
