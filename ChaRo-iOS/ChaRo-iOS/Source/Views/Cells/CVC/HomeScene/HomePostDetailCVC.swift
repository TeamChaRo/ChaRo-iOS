//
//  HomePostDetailCVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/08.
//
protocol MenuClickedDelegate {
    func menuClicked()
}

import UIKit

class HomePostDetailCVC: UICollectionViewCell {
    
    
    static let identifier : String = "HomePostDetailCVC"
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    var delegate: MenuClickedDelegate?
    var selectText: String = "인기순"
    var isButtonClicked: Bool = false
    
    
    func setTitle(data : String) {
        selectLabel.text = data
    }

    
    @IBAction func menuButtonClicked(_ sender: Any) {
        delegate?.menuClicked()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(data: selectText)
    }
    
    func setSelectName(name: String){
        selectLabel.text = name
        selectText = name
        print(selectText , "이거됨?")
    }

}
extension HomePostDetailCVC: SetTopTitleDelegate {
    func setTopTitle(name: String) {
        selectLabel.text = name
    }
    
    
}
