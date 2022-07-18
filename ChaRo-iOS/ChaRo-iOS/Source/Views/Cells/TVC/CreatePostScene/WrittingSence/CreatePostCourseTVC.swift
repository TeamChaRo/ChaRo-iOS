//
//  CreatePostCourseTVCTableViewCell.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/13.
//

import UIKit

import SnapKit
import Then

final class CreatePostCourseTVC: UITableViewCell {

    // MARK: Const

    private enum Const {
        static let cityPlaceholder = "도 단위"
        static let regionPlaceholder = "시 단위"
        static let unSelected = "선택안함"
    }

    // MARK: Properties

    // 데이터 전달 closeur
    var setCityInfo: ((String) -> Void)?
    var setRegionInfo: ((String) -> Void)?
    private var city: String = ""{
        didSet {
            _ = setCityInfo?(self.city)
        }
    }
    private var region: String = "" {
        didSet {
            _ = setRegionInfo?(self.region)
        }
    }
    
    // cell height 동적으로 계산
    private let buttonWidth: CGFloat = (UIScreen.getDeviceWidth()-52) / 3
    private let heightRatio: CGFloat = 42/108
    func setDynamicHeight() -> CGFloat {
        
        let buttonHeight: CGFloat = buttonWidth * heightRatio
        let fixedHeight: CGFloat = 38 + 12 + 33 // 기본 여백, 타이틀 높이
        let dynamicHeight: CGFloat = buttonHeight
        
        return fixedHeight+dynamicHeight
    }

    // pickerview properties
    private var pickerView = UIPickerView()
    private let toolbar = UIToolbar()
    private var textFieldList: [UITextField] = []
    private var currentList: [String] = [] //pickerview에 표시 될 List
    private var currentIndex = 0 // 현재 선택된 component (0 == city, 1 == region)
    private var filterData = FilterDatas() //pickerview에 표시 될 list data model
    private var filterList: [String] = ["",""] // pickerview 선택 완료 후에 담길 결과 배열


    // MARK: UI

    private let themeTitleView = PostCellTitleView(
        title: "드라이브 코스 지역",
        subTitle: "도/광역시, 시 단위로 선택해주세요."
    )
    
