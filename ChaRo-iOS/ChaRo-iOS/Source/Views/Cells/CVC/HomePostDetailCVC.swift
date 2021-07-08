//
//  HomePostDetailCVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/08.
//

import UIKit

class HomePostDetailCVC: UICollectionViewCell {
    
    static let identifier : String = "HomePostDetailCVC"
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    let postCount : Int = 6
    
    
    
    func setLabel(){
        var postCountText : String = "전체 \(postCount)개 게시물"
        var selectText : String = "인기순"
        postCountLabel.text = postCountText
        selectLabel.text = selectText
        postCountLabel.textColor = UIColor.gray50
        selectLabel.textColor = UIColor.gray50
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
