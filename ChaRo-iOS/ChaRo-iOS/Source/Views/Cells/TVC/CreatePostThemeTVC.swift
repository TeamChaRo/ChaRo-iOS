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
    
    // about pickerview
    private var pickerView = UIPickerView()
    private let toolbar = UIToolbar()
    private var textFieldList: [UITextField] = []
    private var currentIndex = 0 // 현재 선택된 component (0 == city, 1 == region)
    private var filterData = FilterDatas() //pickerview에 표시 될 list data model
    private var currentList: [String] = [] //pickerview에 표시 될 List
    private var filterList : [String] = ["","",""] // pickerview 선택 완료 후에 담길 결과 배열
    
    // MARK: UI Components
    private let courseTitleView = PostCellTitleView(title: "어느 지역으로 다녀오셨나요?", subTitle: "도/광역시, 시 단위로 선택해주세요.")

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
    
    private func initTextField(){
        textFieldList.append(contentsOf: [themeFirstField,
                                          themeSecondField,
                                          themeThirdField])
        
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
        themeFirstField.addTarget(self, action: #selector(clikedTextField), for: .allEvents)
        themeSecondField.addTarget(self, action: #selector(clikedTextField), for: .allEvents)
        themeThirdField.addTarget(self, action: #selector(clikedTextField), for: .allEvents)
        
        self.bringSubviewToFront(themeFirstField)
        self.bringSubviewToFront(themeSecondField)
        self.bringSubviewToFront(themeThirdField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.endEditing(true)
    }
    
}

// MARK: - PickerView
extension CreatePostThemeTVC {
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
            themeFirstField.text = filterList[currentIndex]
            themeFirstField.textColor = .mainBlue
            themeFirstButton.setImage(UIImage(named: "select"), for: .normal)
            wasSelected()
        case 1:
            themeSecondField.text = filterList[currentIndex]
            themeSecondField.textColor = .mainBlue
            themeSecondButton.setImage(UIImage(named: "select"), for: .normal)
        case 2:
            themeThirdField.text = filterList[currentIndex]
            themeThirdField.textColor = .mainBlue
            themeThirdButton.setImage(UIImage(named: "select"), for: .normal)
        default:
            print("done error")
        }

        self.endEditing(true)
    }
    
    func wasSelected(){
        // TODO: 기존에 선택되어있으면 초기화해주는 기능 구현
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
        print(filterList[0], filterList[1], filterList[2])
        if index == 0 {
            currentList = filterData.thema
        } else if  index == 1 && filterList[0] != "" {
            currentList = filterData.thema
        } else if index == 2 && filterList[0] != "" && filterList[1] != "" {
            currentList = filterData.thema
        } else {
            self.endEditing(true)
        }
    }
    
    func changeToolbarText(index: Int){
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

extension CreatePostThemeTVC: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentList[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentList[row] != "선택안함" && currentList[row] != "" {
            filterList[currentIndex] = currentList[row]
        }
    }
}

extension CreatePostThemeTVC: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentList.count
    }
}

// MARK:- Layout (셀높이 125)
extension CreatePostThemeTVC{
    private func configureLayout(){
        addSubviews([courseTitleView, themeFirstField, themeSecondField, themeThirdField, themeFirstButton, themeSecondButton, themeThirdButton])
       
        let buttonWidth: CGFloat = (UIScreen.getDeviceWidth()-52) / 3
        let textWidth: CGFloat = 65
        let heightRatio: CGFloat = 42/108
        
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
