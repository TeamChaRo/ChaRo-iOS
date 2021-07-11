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
    var selectText : String = "인기순"
    var postCount: Int = 6
    var delegate: MenuClickedDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLabel()
    }

    func setLabel(){
        var countText : String = "전체 \(postCount)개 게시물"
        countLabel.text = countText
        selectLabel.text = selectText
        countLabel.textColor = UIColor.gray50
        selectLabel.textColor = UIColor.gray50
    }
    
    func setTitle(data : String) {
        print(data)
        selectText = data
        selectLabel.text = selectText
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    @IBAction func selectButtonClicked(_ sender: Any) {
        delegate?.menuClicked()
    }
    
}

extension ThemePostDetailTVC: SetTopTitleDelegate {
    func setTopTitle(name: String) {
        selectLabel.text = name
    }
    
    
}


