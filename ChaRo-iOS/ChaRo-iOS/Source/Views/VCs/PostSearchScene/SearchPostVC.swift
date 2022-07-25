//
//  SearchPostVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/11.
//

import UIKit
import SnapKit
import Then

class SearchPostVC: UIViewController {

    private let userName = Constants.nickName
    
    //MARK: About PickerView
    private var currentIndex = 0
    private var pickerView = UIPickerView()
    private let toolbar = UIToolbar()
    private var textFieldList: [UITextField] = []
    private var imageViewList: [UIImageView] = []
    private var filterData = FilterDatas()
    private var currentList: [String] = []
    private var filterList: [String] = ["","","",""]
    private var canActiveButton = false {
        didSet { canActiveButton ? changeFindButtonToActive() : changeFindButtonToUnactive() }
    }
    
    //MARK: Component
    lazy private var backButton = XmarkDismissButton(toDismiss: self)
    private let titleLabel = NavigationTitleLabel(title: "드라이브 맞춤 검색", color: .white)
    
    private let backgroundImageView = UIImageView().then {
        $0.image = ImageLiterals.imgSearchBackground
        $0.contentMode = .scaleToFill
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = .notoSansBoldFont(ofSize: 22)
        $0.textColor = .white
    }
    
    private let userSubLabel = UILabel().then {
        $0.font = .notoSansMediumFont(ofSize: 17)
        $0.textColor = .white
        $0.text = "원하는 코스를 검색해 보세요"
    }
    
    private let fileterView = UIImageView().then {
        $0.image = ImageLiterals.imgSearchBackgroundWhite
        $0.contentMode = .scaleToFill
    }
    
    private let filterTitleLabel = UILabel().then {
        $0.text = "오늘 드라이브는"
        $0.font = .notoSansBoldFont(ofSize: 19)
        $0.textColor = .gray50
    }
    
    private let filterSubtitleLabel = UILabel().then {
        $0.text = "3가지 요소 중 하나 이상만 입력해도 검색할 수 있어요!"
        $0.font = .notoSansMediumFont(ofSize: 13)
        $0.textColor = .gray30
    }
    
    private let stateImageView = UIImageView()
    private let stateTextField = UITextField().then {
        $0.tag = 0
        $0.text = "지역"
    }
        
    private let cityImageView = UIImageView()
    private let cityTextField = UITextField().then {
        $0.tag = 1
        $0.text = "지역"
        $0.isUserInteractionEnabled = false
    }
    
    private let cityLabel = UILabel().then {
        $0.font = .notoSansMediumFont(ofSize: 17)
        $0.textColor = .gray50
        $0.text = "에 있는"
    }
    
    private let themaImageView = UIImageView()
    private var themaTextField = UITextField().then {
        $0.tag = 2
        $0.text = "테마"
    }
    
    private let themaLabel = UILabel().then {
        $0.font = .notoSansMediumFont(ofSize: 17)
        $0.textColor = .gray50
        $0.text = "에 어울리는 코스로"
    }
    
    private let cautionImageView = UIImageView()
    private let cautionTextField = UITextField().then {
        $0.tag = 3
        $0.text = "주의사항"
    }
    
    private let cautionLabel = UILabel().then {
        $0.font = .notoSansMediumFont(ofSize: 17)
        $0.textColor = .gray50
        $0.text = "은 피하고 싶어요"
    }
    
