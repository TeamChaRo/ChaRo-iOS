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
    
    @IBOutlet weak var tagLabel1: UILabel!
    @IBOutlet weak var tagLabel2: UILabel!
    @IBOutlet weak var tagLabel3: UILabel!
    
    @IBOutlet weak var lengthBtwImgLabel: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTagUI()
        setLabelUI()
    }
    
    func setLabelUI() {
        titleLabel.font = UIFont.notoSansRegularFont(ofSize: 14)
        tagLabel1.font = UIFont.notoSansRegularFont(ofSize: 10)
        tagLabel2.font = UIFont.notoSansRegularFont(ofSize: 10)
        tagLabel3.font = UIFont.notoSansRegularFont(ofSize: 10)

        tagLabel1.textColor = UIColor.mainBlue
        tagLabel2.textColor = UIColor.mainBlue
        tagLabel3.textColor = UIColor.mainBlue
    }
    
    func setTagUI() {
        
        tagLabel1.text = "#야"
        tagLabel2.text = "#서강준"
        tagLabel3.text = "#왜불렁~"
        
        let length1 = CGFloat(tagLabel1.text!.count)
        let length2 = CGFloat(tagLabel2.text!.count)
        let length3 = CGFloat(tagLabel3.text!.count)
    
        
        tagView1.translatesAutoresizingMaskIntoConstraints = false
        tagView2.translatesAutoresizingMaskIntoConstraints = false
        tagView3.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            tagView1.widthAnchor.constraint(equalToConstant: 13 * length1),
            tagView2.widthAnchor.constraint(equalToConstant: 13 * length2),
            tagView3.widthAnchor.constraint(equalToConstant: 13 * length3)
            
        ])
        
        
        tagView1.layer.cornerRadius = 10
        tagView2.layer.cornerRadius = 10
        tagView3.layer.cornerRadius = 10
        
        tagView1.layer.borderColor = UIColor.mainBlue.cgColor
        tagView2.layer.borderColor = UIColor.mainBlue.cgColor
        tagView3.layer.borderColor = UIColor.mainBlue.cgColor
        
        tagView1.layer.borderWidth = 1
        tagView2.layer.borderWidth = 1
        tagView3.layer.borderWidth = 1
        
//        imageView.image = UIImage(named: "tempImageSmall")?.aspectFitImage(inRect: imageView.frame)
//        imageView.contentMode = .top
//        imageView.layer.cornerRadius = 10
//        imageView.clipsToBounds = true
//        
    }
    
}
