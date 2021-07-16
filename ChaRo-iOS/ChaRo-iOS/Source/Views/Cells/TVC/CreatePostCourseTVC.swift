//
//  CreatePostCourseTVCTableViewCell.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/13.
//

import UIKit
import SnapKit

class CreatePostCourseTVC: UITableViewCell {
    

    static let identifier: String = "CreatePostCourseTVC"
    
    // VC로 데이터 전달
    private var city: String = ""{
        didSet{
            NotificationCenter.default.post(name: .sendNewCity, object: city)
        }
    }
    private var region: String = "" {
        didSet{
            NotificationCenter.default.post(name: .sendNewRegion, object: region)
        }
    }
    
    // cell height 동적으로 계산
    let buttonWidth: CGFloat = (UIScreen.getDeviceWidth()-52) / 3
    let heightRatio: CGFloat = 42/108
    func setDynamicHeight() -> CGFloat {
        
        let buttonHeight: CGFloat = buttonWidth * heightRatio
        let fixedHeight: CGFloat = 38 + 12 + 33 // 기본 여백, 타이틀 높이
        let dynamicHeight: CGFloat = buttonHeight
        
        return fixedHeight+dynamicHeight
    }

    // about pickerview
    private var pickerView = UIPickerView()
    private let toolbar = UIToolbar()
    private var textFieldList: [UITextField] = []
    private var currentList: [String] = [] //pickerview에 표시 될 List
    private var currentIndex = 0 // 현재 선택된 component (0 == city, 1 == region)
    private var filterData = FilterDatas() //pickerview에 표시 될 list data model
    private var filterList : [String] = ["",""] // pickerview 선택 완료 후에 담길 결과 배열
    
    // MARK: UI Components
    private let themeTitleView = PostCellTitleView(title: "어느 테마의 드라이브였나요?", subTitle: "드라이브 테마를 한 개 이상 선택해주세요.")
    
    private let cityButton: UIButton = {
        let button = UIButton()
        button.tag = 0
        button.setImage(UIImage(named: "unselect"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let regionButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.setImage(UIImage(named: "unselect"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let cityField: UITextField = {
        let textField = UITextField()
        textField.tag = 0
        textField.text = "도 단위"
        return textField
    }()
    
    private let regionField: UITextField = {
        let textField = UITextField()
        textField.tag = 1
        textField.text = "시 단위"
        return textField
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        initTextField()
        initPickerView()
        setTextFieldAction()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    private func initTextField(){
        textFieldList.append(contentsOf: [cityField,
                                          regionField])
        
        for textField in textFieldList{
            
            textField.textAlignment = .center
            textField.borderStyle = .none
            textField.tintColor = .clear
            textField.font = .notoSansMediumFont(ofSize: 14)
            textField.textColor = .gray40
            
            textField.inputAccessoryView = toolbar
            textField.inputView = pickerView
        }
    }
    
    private func setTextFieldAction(){
        cityField.addTarget(self, action: #selector(clikedTextField), for: .allEvents)
        regionField.addTarget(self, action: #selector(clikedTextField), for: .allEvents)
        self.bringSubviewToFront(cityField)
        self.bringSubviewToFront(regionField)
    }
    
}

// MARK: - PickerView
extension CreatePostCourseTVC {
    private func initPickerView(){
        setPickerViewDelegate()
        createPickerViewToolbar()
    }
    
    private func setPickerViewDelegate(){
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    private func createPickerViewToolbar(){
        // ToolBar
        toolbar.sizeToFit()
        
        // bar button item
        let titleLabel = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.donePresseed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([titleLabel, flexibleSpace, doneButton], animated: true)

    }
    
    @objc
    func donePresseed(){

        switch currentIndex {
        case 0:
            city = filterList[currentIndex]
            cityField.text = filterList[currentIndex]
            cityField.textColor = .mainBlue
            cityButton.setImage(UIImage(named: "select"), for: .normal)
            wasSelected()
        case 1:
            region = filterList[currentIndex]
            regionField.text = filterList[currentIndex]
            regionField.textColor = .mainBlue
            regionButton.setImage(UIImage(named: "select"), for: .normal)
        default:
            print("done error")
        }
        
        

        self.endEditing(true)
    }
    
    func wasSelected(){
        // 기존에 선택되어있으면 2번째 애 초기화해주기
        if filterList[0] != "" && filterList[0] != "선택안함" {
            filterList[1] = "" // 뒤에 애 초기화
            regionField.text = "시 단위"
            regionField.textColor = .gray40
            regionButton.setImage(UIImage(named: "unselect"), for: .normal)
        }
    }
    

    @objc
    func clikedTextField(_ sender: UITextField){
        
        currentIndex = sender.tag
        pickerView.selectRow(0, inComponent: 0, animated: true)
        changeCurrentPickerData(index: currentIndex) // data 지정
        changeToolbarText(index: currentIndex) // title 지정
        pickerView.reloadComponent(0)
        
    }
    
    func changeCurrentPickerData(index : Int){
        
        if index == 0 {
            currentList = filterData.state
        } else if  index == 1 && filterList[0] != "" {
            currentList = filterData.cityDict[filterList[0]]!
        } else { // 도 선택 없이 시를 눌렀을 때
            self.endEditing(true)
        }
        
    }
    
    func changeToolbarText(index: Int){
        var newTitle = ""
        
        switch index {
        case 0:
            newTitle = "지역(도)"
        default:
            newTitle = "지역(시)"
        }

        toolbar.items![0].title = newTitle
    }
    
}

extension CreatePostCourseTVC: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentList[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentList[row] != "선택안함" && currentList[row] != "" {
            filterList[currentIndex] = currentList[row]
        }
    }
}

extension CreatePostCourseTVC: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentList.count
    }
}

// MARK:- Layout (셀높이 125)
extension CreatePostCourseTVC {
    
    private func configureLayout(){
        addSubviews([themeTitleView, cityField, regionField, regionButton, cityButton])
        
        let textWidth: CGFloat = 65
        
        themeTitleView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(38)
        }
        
        cityButton.snp.makeConstraints{
            $0.top.equalTo(themeTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(cityButton.snp.width).multipliedBy(heightRatio)
        }
        
        regionButton.snp.makeConstraints{
            $0.top.equalTo(themeTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(cityButton.snp.trailing).offset(6)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(regionButton.snp.width).multipliedBy(heightRatio)
        }
        
        cityField.snp.makeConstraints{
            $0.height.equalTo(21)
            $0.leading.equalTo(cityButton.snp.leading).offset(12)
            $0.width.equalTo(textWidth)
            $0.centerY.equalTo(cityButton.snp.centerY)
        }
        
        regionField.snp.makeConstraints{
            $0.height.equalTo(21)
            $0.leading.equalTo(regionButton.snp.leading).offset(12)
            $0.width.equalTo(textWidth)
            $0.centerY.equalTo(regionButton.snp.centerY)
        }
        
    }
}