    private lazy var findButton = UIButton().then {
        $0.isUserInteractionEnabled = false
        $0.setBackgroundImage(ImageLiterals.icSearchBtnWhite, for: .normal)
        $0.titleLabel?.font = .notoSansBoldFont(ofSize: 16)
        $0.imageView?.contentMode = .scaleToFill
        $0.setTitle("검색하기", for: .normal)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.addTarget(self, action: #selector(pushNextVC), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setConstraints()
        initPickerView()
        initImageViewList()
        initTextFieldList()
    }
    
    @objc func pushNextVC() {
        let nextVC = SearchResultVC()
        refineFilterList()
        print("정제됨 -> \(filterList)")
        nextVC.setFilterTagList(list: filterList)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func refineFilterList() {
        for index in 0..<4 {
            if filterList[index] == "선택안함" { filterList[index] = "" }
        }
    }
    
}

//MARK: TextField
extension SearchPostVC {
    private func initTextFieldList() {
        textFieldList.append(contentsOf: [stateTextField,
                                          cityTextField,
                                          themaTextField,
                                          cautionTextField])
        textFieldList.forEach{
            $0.textAlignment = .center
            $0.borderStyle = .none
            $0.tintColor = .clear
            $0.addRightPadding(10)
            $0.font = .notoSansMediumFont(ofSize: 14)
            $0.textColor = .gray40
            $0.addTarget(self, action: #selector(clickedTextField), for: .touchDown)
            $0.inputAccessoryView = toolbar
            $0.inputView = pickerView
        }
    }
    
    private func initImageViewList() {
        imageViewList.append(contentsOf: [stateImageView,
                                          cityImageView,
                                          themaImageView,
                                          cautionImageView])
        
        imageViewList.forEach {
            $0.image = ImageLiterals.icSearchBtnUnselect
            $0.contentMode = .scaleToFill
        }
        
    }
    
    func changeFindButtonToActive() {
        findButton.isUserInteractionEnabled = true
        findButton.setBackgroundImage(ImageLiterals.icSearchBtnBlue, for: .normal)
        findButton.setTitleColor(.white, for: .normal)
    }
    
    func changeFindButtonToUnactive() {
        findButton.isUserInteractionEnabled = false
        findButton.setBackgroundImage(ImageLiterals.icSearchBtnWhite, for: .normal)
        findButton.setTitleColor(.mainBlue, for: .normal)
    }
    
  
    @objc func clickedTextField(_ sender: UITextField) {
        currentIndex = sender.tag
        pickerView.selectRow(0, inComponent: 0, animated: true)
        changeCurrentPickerData(index: currentIndex)
        changeToolbarText(index: currentIndex)
        pickerView.reloadComponent(0)
    }

    func changeFilterActive(index: Int) {
        imageViewList[index].image = ImageLiterals.icsearchBtnSelect
        textFieldList[index].text = filterList[index]
        textFieldList[index].textColor = .mainBlue
    }
   
    
    func observeFilterData() {
        for index in 1..<4{
            if filterList[index] != "" && filterList[index] != "선택안함"{
                print("여기서 찍힘 == \(filterList[index])")
                canActiveButton = true
                return
            }
        }
        canActiveButton = false
    }
    
    func isCheckWhenStateNonValue() -> Bool{
        if filterList[1] == ""{
            textFieldList[1].isUserInteractionEnabled = true
        }
        if filterList[0] == "선택안함"{
            changeCityFilterUnactive()
            textFieldList[0].text = "선택안함"
            print("여기 불림")
            return true
        }
        return false
    }
    
    
    func changeCityFilterUnactive() {
        textFieldList[1].isUserInteractionEnabled = false
        imageViewList[1].image = ImageLiterals.icSearchBtnUnselect
        textFieldList[1].text = "지역"
        textFieldList[1].textColor = .gray40
        filterList[1] = ""
    }
 
    
}


//MARK: PickerView
extension SearchPostVC {
    private func initPickerView() {
        setPickerViewDelegate()
        createPickerViewToolbar()
    }
    
    private func setPickerViewDelegate() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    private func createPickerViewToolbar() {
        toolbar.sizeToFit()
        let titleLabel = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: nil, action: #selector(donePresseed))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([titleLabel, flexibleSpace, doneButton], animated: true)
    }
    
    @objc func donePresseed() {
        if currentIndex == 0{
            if isCheckWhenStateNonValue() {
                observeFilterData()
                self.view.endEditing(true)
                return
            }
            changeFilterActive(index: currentIndex)
            currentIndex = 1
            pickerView.selectRow(0, inComponent: 0, animated: true)
            changeCurrentPickerData(index: currentIndex)
            changeToolbarText(index: currentIndex)
            pickerView.reloadComponent(0)
        } else {
            changeFilterActive(index: currentIndex)
            observeFilterData()
            self.view.endEditing(true)
        }
    }
    
    private func changeCurrentPickerData(index: Int) {
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
    
    
    private func changeToolbarText(index: Int) {
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

extension SearchPostVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            filterList[currentIndex] = currentList[0]
        } else {
            filterList[currentIndex] = currentList[row-1]
            filterList[currentIndex] = currentList[row]
        }
    }
}

extension SearchPostVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentList.count
    }
}


//MARK: UI
extension SearchPostVC {
    func setConstraints() {
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
    
    func setConstraintsInFileterView() {
        fileterView.addSubviews([filterTitleLabel
                                 ,filterSubtitleLabel])
        
        filterTitleLabel.snp.makeConstraints{
            $0.top.equalTo(fileterView.snp.top).offset(37)
            $0.leading.equalTo(fileterView.snp.leading).offset(33)
        }
        
        
        filterSubtitleLabel.snp.makeConstraints{
            $0.top.equalTo(filterTitleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(fileterView.snp.leading).offset(33)
        }
        
        setStateConstraints()
        setThemaConstraints()
        setCautionConstraints()
    }
    
    func setStateConstraints() {
        fileterView.addSubviews([stateImageView,
                                 stateTextField,
                                 cityImageView,
                                 cityTextField,
                                 cityLabel])
        
        stateImageView.snp.makeConstraints{
            $0.top.equalTo(filterTitleLabel.snp.bottom).offset(30)
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
            $0.top.equalTo(filterTitleLabel.snp.bottom).offset(30)
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
    
    func setThemaConstraints() {
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
    
    func setCautionConstraints() {
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
