//
//  SearchPostVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/11.
//

import UIKit
import SnapKit

class SearchPostVC: UIViewController {

    static let identifier = "SearchPostVC"
    private let userName = "배희진희진"
    
    //MARK: About PickerView
    private var currentIndex = 0
    private var pickerView = UIPickerView()
    private let toolbar = UIToolbar()
    private var filterData = FilterDatas()
    private var currentList: [String] = []
    private var state = ""
    
    
    //MARK: Component
    lazy private var backButton = XmarkDismissButton(toDismiss: self)
    private let titleLabel = NavigationTitleLabel(title: "드라이브 맞춤 검색", color: .white)
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "searchPostBackground"))
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansBoldFont(ofSize: 22)
        label.textColor = .white
        return label
    }()
    
    private let userSubLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansMediumFont(ofSize: 17)
        label.textColor = .white
        label.text = "맞춤 코스를 찾아 드릴게요"
        return label
    }()
    
    private let fileterView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        return view
    }()
    
    private let filterTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 드라이브는"
        label.font = .notoSansBoldFont(ofSize: 19)
        label.textColor = .gray50
        return label
    }()
    
    private let stateButton: UIButton = {
        let button = UIButton()
        button.setTitle("지역", for: .normal)
        button.setImage(UIImage(named: "iconDown"), for: .normal)
        button.imageView?.semanticContentAttribute = .forceLeftToRight
        button.backgroundColor = .yellow
        button.tag = 0
        return button
    }()
    
    private let cityTextField: UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    
    private let findButton: UIView = {
        let button = UIButton()
        button.setTitle("찾아보기", for: .normal)
        button.setTitleColor(.mainBlue, for: .normal)
        return button
    }()
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setConstraints()
        setPickerViewDelegate()
    }
    

    private func setPickerViewDelegate(){
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    private func setPickerViewIntoInputView(){
        
        pickerView.reloadComponent(0)
    }
    
    private func createDatePickerWithWhellStyle(){
        //toolbar
        toolbar.sizeToFit()
        
        //bar button item
        let titleLabel = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: nil, action: #selector(donePresseed))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.setItems([titleLabel, flexibleSpace, doneButton], animated: true)
        
//        dateTextField.inputAccessoryView = toolbar
//        dateTextField.inputView = datePicker

    }
    
    @objc private func donePresseed(){
        //dateTextField.text = getKoreaDateTime(date: datePicker.date)
        self.view.endEditing(true)
    }
 
    @objc func clickedButton(sender : UITextField){
        currentIndex = sender.tag
        print("currentIndex = \(currentIndex)")
        changeCurrentPickerData(index: currentIndex)
        pickerView.reloadComponent(0)
    }
    
    private func changeCurrentPickerData(index : Int){
        switch index {
        case 0:
            currentList = filterData.cityDict.keys as! [String]
        case 1:
            currentList = filterData.cityDict[state]!
        case 2:
            currentList = filterData.tema
        default:
            currentList = filterData.caution
        }
    }
    
}

extension SearchPostVC: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentList[row]
    }
    
}

extension SearchPostVC: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  currentList.count
    }
    
}


//MARK: UI
extension SearchPostVC {
    func setConstraints(){
        view.addSubview(backgroundImageView)
        view.addSubviews([backButton,
                          titleLabel,
                          userNameLabel,
                          userSubLabel,
                          fileterView])
        
        backgroundImageView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        backButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(1)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(7)
            $0.height.width.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(14)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        userNameLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(116)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            
        }
        
        userNameLabel.text = "\(userName)님의"
        
        userSubLabel.snp.makeConstraints{
            $0.top.equalTo(userNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        fileterView.snp.makeConstraints{
            $0.top.equalTo(userSubLabel.snp.bottom).offset(13)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(304)
        }
        
        setConstraintsInFileterView()
    }
    
    func setConstraintsInFileterView(){
        fileterView.addSubviews([filterTitleLabel,
                                 stateButton])
        
        filterTitleLabel.snp.makeConstraints{
            $0.top.equalTo(fileterView.snp.top).offset(33)
            $0.leading.equalTo(fileterView.snp.leading).offset(20)
            
        }
        
        
        stateButton.snp.makeConstraints{
            $0.top.equalTo(filterTitleLabel.snp.top).offset(28)
            $0.leading.equalTo(fileterView.snp.leading).offset(20)
            $0.height.equalTo(42)
        }
    }
}
