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
    
    // cell height 동적으로 계산
    let buttonWidth: CGFloat = (UIScreen.getDeviceWidth()-52) / 3
    let heightRatio: CGFloat = 42/108
    func setDynamicHeight() -> CGFloat {

        let buttonHeight: CGFloat = buttonWidth * heightRatio
        let fixedHeight: CGFloat = 38 + 12 + 33 // 기본 여백, 타이틀 높이
        let dynamicHeight: CGFloat = buttonHeight
        
        return fixedHeight+dynamicHeight
    }
    
    // MARK: 데이터 전달 closeur
    public var tapSetThemeBtnAction : (() -> ())?

    private var textFieldList: [UITextField] = []
    private var currentIndex = 0 // 현재 선택된 component
    private var filterData = FilterDatas() //pickerview에 표시 될 list data model
    private var currentList: [String] = [] //pickerview에 표시 될 List
    private var filterList: [String] = ["","",""]
    private var pickerSelectFlag: Bool = false
   
    // MARK: UI Components
    private let courseTitleView = PostCellTitleView(title: "어느 테마의 드라이브였나요?", subTitle: "드라이브 테마를 한 개 이상 선택해주세요.")

    private let themeFirstButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "unselect"), for: .normal)
        return button
    }()
    
    private let themeSecondButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "unselect"), for: .normal)
        return button
    }()
    
    private let themeThirdButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "unselect"), for: .normal)
        return button
    }()
    
    private let themeFirstField: UITextField = {
        let textfield = UITextField()
        textfield.tag = 0
        textfield.text = "테마 1"
        return textfield
    }()
    
    private let themeSecondField: UITextField = {
        let textfield = UITextField()
        textfield.tag = 1
        textfield.text = "테마 2"
        return textfield
    }()
    
    private let themeThirdField: UITextField = {
        let textfield = UITextField()
        textfield.tag = 2
        textfield.text = "테마 3"
        return textfield
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        initTextField()
        setTextFieldAction()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    private func initTextField() {
        textFieldList.append(contentsOf: [themeFirstField,
                                          themeSecondField,
                                          themeThirdField])
        
        for textField in textFieldList {
            textField.textAlignment = .center
            textField.borderStyle = .none
            textField.tintColor = .clear
            textField.font = .notoSansMediumFont(ofSize: 14)
            textField.textColor = .gray40
        }
    }
    
    private func setTextFieldAction() {
        themeFirstField.addTarget(self, action: #selector(clikedTextField), for: .allEvents)
        themeSecondField.addTarget(self, action: #selector(clikedTextField), for: .allEvents)
        themeThirdField.addTarget(self, action: #selector(clikedTextField), for: .allEvents)
        
        self.bringSubviewToFront(themeFirstField)
        self.bringSubviewToFront(themeSecondField)
        self.bringSubviewToFront(themeThirdField)
    }
}

// MARK: - Custom Methods
extension CreatePostThemeTVC {
    @objc
    func clikedTextField(_ sender: UITextField) {
        tapSetThemeBtnAction?()
    }
    
    func setThemeData(themeList: [String]) {
        if !themeList.isEmpty {
            themeFirstField.text = themeList[0]
            themeSecondField.text = themeList[1]
            themeThirdField.text = themeList[2]
        }
    }
}

// MARK:- Layout (셀높이 125)
extension CreatePostThemeTVC{
    private func configureLayout() {
        addSubviews([courseTitleView, themeFirstField, themeSecondField, themeThirdField, themeFirstButton, themeSecondButton, themeThirdButton])
        
        let textWidth: CGFloat = 65
        
        courseTitleView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(38)
        }
        
        themeFirstButton.snp.makeConstraints{
            $0.top.equalTo(courseTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(themeFirstButton.snp.width).multipliedBy(heightRatio)
        }
        
        themeSecondButton.snp.makeConstraints{
            $0.top.equalTo(courseTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(themeFirstButton.snp.trailing).offset(6)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(themeSecondButton.snp.width).multipliedBy(heightRatio)
        }
        
        themeThirdButton.snp.makeConstraints{
            $0.top.equalTo(courseTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(themeSecondButton.snp.trailing).offset(6)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(themeThirdButton.snp.width).multipliedBy(heightRatio)
        }
        
        themeFirstField.snp.makeConstraints{
            $0.height.equalTo(21)
            $0.leading.equalTo(themeFirstButton.snp.leading).offset(12)
            $0.width.equalTo(textWidth)
            $0.centerY.equalTo(themeFirstButton.snp.centerY)
        }
        
        themeSecondField.snp.makeConstraints{
            $0.height.equalTo(21)
            $0.leading.equalTo(themeSecondButton.snp.leading).offset(12)
            $0.width.equalTo(textWidth)
            $0.centerY.equalTo(themeSecondButton.snp.centerY)
        }
        
        themeThirdField.snp.makeConstraints{
            $0.height.equalTo(21)
            $0.leading.equalTo(themeThirdButton.snp.leading).offset(12)
            $0.width.equalTo(textWidth)
            $0.centerY.equalTo(themeThirdButton.snp.centerY)
        }
    }
}
