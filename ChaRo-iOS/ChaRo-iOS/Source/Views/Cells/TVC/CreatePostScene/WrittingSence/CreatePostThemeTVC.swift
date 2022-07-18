//
//  CreatePostThemeTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/13.
//

import UIKit

import SnapKit
import Then

final class CreatePostThemeTVC: UITableViewCell {

    // MARK: Properties

    // cell height 동적으로 계산
    private let buttonWidth: CGFloat = (UIScreen.getDeviceWidth()-52) / 3
    private let heightRatio: CGFloat = 42/108
    func setDynamicHeight() -> CGFloat {

        let buttonHeight: CGFloat = buttonWidth * heightRatio
        let fixedHeight: CGFloat = 38 + 12 + 33 // 기본 여백, 타이틀 높이
        let dynamicHeight: CGFloat = buttonHeight
        
        return fixedHeight+dynamicHeight
    }
    
    // 데이터 전달 closeur
    var tapSetThemeButtonAction : (() -> ())?

    private var textFieldList: [UITextField] = []
    private var currentIndex = 0 // 현재 선택된 component
    private var filterData = FilterDatas() //pickerview에 표시 될 list data model
    private var currentList: [String] = [] //pickerview에 표시 될 List
    private var filterList: [String] = ["","",""]
    private var pickerSelectFlag: Bool = false


    // MARK: UI

    private let courseTitleView = PostCellTitleView(title: "테마", subTitle: "드라이브 코스를 표현할 수 있는 키워드를 선택해주세요. (최대 3개)")

    private let themeFirstButton = UIButton().then {
        $0.setImage(ImageLiterals.icUnselect, for: .normal)
    }
    
    private let themeSecondButton = UIButton().then {
        $0.setImage(ImageLiterals.icUnselect, for: .normal)
    }
    
    private let themeThirdButton = UIButton().then {
        $0.setImage(ImageLiterals.icUnselect, for: .normal)
    }
    
    private let themeFirstField = UITextField().then {
        $0.tag = 0
        $0.text = "테마 1"
    }
    
    private let themeSecondField = UITextField().then {
        $0.tag = 1
        $0.text = "테마 2"
    }
    
    private let themeThirdField = UITextField().then {
        $0.tag = 2
        $0.text = "테마 3"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureLayout()
        self.initTextField()
        self.addTextFieldAction()
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
    
    private func addTextFieldAction() {
        self.themeFirstField.addTarget(self, action: #selector(clikedTextField), for: .allEvents)
        self.themeSecondField.addTarget(self, action: #selector(clikedTextField), for: .allEvents)
        self.themeThirdField.addTarget(self, action: #selector(clikedTextField), for: .allEvents)
        
        self.bringSubviewToFront(self.themeFirstField)
        self.bringSubviewToFront(self.themeSecondField)
        self.bringSubviewToFront(self.themeThirdField)
    }
}


// MARK: - Custom Methods

extension CreatePostThemeTVC {
    @objc func clikedTextField(_ sender: UITextField) {
        sender.resignFirstResponder()
        self.tapSetThemeButtonAction?()
    }
    
    func configureThemeData(themeList: [String]) {
        guard themeList.isEmpty == false else { return }
        if themeList[0].count > 0 && themeList[0] != "선택안함" {
            self.themeFirstField.text = themeList[0]
            self.themeFirstField.textColor = .mainBlue
            self.themeFirstButton.setImage(ImageLiterals.icThemeSelected, for: .normal)
        } else {
            self.themeFirstField.text = "테마 1"
            self.themeFirstField.textColor = .gray40
            self.themeFirstButton.setImage(ImageLiterals.icUnselect, for: .normal)
        }
        if themeList[1].count > 0 && themeList[1] != "선택안함" {
            self.themeSecondField.text = themeList[1]
            self.themeSecondField.textColor = .mainBlue
            self.themeSecondButton.setImage(ImageLiterals.icThemeSelected, for: .normal)
        } else {
            self.themeSecondField.text = "테마 2"
            self.themeSecondField.textColor = .gray40
            self.themeSecondButton.setImage(ImageLiterals.icUnselect, for: .normal)
        }
        if themeList[2].count > 0 && themeList[2] != "선택안함"{
            self.themeThirdField.text = themeList[2]
            self.themeThirdField.textColor = .mainBlue
            self.themeThirdButton.setImage(ImageLiterals.icThemeSelected, for: .normal)
        } else {
            self.themeThirdField.text = "테마 3"
            self.themeThirdField.textColor = .gray40
            self.themeThirdButton.setImage(ImageLiterals.icUnselect, for: .normal)
        }
    }
}


// MARK: - Layout
extension CreatePostThemeTVC {

    private func configureLayout() {
        self.addSubviews([
            self.courseTitleView,
            self.themeFirstField,
            self.themeSecondField,
            self.themeThirdField,
            self.themeFirstButton,
            self.themeSecondButton,
            self.themeThirdButton
        ])
        
        let textWidth: CGFloat = 65
        
        self.courseTitleView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(38)
        }
        
        self.themeFirstButton.snp.makeConstraints{
            $0.top.equalTo(self.courseTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.width.equalTo(self.buttonWidth)
            $0.height.equalTo(self.themeFirstButton.snp.width).multipliedBy(heightRatio)
        }
        
        self.themeSecondButton.snp.makeConstraints{
            $0.top.equalTo(self.courseTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(self.themeFirstButton.snp.trailing).offset(6)
            $0.width.equalTo(self.buttonWidth)
            $0.height.equalTo(self.themeSecondButton.snp.width).multipliedBy(heightRatio)
        }
        
        self.themeThirdButton.snp.makeConstraints{
            $0.top.equalTo(self.courseTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(self.themeSecondButton.snp.trailing).offset(6)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.width.equalTo(self.buttonWidth)
            $0.height.equalTo(self.themeThirdButton.snp.width).multipliedBy(heightRatio)
        }
        
        self.themeFirstField.snp.makeConstraints{
            $0.height.equalTo(21)
            $0.leading.equalTo(self.themeFirstButton.snp.leading).offset(12)
            $0.width.equalTo(textWidth)
            $0.centerY.equalTo(self.themeFirstButton.snp.centerY)
        }
        
        self.themeSecondField.snp.makeConstraints{
            $0.height.equalTo(21)
            $0.leading.equalTo(self.themeSecondButton.snp.leading).offset(12)
            $0.width.equalTo(textWidth)
            $0.centerY.equalTo(self.themeSecondButton.snp.centerY)
        }
        
        self.themeThirdField.snp.makeConstraints{
            $0.height.equalTo(21)
            $0.leading.equalTo(self.themeThirdButton.snp.leading).offset(12)
            $0.width.equalTo(textWidth)
            $0.centerY.equalTo(self.themeThirdButton.snp.centerY)
        }
    }
}
