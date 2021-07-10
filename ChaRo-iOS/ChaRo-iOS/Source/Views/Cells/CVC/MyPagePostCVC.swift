//
//  MyPagePostCVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/11.
//

import UIKit

class MyPagePostCVC: UICollectionViewCell {
    //titleLable 30자까지
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var stackView1: UILabel!
    @IBOutlet weak var stackView2: UILabel!
    @IBOutlet weak var stackView3: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var heartLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
