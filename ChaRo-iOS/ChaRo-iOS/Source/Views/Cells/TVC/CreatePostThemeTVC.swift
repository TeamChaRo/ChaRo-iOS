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
    
    private let themeFirstLabel: UITextField = {
        let textfield = UITextField()
        textfield.text = "테마 1"
        textfield.font = UIFont.notoSansMediumFont(ofSize: 14)
        textfield.textColor = UIColor.gray40
        return textfield
    }()
    
    private let themeSecondLabel: UITextField = {
        let textfield = UITextField()
        textfield.text = "테마 2"
        textfield.font = UIFont.notoSansMediumFont(ofSize: 14)
        textfield.textColor = UIColor.gray40
        return textfield
    }()
    
    private let themeThirdLabel: UITextField = {
        let label = UITextField()
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
        addSubviews([courseTitleView, themeFirstLabel, themeFirstButton, themeSecondLabel, themeSecondButton, themeThirdLabel, themeThirdButton])
    }
}
