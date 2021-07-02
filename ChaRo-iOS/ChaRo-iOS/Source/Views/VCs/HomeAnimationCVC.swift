//
//  HomeAnimationCVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/02.
//

import UIKit

class HomeAnimationCVC: UICollectionViewCell {
    
    
    static let identifier = "HomeAnimationCVC"
    
    @IBOutlet weak var roadImage: UIImageView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var homeAnimationTitleLabel: UILabel!
    @IBOutlet weak var homeAnimationHashtagLabel: UILabel!
    @IBOutlet weak var backGroundImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setConsraintCar(){
        
    }
   
    func setData(imageName : String, titleText : String, hashTagText : String){
        if let userImage = UIImage(named: imageName){
            backGroundImage.image = userImage
        }
        homeAnimationTitleLabel.text = titleText
        homeAnimationHashtagLabel.text = hashTagText
    }
    
}
