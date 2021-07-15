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
    let buttonMultiplier: CGFloat = 248/42
    public var clickCopyButton: (() -> Void)?
    
    let locationTextField: UITextField = {
        let textField = UITextField()
        textField.background = UIImage(named: "postTextfieldLocationShow")
        textField.addLeftPadding(17)
        textField.font = .notoSansRegularFont(ofSize: 14)
        textField.isEnabled = false
        return textField
    }()
    

    let copyButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "copy1LightVer"), for: .normal)
        button.isUserInteractionEnabled = true
        button.imageView?.contentMode = .scaleToFill
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configureLayout()
        copyButton.addTarget(self, action: #selector(copyTextInClibBoard), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc
    func copyTextInClibBoard(){
        print("복사버튼 눌림")
        UIPasteboard.general.string = locationTextField.text
        clickCopyButton?()
    }
    
}

extension PostLocationTVC {
    
    func setTitleText(title: String){
        titleView.titleLabel.text = title
    }
    
    func setLocationText(address: String){
        locationTextField.text = address
    }
    
    func configureLayout(){
        addSubview(copyButton)
        addSubviews([titleView])
        addSubview(locationTextField)
        
        titleView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(10)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.centerY.equalTo(copyButton.snp.centerY)
            $0.width.equalTo(50)
        }
        
        locationTextField.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.titleView.snp.trailing).offset(3)
            $0.trailing.equalTo(copyButton.snp.leading).offset(-1)
            $0.bottom.equalTo(self.snp.bottom).offset(-8)
        }
        
        copyButton.bringSubviewToFront(self)
        copyButton.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom).offset(-6)
            $0.trailing.equalTo(self.snp.trailing).offset(-6)
            $0.width.height.equalTo(48)
        }
    }
}

