//
//  TabbarCVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/11.
//

import UIKit




class TabbarCVC: UICollectionViewCell {
    @IBOutlet weak var tabbarIcon: UIImageView!
    @IBOutlet weak var selectedView: UIView!
    static var identifier: String = "TabbarCVC"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setSelectedView() {
        selectedView.backgroundColor = UIColor.mainBlue
    }
    func setDeselectedView() {
        selectedView.backgroundColor = .none
    }
    
    func setIcon(data: String) {
        tabbarIcon.image = UIImage(named: data)
    }
    func setBottomView() {
        selectedView.backgroundColor = .mainBlue
    }

}
