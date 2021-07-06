//
//  CommonCVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/04.
//

import UIKit

class CommonCVC: UICollectionViewCell {

    static let identifier = "CommonCVC"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var tagView1: UIView!
    @IBOutlet weak var tagView2: UIView!
    @IBOutlet weak var tagView3: UIView!
//
//    @IBOutlet weak var tagLabel1: UILabel!
//    @IBOutlet weak var tagLabel2: UILabel!
//    @IBOutlet weak var tagLabel3: UILabel!
//


    override func awakeFromNib() {
        super.awakeFromNib()
        setTagUI()
    }
    

    func setTagUI() {
        
        tagView1.layer.cornerRadius = 10
        tagView2.layer.cornerRadius = 10
        tagView3.layer.cornerRadius = 10
        
        tagView1.layer.borderColor = UIColor.blue.cgColor
        tagView2.layer.borderColor = UIColor.blue.cgColor
        tagView3.layer.borderColor = UIColor.blue.cgColor
        
        tagView1.layer.borderWidth = 1
        tagView2.layer.borderWidth = 1
        tagView3.layer.borderWidth = 1
        
    }

}
