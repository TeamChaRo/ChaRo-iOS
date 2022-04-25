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
        title: "어느 지역으로 다녀오셨나요?",
        subTitle: "도/광역시, 시 단위로 선택해주세요."
    )
    
    private let cityButton = UIButton().then {
        $0.tag = 0
        $0.setImage(UIImage(named: "unselect"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
    }
    
    private let regionButton = UIButton().then {
        $0.tag = 1
        $0.setImage(UIImage(named: "unselect"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private let cityField = UITextField().then {
        $0.tag = 0
        $0.text = "도 단위"
    }
    
    private let regionField = UITextField().then {
        $0.tag = 1
        $0.text = "시 단위"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureLayout()
        self.initTextField()
        self.initPickerView()
        self.setTextFieldAction()
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
        self.bringSubviewToFront(cityField)
        self.bringSubviewToFront(regionField)
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

        switch self.currentIndex {
        case 0:
            self.city = self.filterList[currentIndex]
            self.cityField.text = self.filterList[currentIndex]
            self.cityField.textColor = .mainBlue
            self.cityButton.setImage(UIImage(named: "select"), for: .normal)
            self.wasSelected()
        case 1:
            self.region = self.filterList[currentIndex]
            self.regionField.text = self.filterList[currentIndex]
            self.regionField.textColor = .mainBlue
            self.regionButton.setImage(UIImage(named: "select"), for: .normal)
        default:
            debugPrint("done error")
        }

        self.endEditing(true)
    }

    private func wasSelected() {
        // 기존에 선택되어있으면 2번째 애 초기화해주기
        if self.filterList[0] != "" && filterList[0] != "선택안함" {
            self.filterList[1] = "" // 뒤에 애 초기화
            self.regionField.text = "시 단위"
            self.regionField.textColor = .gray40
            self.regionButton.setImage(UIImage(named: "unselect"), for: .normal)
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
        } else if index == 1 && self.filterList[0] != "" {
            self.currentList = self.filterData.cityDict[filterList[0]]!
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
        if self.currentList[row] != "선택안함" && currentList[row] != "" {
            self.filterList[currentIndex] = self.currentList[row]
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
        self.addSubviews([
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
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(cityButton.snp.width).multipliedBy(heightRatio)
        }
        
        self.regionButton.snp.makeConstraints {
            $0.top.equalTo(themeTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(cityButton.snp.trailing).offset(6)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(regionButton.snp.width).multipliedBy(heightRatio)
        }
        
        self.cityField.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.leading.equalTo(cityButton.snp.leading).offset(12)
            $0.width.equalTo(textWidth)
            $0.centerY.equalTo(cityButton.snp.centerY)
        }
        
        self.regionField.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.leading.equalTo(regionButton.snp.leading).offset(12)
            $0.width.equalTo(textWidth)
            $0.centerY.equalTo(regionButton.snp.centerY)
        }
    }
}
