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
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    let postCount: Int = 6
    var delegate: MenuClickedDelegate?
    var selectText: String = "인기순"
    var isButtonClicked: Bool = false
    
    
    func setTitle(data : String) {
        selectText = data
        selectLabel.text = selectText
        
    }

    func setLabel(){
        var postCountText : String = "전체 \(postCount)개 게시물"
        postCountLabel.text = postCountText
        selectLabel.text = selectText
        postCountLabel.textColor = UIColor.gray50
        selectLabel.textColor = UIColor.gray50
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        delegate?.menuClicked()
        isButtonClicked.toggle()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLabel()
        setTitle(data: selectText)
    }

}
extension HomePostDetailCVC: SetTopTitleDelegate {
    func setTopTitle(name: String) {
        selectLabel.text = name
    }
    
    
}
