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
    public var setThemeInfo: (([String]) -> Void)?

    
    // about pickerview
    private var pickerView = UIPickerView()
    private let toolbar = UIToolbar()
    private var textFieldList: [UITextField] = []
    private var currentIndex = 0 // 현재 선택된 component
    private var filterData = FilterDatas() //pickerview에 표시 될 list data model
    private var currentList: [String] = [] //pickerview에 표시 될 List
    private var filterList: [String] = ["","",""]{
        didSet {
            _ = setThemeInfo?(self.filterList)
        }
    }
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
        initPickerView()
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
            
            textField.inputAccessoryView = toolbar
            textField.inputView = pickerView
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

// MARK: - PickerView
extension CreatePostThemeTVC {
    private func initPickerView() {
        setPickerViewDelegate()
        createPickerViewToolbar()
    }
    
    private func setPickerViewDelegate() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    private func createPickerViewToolbar() {
        // ToolBar
        toolbar.sizeToFit()
        
        // bar button item
        let titleLabel = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.donePresseed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([titleLabel, flexibleSpace, doneButton], animated: true)

    }
    
    @objc
    func donePresseed() {
        
        if !pickerSelectFlag { didNotSelect() }
        var setText: String = filterList[currentIndex]
        
        switch currentIndex {
        case 0:
            if setText != "" {
                themeFirstField.textColor = .mainBlue
                themeFirstButton.setImage(UIImage(named: "select"), for: .normal)
            } else { setText = "테마 1" }
            themeFirstField.text = setText
        case 1:
            if setText != "" {
                themeSecondField.textColor = .mainBlue
                themeSecondButton.setImage(UIImage(named: "select"), for: .normal)
            } else { setText = "테마 2" }
            themeSecondField.text = setText
        case 2:
            if setText != "" {
                themeThirdField.textColor = .mainBlue
                themeThirdButton.setImage(UIImage(named: "select"), for: .normal)
            } else { setText = "테마 3" }
            themeThirdField.text = setText
        default:
            print("done error")
        }
        wasSelected()

        self.endEditing(true)
    }
    
    func didNotSelect() {
        switch currentIndex {
        case 0: filterList[currentIndex] = ""
        case 1: filterList[currentIndex] = ""
        case 2: filterList[currentIndex] = ""
        default: print("text set error")
        }
    }
    
    func wasSelected() {
        
        switch currentIndex {
        case 0: // 테마 1 재선택 필터링
            if filterList[currentIndex+1] != "" { // 테마2가 이미 있다는 것
                filterList[currentIndex+1] = "테마 2"
                themeSecondField.text = filterList[currentIndex+1]
                themeSecondField.textColor = .gray40
                themeSecondButton.setImage(UIImage(named: "unselect"), for: .normal)
            }
            if filterList[currentIndex+2] != "" { // 테마3이 이미 있다는 것
                filterList[currentIndex+2] = "테마 3"
                themeThirdField.text = filterList[currentIndex+2]
                themeThirdField.textColor = .gray40
                themeThirdButton.setImage(UIImage(named: "unselect"), for: .normal)
            }
        case 1: // 테마 2 재선택 필터링
            if filterList[currentIndex+1] != "" { // 테마3이 이미 있다는 것
                filterList[currentIndex+1] = "테마 3"
                themeThirdField.text = filterList[currentIndex+1]
                themeThirdField.textColor = .gray40
                themeThirdButton.setImage(UIImage(named: "unselect"), for: .normal)
            }
        default:
            print("wasSelected() error")
        }
        
        
    }

    @objc
    func clikedTextField(_ sender: UITextField) {
        
        currentIndex = sender.tag
        pickerSelectFlag = false
        pickerView.selectRow(0, inComponent: 0, animated: true)
        changeCurrentPickerData(index: currentIndex) // data 지정
        changeToolbarText(index: currentIndex) // title 지정
        pickerView.reloadComponent(0)
        
    }
    
    func changeCurrentPickerData(index: Int) {
        
        if index == 0 {
            currentList = filterData.thema
        } else if  index == 1 && filterList[0] != "" {
            currentList = filterData.thema
            let removeIdx = currentList.firstIndex(of: filterList[0])!
            currentList.remove(at: removeIdx)
        } else if index == 2 && filterList[0] != "" && filterList[1] != "" {
            currentList = filterData.thema
            let removeIdx1 = currentList.firstIndex(of: filterList[0])!
            currentList.remove(at: removeIdx1)
            let removeIdx2 = currentList.firstIndex(of: filterList[1])!
            currentList.remove(at: removeIdx2)
        } else {
            self.endEditing(true)
        }
    }
    
    func changeToolbarText(index: Int) {
        var newTitle = ""
        
        switch index {
        case 0:
            newTitle = "테마"
        default:
            newTitle = "테마"
        }
        toolbar.items![0].title = newTitle
    }
    
}

extension CreatePostThemeTVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentList[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelectFlag = true
        if currentList[row] != "선택안함" && currentList[row] != "" {
            filterList[currentIndex] = currentList[row]
        } else {
            switch currentIndex {
            case 0: filterList[currentIndex] = "테마 1"
            case 1: filterList[currentIndex] = "테마 2"
            case 2: filterList[currentIndex] = "테마 3"
            default: print("text set error")
            }
        }
    }
}

extension CreatePostThemeTVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentList.count
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
