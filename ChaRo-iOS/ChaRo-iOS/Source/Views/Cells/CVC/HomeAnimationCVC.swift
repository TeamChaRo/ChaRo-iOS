//
//  HomeAnimationCVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/02.
//

import UIKit

class HomeAnimationCVC: UICollectionViewCell {
    
    
    static let identifier = "HomeAnimationCVC"
    

    @IBOutlet weak var homeAnimationView: UIView!
    @IBOutlet weak var homeAnimationTitleLabel: UILabel!
    @IBOutlet weak var homeAnimationHashtagLabel: UILabel!
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var homeTitleLabelTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTitleConsraint(){
        let topConstraint =  (Double( homeAnimationView.getDeviceHeight()) * 0.65)*0.5
        homeTitleLabelTopConstraint.constant = CGFloat(Int(topConstraint))
    }
   
    func setData(imageName : String, titleText : String, hashTagText : String){
        if let userImage = UIImage(named: imageName){
            backGroundImage.image = userImage
        }
        homeAnimationTitleLabel.text = titleText
        homeAnimationHashtagLabel.text = hashTagText
        setTitleConsraint()
        
    }
    
}
