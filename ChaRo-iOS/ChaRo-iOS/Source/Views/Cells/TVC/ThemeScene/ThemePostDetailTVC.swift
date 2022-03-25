//
//  ThemePostDetailTVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/10.
//

import UIKit


class ThemePostDetailTVC: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    var selectText : String = "인기순"
    var postCount: Int = 0
    var delegate: MenuClickedDelegate?
    var isButtonClicked: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLabel()
    }

    func setLabel() {
        var countText : String = "전체 \(postCount)개 게시물"
        countLabel.text = countText
        selectLabel.text = selectText
        countLabel.textColor = UIColor.gray50
        selectLabel.textColor = UIColor.gray50
        selectLabel.font = .notoSansRegularFont(ofSize: 12)
        countLabel.font = .notoSansRegularFont(ofSize: 12)
        
    }
    
    func setTitle(data : String) {
        selectText = data
        selectLabel.text = selectText
    }
    
    func setPostCount(data: Int) {
        self.postCount = data
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    @IBAction func selectButtonClicked(_ sender: Any) {
        delegate?.menuClicked()
        isButtonClicked = !isButtonClicked
    }
    
}

extension ThemePostDetailTVC: SetTopTitleDelegate {
    func setTopTitle(name: String) {
        selectLabel.text = name
    }
    
    
}


