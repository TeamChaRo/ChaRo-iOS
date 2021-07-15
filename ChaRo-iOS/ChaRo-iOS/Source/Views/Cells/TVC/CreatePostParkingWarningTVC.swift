//
//  CreatePostLastTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/15.
//

import UIKit

class CreatePostLastTVC: UITableViewCell {

    static let identifier: String = "CreatePostLastTVC"
    
    private let parkingTitleView = PostCellTitleView(title: "주차 공간은 어땠나요?")
    private let warningTitleView = PostCellTitleView(title: "드라이브 시 주의해야 할 사항이 있으셨나요?", subTitle: "고려해야 할 사항이 있다면 선택해주세요. 선택 사항입니다.")
    
    private let parkingExistButton: UIButton = {
        let button = UIButton()
        button.setTitle("있음", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.setEmptyTitleColor()
        button.setGray20Border(21)
        return button
    }()
    
    private let parkingNonExistButton: UIButton = {
        let button = UIButton()
        button.setTitle("없음", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.setEmptyTitleColor()
        button.setGray20Border(21)
        return button
    }()
    
    private let parkingDescTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "주차공간에 대해 적어주세요. 예) 주차장이 협소해요."
        textField.addLeftPadding(16)
        textField.textColor = .gray50
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray20.cgColor
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let highwayButton: UIButton = {
        let button = UIButton()
        button.setTitle("고속도로", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.setEmptyTitleColor(colorNum: 40)
        button.setGray20Border(21)
        return button
    }()
    
    private let mountainButton: UIButton = {
        let button = UIButton()
        button.setTitle("산길포함", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.setEmptyTitleColor(colorNum: 40)
        button.setGray20Border(21)
        return button
    }()
    
    private let beginnerButton: UIButton = {
        let button = UIButton()
        button.setTitle("초보힘듦", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.setEmptyTitleColor(colorNum: 40)
        button.setGray20Border(21)
        return button
    }()
    
    private let peopleButton: UIButton = {
        let button = UIButton()
        button.setTitle("사람많음", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.setEmptyTitleColor(colorNum: 40)
        button.setGray20Border(21)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
}


extension CreatePostLastTVC {
    
}
