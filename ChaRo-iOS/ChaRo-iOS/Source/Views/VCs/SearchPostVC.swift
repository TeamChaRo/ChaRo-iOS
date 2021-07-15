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
    private var textFieldList: [UITextField] = []
    private var imageViewList: [UIImageView] = []
    private var filterData = FilterDatas()
    private var currentList: [String] = []
    private var filterList : [String] = ["","","",""]
    
    
    //MARK: Component
    lazy private var backButton = XmarkDismissButton(toDismiss: self)
    private let titleLabel = NavigationTitleLabel(title: "드라이브 맞춤 검색", color: .white)
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "searchBackground"))
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
    
    private let fileterView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "searchBackgroundWhite"))
        view.contentMode = .scaleToFill
        return view
    }()
    
    private let filterTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 드라이브는"
        label.font = .notoSansBoldFont(ofSize: 19)
        label.textColor = .gray50
        return label
    }()
    
    
    private let stateImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "searchBtnUnselect"))
        return imageView
    }()
    
    private let stateTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 0
        textField.text = "지역"
        return textField
    }()
    
    private let cityImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "searchBtnUnselect"))
        return imageView
    }()
    
    private let cityTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 1
        textField.text = "지역"
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansMediumFont(ofSize: 17)
        label.textColor = .gray50
        label.text = "에 있는"
        return label
    }()
    
    private let themaImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "searchBtnUnselect"))
        return imageView
    }()
    
    private var themaTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 2
        textField.text = "테마"
        return textField
    }()
    
    private var testTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gray40
        return textField
    }()
    
    private let themaLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansMediumFont(ofSize: 17)
        label.textColor = .gray50
        label.text = "에 어울리는 코스로"
        return label
    }()
    
    private let cautionImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "searchBtnUnselect"))
        return imageView
    }()
    
    private let cautionTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 3
        textField.text = "주의사항"
        return textField
    }()
    
    private let cautionLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansMediumFont(ofSize: 17)
        label.textColor = .gray50
        label.text = "은 피하고 싶어요"
        return label
    }()
    
    private let findButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setBackgroundImage(UIImage(named: "searchBtnWhite"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.setTitle("찾아보기", for: .normal)
        button.setTitleColor(.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(pushNextVC), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setConstraints()
        initPickerView()
        initImageViewList()
        initTextFieldList()
    }
    
    @objc func pushNextVC(){
        let storyboard = UIStoryboard(name: "SearchResult", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(identifier: SearchResultVC.identifier)as? SearchResultVC else {
            return
        }
        nextVC.setFilterTagList(list: filterList)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

//MARK: TextField
extension SearchPostVC {
    private func initTextFieldList(){
        textFieldList.append(contentsOf: [stateTextField,
                                          cityTextField,
                                          themaTextField,
                                          cautionTextField])
        
        for textField in textFieldList{
            textField.textAlignment = .center
            textField.borderStyle = .none
            textField.tintColor = .clear
            textField.addRightPadding(10)
            textField.font = .notoSansMediumFont(ofSize: 14)
            textField.textColor = .gray40
            textField.addTarget(self, action: #selector(clickedTextField), for: .touchDown)
            textField.inputAccessoryView = toolbar
            textField.inputView = pickerView
        }
    }
    
    private func initImageViewList(){
        imageViewList.append(contentsOf: [stateImageView,
                                          cityImageView,
                                          themaImageView,
                                          cautionImageView])
    }
    
    @objc func clickedTextField(_ sender : UITextField){
        currentIndex = sender.tag
        print("currentIndex = \(currentIndex)")
        pickerView.selectRow(0, inComponent: 0, animated: true)
        changeCurrentPickerData(index: currentIndex)
        
        changeToolbarText(index: currentIndex)
        pickerView.reloadComponent(0)
    }


    func changeFilterActive(index: Int){
        imageViewList[index].image = UIImage(named: "searchBtnSelect")
        textFieldList[index].text = filterList[index]
        textFieldList[index].textColor = .mainBlue
    }
    
    func changeCityFilterUnactive(){
        textFieldList[1].isUserInteractionEnabled = false
        imageViewList[1].image = UIImage(named: "searchBtnUnselect")
        textFieldList[1].text = "지역"
        textFieldList[1].textColor = .gray40
        filterList[1] = ""
    }
    
 
    func canChangeActiveMode() -> Bool{
        print(filterList)
        for index in 0..<filterList.count{
            if index == 0 && filterList[1] != ""{
                return true
            }else if index != 0{
                if filterList[index] != "" && filterList[index] != "선택안함"{
                    print("이 값은 OK = \(filterList[index]), index = \(index)")
                    return true
                }
            }
            
            //4가지 값중 1하나로 들어간 경우
            
        }
    
        return false
    }
    
//    func isCheckWhenClickedState() -> Bool{
//
//        for index in 0..<filterList.count{
//            print("현재보는 값 = \(filterList[index]), index = \(index)")
//            if index == 0 && filterList[index] != "선택안함"{
//                return true
//            }
//            if filterList[index] != "" && filterList[index] != "선택안함"{
//                print("이 값은 OK = \(filterList[index]), index = \(index)")
//                return true
//            }
//        }
//        return false
//    }
    
    func isCheckWhenStateNonValue(){
        
        if filterList[1] == ""{
            textFieldList[1].isUserInteractionEnabled = true
        }
        
        if filterList[0] == "선택안함"{
            changeCityFilterUnactive()
        }
        
//        if isCheckWhenClickedState(){
//            changeFindButtonToActive()
//        }else{
//            changeFindButtonToUnactive()
//        }
    }
    
    func changeFindButtonToActive(){
        findButton.isUserInteractionEnabled = true
        findButton.setBackgroundImage(UIImage(named: "searchBtnBlue"), for: .normal)
        findButton.setTitleColor(.white, for: .normal)
    }
    
    func changeFindButtonToUnactive(){
        findButton.isUserInteractionEnabled = false
        findButton.setBackgroundImage(UIImage(named: "searchBtnWhite"), for: .normal)
        findButton.setTitleColor(.mainBlue, for: .normal)
    }
    
    
}


//MARK: PickerView
extension SearchPostVC {
    private func initPickerView(){
        setPickerViewDelegate()
        createPickerViewToolbar()
    }
    
    private func setPickerViewDelegate(){
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    private func createPickerViewToolbar(){
        //toolbar
        toolbar.sizeToFit()
        
        //bar button item
        let titleLabel = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: nil, action: #selector(donePresseed))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.setItems([titleLabel, flexibleSpace, doneButton], animated: true)
    }
    
    @objc func donePresseed(){
        
        if canChangeActiveMode(){
            changeFindButtonToActive()
        }else{
            changeFindButtonToUnactive()
        }
        
        changeFilterActive(index: currentIndex)
    
        if currentIndex == 0{
            isCheckWhenStateNonValue()
        }
        
        self.view.endEditing(true)
    }
    
    private func changeCurrentPickerData(index : Int){
        switch index {
        case 0:
            currentList = filterData.state
        case 1:
            currentList = filterData.cityDict[filterList[0]]!
        case 2:
            currentList = filterData.thema
        default:
            currentList = filterData.caution
        }
        
        filterList[index] = currentList[0]
    }
    
    
    private func changeToolbarText(index: Int){
       var newTitle = ""
        switch index {
        case 2:
            newTitle = "테마"
        case 3:
            newTitle = "주의사항"
        default:
            newTitle = "지역"
        }
        toolbar.items![0].title = newTitle
    }

}

extension SearchPostVC: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentList[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currentList[row])
        if row == 0 {
            filterList[currentIndex] = currentList[0]
        }else{
            filterList[currentIndex] = currentList[row-1]
            filterList[currentIndex] = currentList[row]
        }
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
                          fileterView,
                          findButton])
        
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
            $0.top.equalTo(userSubLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(7)
        }
    
        findButton.snp.makeConstraints{
            $0.top.equalTo(fileterView.snp.top).offset(286)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        setConstraintsInFileterView()
    }
    
    func setConstraintsInFileterView(){
        fileterView.addSubviews([filterTitleLabel])
        
        filterTitleLabel.snp.makeConstraints{
            $0.top.equalTo(fileterView.snp.top).offset(48)
            $0.leading.equalTo(fileterView.snp.leading).offset(33)
        }
        
        setStateConstraints()
        setThemaConstraints()
        setCautionConstraints()
    }
    
    func setStateConstraints(){
        fileterView.addSubviews([stateImageView,
                                 stateTextField,
                                 cityImageView,
                                 cityTextField,
                                 cityLabel])
        
        stateImageView.snp.makeConstraints{
            $0.top.equalTo(filterTitleLabel.snp.bottom).offset(11)
            $0.leading.equalTo(fileterView.snp.leading).offset(22)
        }
        
        view.addSubview(stateTextField)
        stateTextField.snp.makeConstraints{
            $0.top.equalTo(stateImageView.snp.top).offset(5)
            $0.leading.equalTo(stateImageView.snp.leading).offset(5)
            $0.height.equalTo(42)
            $0.width.equalTo(108)
        }
      
        cityImageView.snp.makeConstraints{
            $0.top.equalTo(filterTitleLabel.snp.bottom).offset(11)
            $0.leading.equalTo(stateImageView.snp.leading).offset(116)
        }
        
        view.addSubview(cityTextField)
        cityTextField.snp.makeConstraints{
            $0.top.equalTo(cityImageView.snp.top).offset(5)
            $0.leading.equalTo(cityImageView.snp.leading).offset(5)
            $0.height.equalTo(42)
            $0.width.equalTo(108)
        }
        
        cityLabel.snp.makeConstraints{
            $0.centerY.equalTo(cityImageView.snp.centerY)
            $0.leading.equalTo(cityImageView.snp.leading).offset(127)
        }
        
    }
    
    func setThemaConstraints(){
        fileterView.addSubviews([themaImageView,
                                 themaTextField,
                                 themaLabel])
        
        themaImageView.snp.makeConstraints{
            $0.top.equalTo(stateImageView.snp.top).offset(62)
            $0.centerX.equalTo(stateImageView.snp.centerX)
        }
        
        view.addSubview(themaTextField)
        themaTextField.snp.makeConstraints{
            $0.top.equalTo(themaImageView.snp.top).offset(5)
            $0.leading.equalTo(themaImageView.snp.leading).offset(5)
            $0.height.equalTo(42)
            $0.width.equalTo(108)
        }
        
        themaLabel.snp.makeConstraints{
            $0.centerY.equalTo(themaImageView.snp.centerY)
            $0.leading.equalTo(themaImageView.snp.leading).offset(127)
        }
       
    }
    
    func setCautionConstraints(){
        fileterView.addSubviews([cautionImageView,
                                 cautionTextField,
                                 cautionLabel])
        
        cautionImageView.snp.makeConstraints{
            $0.top.equalTo(themaImageView.snp.top).offset(62)
            $0.centerX.equalTo(themaImageView.snp.centerX)
        }
        
        view.addSubview(cautionTextField)
        cautionTextField.snp.makeConstraints{
            $0.top.equalTo(cautionImageView.snp.top).offset(5)
            $0.leading.equalTo(cautionImageView.snp.leading).offset(5)
            $0.height.equalTo(42)
            $0.width.equalTo(108)
        }
        
        cautionLabel.snp.makeConstraints{
            $0.centerY.equalTo(cautionImageView.snp.centerY)
            $0.leading.equalTo(cautionImageView.snp.leading).offset(127)
        }
        
    }
    
}
