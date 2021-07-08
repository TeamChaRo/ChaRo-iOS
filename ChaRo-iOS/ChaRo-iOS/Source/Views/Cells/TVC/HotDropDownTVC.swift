//
//  HotDropDownTVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/08.
//

import UIKit

protocol SetTitleDelegate {
    func setTitle(cell: HotDropDownTVC)
}


class HotDropDownTVC: UITableViewCell {

    @IBOutlet weak var hotLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    var delegate : SetTitleDelegate?
    var name: String = "인기순"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setLabel(){
        hotLabel.textColor = UIColor.gray50
        checkImage.isHidden = true
    }
    
    func setCellName(name: String){
        hotLabel.text = name
        self.name = name
    }
    func setSelectedCell(){
        hotLabel.textColor = UIColor.mainBlue
        checkImage.isHidden = false
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true{
            setSelectedCell()
            delegate?.setTitle(cell: self)
        }
        else {
            setLabel()
            
        }
        
    }
    
}