    private let cityButton = UIButton().then {
        $0.tag = 0
        $0.setImage(ImageLiterals.icUnselect, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
    }
    
    private let regionButton = UIButton().then {
        $0.tag = 1
        $0.setImage(ImageLiterals.icUnselect, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private let cityField = UITextField().then {
        $0.tag = 0
        $0.text = Const.cityPlaceholder
    }
    
    private let regionField = UITextField().then {
        $0.tag = 1
        $0.text = Const.regionPlaceholder
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureLayout()
        self.initTextField()
        self.initPickerView()
        self.setTextFieldAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    private func initTextField() {
        self.textFieldList.append(contentsOf: [cityField,
                                          regionField])

        self.textFieldList.map { textField in
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
        self.cityField.addTarget(self, action: #selector(clikedTextField), for: .allEvents)
        self.regionField.addTarget(self, action: #selector(clikedTextField), for: .allEvents)
        self.contentView.bringSubviewToFront(cityField)
        self.contentView.bringSubviewToFront(regionField)
    }
}


// MARK: - PickerView

extension CreatePostCourseTVC {
    private func initPickerView() {
        self.configurePickerViewDelegate()
        self.createPickerViewToolbar()
    }
    
    private func configurePickerViewDelegate() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    private func createPickerViewToolbar() {
        // ToolBar
        self.toolbar.sizeToFit()
        
        // bar button item
        let titleLabel = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.donePresseed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        self.toolbar.setItems([titleLabel, flexibleSpace, doneButton], animated: true)
    }
    
    @objc func donePresseed() {
        let selectText = self.filterList[currentIndex]

        if selectText == Const.unSelected {
            self.wasSelected()
            self.unselectStatus(index: currentIndex)
        }

        switch self.currentIndex {
        case 0:
            guard selectText != "" && selectText != Const.unSelected else { break }
            self.city = self.filterList[currentIndex]
            self.cityField.text = self.filterList[currentIndex]
            self.cityField.textColor = .mainBlue
            self.cityButton.setImage(ImageLiterals.icThemeSelected, for: .normal)
            self.wasSelected()
        case 1:
            guard selectText != "" && selectText != Const.unSelected else { break }
            self.region = self.filterList[currentIndex]
            self.regionField.text = self.filterList[currentIndex]
            self.regionField.textColor = .mainBlue
            self.regionButton.setImage(ImageLiterals.icThemeSelected, for: .normal)
        default:
            debugPrint("done error")
        }

        self.endEditing(true)
    }

    private func wasSelected() {
        // 기존에 선택되어있으면 2번째 애 초기화해주기
        if self.filterList[0] != "" && filterList[0] != Const.unSelected {
            self.filterList[1] = "" // 뒤에 애 초기화
            self.unselectStatus(index: 1)
        }
    }

    private func unselectStatus(index: Int) {
        switch index {
        case 0:
            self.cityField.text = Const.cityPlaceholder
            self.cityField.textColor = .gray40
            self.cityButton.setImage(ImageLiterals.icUnselect, for: .normal)
        case 1:
            self.regionField.text = Const.regionPlaceholder
            self.regionField.textColor = .gray40
            self.regionButton.setImage(ImageLiterals.icUnselect, for: .normal)
        default:
            return
        }
    }
    

    @objc func clikedTextField(_ sender: UITextField) {
        
        self.currentIndex = sender.tag
        self.pickerView.selectRow(0, inComponent: 0, animated: true)
        self.changeCurrentPickerData(index: currentIndex) // data 지정
        self.changeToolbarText(index: currentIndex) // title 지정
        self.pickerView.reloadComponent(0)
    }
    
    private func changeCurrentPickerData(index: Int) {
        
        if index == 0 {
            self.currentList = self.filterData.state
        } else if index == 1 && self.filterList[0] != "" && self.filterList[0] != Const.unSelected {
            self.currentList = self.filterData.cityDict[filterList[0]] ?? []
        } else { // 도 선택 없이 시를 눌렀을 때
            self.endEditing(true)
        }
    }
    
    private func changeToolbarText(index: Int) {
        var newTitle = ""
        
        switch index {
        case 0:
            newTitle = "지역(도)"
        default:
            newTitle = "지역(시)"
        }

        self.toolbar.items![0].title = newTitle
    }
    
}


// MARK: - UIPickerViewDelegate

extension CreatePostCourseTVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.currentList[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.currentList[row] != Const.unSelected && currentList[row] != "" {
            self.filterList[currentIndex] = self.currentList[row]
            return
        }

        if self.currentList[row] == Const.unSelected {
            switch self.currentIndex {
            case 0:
                self.filterList[0] = Const.unSelected
                self.filterList[1] = Const.unSelected
            case 1:
                self.filterList[1] = Const.unSelected
            default:
                return
            }
        }
    }
}


// MARK: - UIPickerViewDataSource

extension CreatePostCourseTVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.currentList.count
    }
}


// MARK: - Layout

extension CreatePostCourseTVC {
    
    private func configureLayout() {
        self.contentView.addSubviews([
            self.themeTitleView,
            self.cityField,
            self.regionField,
            self.regionButton,
            self.cityButton
        ])
        
        let textWidth: CGFloat = 65
        
        self.themeTitleView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(38)
        }
        
        self.cityButton.snp.makeConstraints {
            $0.top.equalTo(themeTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.height.equalTo(cityButton.snp.width).multipliedBy(heightRatio)
            $0.width.equalTo(buttonWidth)
        }
        
        self.regionButton.snp.makeConstraints {
            $0.top.equalTo(themeTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(cityButton.snp.trailing).offset(6)
            $0.height.equalTo(regionButton.snp.width).multipliedBy(heightRatio)
            $0.width.equalTo(buttonWidth)
        }
        
        self.cityField.snp.makeConstraints {
            $0.leading.equalTo(cityButton.snp.leading).offset(12)
            $0.centerY.equalTo(cityButton.snp.centerY)
            $0.height.equalTo(21)
            $0.width.equalTo(textWidth)
        }
        
        self.regionField.snp.makeConstraints {
            $0.leading.equalTo(regionButton.snp.leading).offset(12)
            $0.centerY.equalTo(regionButton.snp.centerY)
            $0.height.equalTo(21)
            $0.width.equalTo(textWidth)
        }
    }
}
