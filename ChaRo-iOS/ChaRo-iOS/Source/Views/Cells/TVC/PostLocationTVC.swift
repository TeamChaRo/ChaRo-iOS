//
//  PostLocationTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/08.
//

import UIKit

class PostLocationTVC: UITableViewCell {

    static let identifier: String = "PostLocationTVC"
    
    let titleView = PostCellTitleView(title: "출발지")
    
    let locationTextField: UITextField = {
        let textField = UITextField()
        textField.background = UIImage(named: "postTextfieldLocationShow")
        textField.addLeftPadding(17)
        return textField
    }()
    
    let copyButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "copyLightVer"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureLayout()
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PostLocationTVC {
    
    func setTitleText(title: String){
        titleView.titleLabel.text = title
    }
    
    func configureLayout(){
        
        addSubviews([titleView, locationTextField, copyButton])
        
        titleView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(10)
            $0.leading.equalTo(20)
            $0.width.equalTo(50)
        }
        
        locationTextField.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.titleView.snp.trailing).offset(3)
            $0.height.equalTo(42)
            $0.bottom.equalTo(self.snp.bottom).offset(8)
            
        }
        
        copyButton.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.locationTextField.snp.trailing)
            $0.bottom.equalTo(self.snp.bottom).inset(8)
            $0.trailing.equalTo(self.snp.trailing).inset(6)
        }
        
    }
}
