//
//  CreatePostCourseTVCTableViewCell.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/13.
//

import UIKit

class CreatePostCourseTVC: UITableViewCell {

    static let identifier: String = "CreatePostCourseTVC"
    
    // MARK: UI Components
    private let courseTitleView = PostCellTitleView(title: "어느 테마의 드라이브였나요?", subTitle: "드라이브 테마를 한 개 이상 선택해주세요.")
    
    private let cityButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let regionButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "도 단위"
        label.font = UIFont.notoSansMediumFont(ofSize: 14)
        label.textColor = UIColor.gray40
        return label
    }()
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.text = "시 단위"
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

extension CreatePostCourseTVC {
    // MARK: Layout
}
