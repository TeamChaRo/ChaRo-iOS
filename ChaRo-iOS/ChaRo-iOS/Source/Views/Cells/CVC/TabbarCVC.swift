//
//  TabbarCVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/11.
//

import UIKit

class TabbarCVC: UICollectionViewCell {
    @IBOutlet weak var tabbarIcon: UIImageView!
    var imageName: String = "write_active.png"
    @IBOutlet weak var selectedView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setIcon(){
        tabbarIcon.image = UIImage(named: imageName)
    }
    func setBottomView(){
        selectedView.backgroundColor = .mainBlue
    }

}
