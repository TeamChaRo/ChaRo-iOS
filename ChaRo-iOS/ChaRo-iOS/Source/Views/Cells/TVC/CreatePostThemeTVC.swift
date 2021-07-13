//
//  CreatePostThemeTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/13.
//

import UIKit

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
    
    private let themeFirstLabel: UILabel = {
        let label = UILabel()
        label.text = "테마 1"
        label.font = UIFont.notoSansMediumFont(ofSize: 14)
        label.textColor = UIColor.gray40
        return label
    }()
    
    private let themeSecondLabel: UILabel = {
        let label = UILabel()
        label.text = "테마 2"
        label.font = UIFont.notoSansMediumFont(ofSize: 14)
        label.textColor = UIColor.gray40
        return label
    }()
    
    private let themeThirdLabel: UILabel = {
        let label = UILabel()
        label.text = "테마 3"
        label.font = UIFont.notoSansMediumFont(ofSize: 14)
        label.textColor = UIColor.gray40
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CreatePostThemeTVC{
    // MARK: Layout
}
