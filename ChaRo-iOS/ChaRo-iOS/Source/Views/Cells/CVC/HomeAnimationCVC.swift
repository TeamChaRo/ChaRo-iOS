//
//  HomeAnimationCVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/02.
//

import UIKit
import Kingfisher

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
   
//    func setData(imageName : String, titleText : String, hashTagText : String){
//
//        backGroundImage.kf.setImage(with: URL(string: imageName))
//
//
//        homeAnimationTitleLabel.text = titleText
//        homeAnimationHashtagLabel.text = hashTagText
//        setTitleConsraint()
//
//    }
    
    func setData(image: String, title: String, tagText: String) {
        
        //이미지 설정
        guard let url = URL(string: image) else { return }
        self.backGroundImage.kf.setImage(with: url)
        
        //제목 설정
        self.homeAnimationTitleLabel.text = title
        
        //태그 텍스트 설정
        self.homeAnimationHashtagLabel.text = tagText
    
        setTitleConsraint()
    }
    
}
