//
//  HomeThemeCVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/04.
//

import UIKit


class HomeThemeCVC: UICollectionViewCell {
    
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //선택되었을 때 글자와 border 색을 변경합니다.
    override var isSelected: Bool {
        willSet {
            if newValue == false {
                themeLabel.textColor = .mainBlack
                themeImageView.layer.borderWidth = 0
                
            } else {
                themeLabel.textColor = .mainBlue
                themeImageView.layer.borderColor = UIColor.mainBlue.cgColor
                themeImageView.layer.borderWidth = 1
            }
            
        }

    }
    
    
    //재사용을 위해 값을 false 로 변경합니다.
    override func prepareForReuse() {
        isSelected = false
    }

}
