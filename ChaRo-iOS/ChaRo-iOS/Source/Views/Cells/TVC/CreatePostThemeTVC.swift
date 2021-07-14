//
//  CreatePostThemeTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/13.
//

import UIKit
import SnapKit

class CreatePostThemeTVC: UITableViewCell {

    static let identifier: String = "CreatePostThemeTVC"
    
    // MARK: UI Components
    private let courseTitleView = PostCellTitleView(title: "어느 지역으로 다녀오셨나요?", subTitle: "도/광역시, 시 단위로 선택해주세요.")

    private let themeFirstButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let themeSecondButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let themeThirdButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let themeFirstField: UITextField = {
        let textfield = UITextField()
        textfield.text = "테마 1"
        textfield.font = UIFont.notoSansMediumFont(ofSize: 14)
        textfield.textColor = UIColor.gray40
        return textfield
    }()
    
    private let themeSecondField: UITextField = {
        let textfield = UITextField()
        textfield.text = "테마 2"
        textfield.font = UIFont.notoSansMediumFont(ofSize: 14)
        textfield.textColor = UIColor.gray40
        return textfield
    }()
    
    private let themeThirdField: UITextField = {
        let textfield = UITextField()
        textfield.text = "테마 3"
        textfield.font = UIFont.notoSansMediumFont(ofSize: 14)
        textfield.textColor = UIColor.gray40
        return textfield
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
}

extension CreatePostThemeTVC{
    // MARK: Layout (셀높이 125)
    private func configureLayout(){
        addSubviews([courseTitleView, themeFirstField, themeFirstButton, themeSecondField, themeSecondButton, themeThirdField, themeThirdButton])
       
        let buttonWidth: CGFloat = (UIScreen.getDeviceWidth()-52) / 3
        let heightRatio: CGFloat = 42/108
        
        courseTitleView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(38)
        }
        
        themeFirstButton.snp.makeConstraints{
            $0.top.equalTo(12)
            $0.leading.equalTo(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(themeFirstButton.snp.width).multipliedBy(heightRatio)
        }
        
        themeSecondButton.snp.makeConstraints{
            $0.top.equalTo(12)
            $0.leading.equalTo(themeFirstButton.snp.trailing).offset(6)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(themeSecondButton.snp.width).multipliedBy(heightRatio)
        }
        
        themeThirdButton.snp.makeConstraints{
            $0.top.equalTo(12)
            $0.leading.equalTo(themeSecondButton.snp.trailing).offset(6)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(themeThirdButton.snp.width).multipliedBy(heightRatio)
        }
        
        themeFirstField.snp.makeConstraints{
            $0.height.equalTo(21)
            $0.leading.equalTo(themeFirstButton.snp.leading).offset(12)
            $0.centerY.equalTo(themeFirstButton.snp.centerY)
        }
        
        themeSecondField.snp.makeConstraints{
            $0.height.equalTo(21)
            $0.leading.equalTo(themeSecondButton.snp.leading).offset(12)
            $0.centerY.equalTo(themeSecondButton.snp.centerY)
        }
        
        themeThirdField.snp.makeConstraints{
            $0.height.equalTo(21)
            $0.leading.equalTo(themeThirdButton.snp.leading).offset(12)
            $0.centerY.equalTo(themeThirdButton.snp.centerY)
        }
    }
}
