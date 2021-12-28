//
//  CreatePostLastTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/15.
//

import UIKit
import SnapKit

class CreatePostParkingWarningTVC: UITableViewCell {

    static let identifier: String = "CreatePostParkingWarningTVC"
    private let limitTextCount: Int = 23
    private var isWarning: Bool = false {
        didSet{
            if isWarning {
                warningLabel.isHidden = false
                parkingDescTextField.setMainOrangeBorder(8)
            } else {
                warningLabel.isHidden = true
                parkingDescTextField.setGray20Border(8)
            }
        }
    }
    private var parkingContent: String = ""  {
        didSet{
            _ = setParkingDesc?(self.parkingContent)
        }
    }
    private var warningValue: [Bool] = [false, false, false, false] {
        didSet{
            _ = setWraningData?(self.warningValue)
        }
    }
    public var availableParking: Bool = false {
        didSet{
            _ = setParkingInfo?(self.availableParking)
        }
    }
    private var parkingSelectFlag: Bool = false
    
    // 데이터 전달 closure
    public var setParkingInfo: ((Bool) -> Void)?
    public var setWraningData: (([Bool]) -> Void)?
    public var setParkingDesc: ((String) -> Void)?
    
    // cell height 동적으로 계산
    let buttonHeightRatio: CGFloat = 42/164
    let buttonWidth: CGFloat = (UIScreen.getDeviceWidth() - 47)/2
    func setDynamicHeight() -> CGFloat {
        // 주차공간 타이틀 + 인셋 + 버튼높이 + 인셋 + 텍스트뷰 높이 + 인셋 + 주의사항 타이틀 + 인셋 + 버튼1 + 인셋+ 버튼2 + 바텀여백
        // 22 + 12 + 동적 + 8 + 42 + 33 + 38 + 12 + 동적 + 8 + 동적 + 33
        // 기본 인셋이나 타이틀 = 166
        // 동적 버튼, 텍스트들의 기본 높이 = 42*4 = 168
        let buttonHeight: CGFloat = buttonWidth * buttonHeightRatio
        let fixedHeight: CGFloat = 208 // 기본 여백, 타이틀 높이
        let dynamicHeight: CGFloat = buttonHeight * 3 // 버튼 3줄
        
        return fixedHeight+dynamicHeight
    }
    
    // MARK: UI Components
    private let parkingTitleView = PostCellTitleView(title: "주차 공간은 어땠나요?")
    private let warningTitleView = PostCellTitleView(title: "드라이브 시 주의해야 할 사항이 있으셨나요?", subTitle: "고려해야 할 사항이 있다면 선택해주세요. 선택 사항입니다.")
    
    
    
    private let parkingExistButton: UIButton = {
        let button = UIButton()
        button.tag = 4
        button.setTitle("있음", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.setEmptyTitleColor()
        button.setGray20Border(21)
        return button
    }()
    
    private let parkingNonExistButton: UIButton = {
        let button = UIButton()
        button.tag = 5
        button.setTitle("없음", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.setEmptyTitleColor()
        button.setGray20Border(21)
        return button
    }()
    
    private let parkingDescTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "주차공간에 대해 적어주세요. 예) 주차장이 협소해요."
        textField.addLeftPadding(16)
        textField.textColor = .gray50
        textField.font = .notoSansRegularFont(ofSize: 14)
        textField.setGray20Border(12)
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "공백 포함 23자 이내로 작성해주세요."
        label.font = .notoSansRegularFont(ofSize: 11)
        label.textColor = .mainOrange
        label.isHidden = true
        return label
    }()
    
    private let highwayButton: UIButton = {
        let button = UIButton()
        button.tag = 0
        button.setTitle("고속도로", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.setEmptyTitleColor(colorNum: 40)
        button.setGray20Border(21)
        return button
    }()
    
    private let mountainButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.setTitle("산길포함", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.setEmptyTitleColor(colorNum: 40)
        button.setGray20Border(21)
        return button
    }()
    
    private let beginnerButton: UIButton = {
        let button = UIButton()
        button.tag = 2
        button.setTitle("초보힘듦", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.setEmptyTitleColor(colorNum: 40)
        button.setGray20Border(21)
        return button
    }()
    
    private let peopleButton: UIButton = {
        let button = UIButton()
        button.tag = 3
        button.setTitle("사람많음", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.setEmptyTitleColor(colorNum: 40)
        button.setGray20Border(21)
        return button
    }()
    
    func setTextFieldDelegate(){
        parkingDescTextField.delegate = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        setButtonActions()
        setTextFieldDelegate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
}

extension CreatePostParkingWarningTVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let textCount = parkingDescTextField.text!.count
        
        if textCount <= limitTextCount {
            parkingContent = parkingDescTextField.text!
            isWarning = isWarning ? false : isWarning
        } else {
            parkingDescTextField.text = parkingContent
            isWarning = !isWarning ? true : isWarning
        }
    }
}

extension CreatePostParkingWarningTVC {
    
    //MARK: - Button Actions
    func setButtonActions(){
        parkingExistButton.addTarget(self, action: #selector(ButtonDidTap), for: .touchUpInside)
        parkingNonExistButton.addTarget(self, action: #selector(ButtonDidTap), for: .touchUpInside)
        highwayButton.addTarget(self, action: #selector(ButtonDidTap), for: .touchUpInside)
        mountainButton.addTarget(self, action: #selector(ButtonDidTap), for: .touchUpInside)
        beginnerButton.addTarget(self, action: #selector(ButtonDidTap), for: .touchUpInside)
        peopleButton.addTarget(self, action: #selector(ButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    func ButtonDidTap(_ sender: UIButton){
        changeButtonStatus(tag: sender.tag)
    }
    
    func changeButtonStatus(tag: Int){
        switch tag {
        case 0:
            setWarningList(highwayButton, index: 0)
        case 1:
            setWarningList(mountainButton, index: 1)
        case 2:
            setWarningList(beginnerButton, index: 2)
        case 3:
            setWarningList(peopleButton, index: 3)
        case 4:
            if !availableParking {
                availableParking = true
                setTapParkingButton()
            } else {
                initParkingButton()
            }
        case 5:
            if availableParking {
                availableParking = false
                setTapParkingButton()
            } else {
                if parkingSelectFlag {
                    initParkingButton()
                } else { // 처음부터 없음 눌렀을 때
                    availableParking = false
                    setTapParkingButton()
                }
            }
        default:
            print("버튼 탭 오류")
        }
        
        if tag > 3 { // parking butoon select
            parkingSelectFlag = true
        }
    }
    
    func setTapParkingButton(){
        if availableParking {
            parkingExistButton.setMainBlueBorder(8)
            parkingExistButton.setBenefitTitleColor()
            parkingExistButton.backgroundColor = .blueSelect
            
            parkingNonExistButton.setGray20Border(8)
            parkingNonExistButton.setEmptyTitleColor(colorNum: 40)
            parkingNonExistButton.backgroundColor = .clear
        } else {
            parkingNonExistButton.setMainBlueBorder(8)
            parkingNonExistButton.setBenefitTitleColor()
            parkingNonExistButton.backgroundColor = .blueSelect
            
            parkingExistButton.setGray20Border(8)
            parkingExistButton.setEmptyTitleColor(colorNum: 40)
            parkingExistButton.backgroundColor = .clear
        }
    }
    
    func initParkingButton(){
        parkingExistButton.setGray20Border(8)
        parkingExistButton.setEmptyTitleColor(colorNum: 40)
        parkingExistButton.backgroundColor = .clear
        parkingNonExistButton.setGray20Border(8)
        parkingNonExistButton.setEmptyTitleColor(colorNum: 40)
        parkingNonExistButton.backgroundColor = .clear
    }
    
    func setWarningList(_ button: UIButton, index: Int){
        if warningValue[index] { // true 일 때
            warningValue[index] = false
        } else {
            warningValue[index] = true
        }
        
        setWarningButtonUI(button, warningValue[index])
    }
    
    func setWarningButtonUI(_ button: UIButton,_ value: Bool){
        // warning value에 맞춰서 색상 업데이트
        if value {
            button.setMainBlueBorder(21)
            button.setBenefitTitleColor()
            button.backgroundColor = .blueSelect
        } else {
            button.setGray20Border(21)
            button.setEmptyTitleColor(colorNum: 40)
            button.backgroundColor = .clear
        }
    }
    
    
    //MARK: - UI Layout
    func configureLayout(){
        addSubviews([parkingTitleView, parkingExistButton, parkingNonExistButton, parkingDescTextField, warningLabel])
        
        parkingTitleView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(22)
        }
        
        parkingExistButton.snp.makeConstraints{
            $0.top.equalTo(parkingTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(parkingExistButton.snp.width).multipliedBy(buttonHeightRatio)
        }
        
        parkingNonExistButton.snp.makeConstraints{
            $0.top.equalTo(parkingTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(parkingExistButton.snp.trailing).offset(7)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(parkingExistButton.snp.width).multipliedBy(buttonHeightRatio)
        }
        
        parkingDescTextField.snp.makeConstraints{
            $0.top.equalTo(parkingExistButton.snp.bottom).offset(8)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(42) // 텍스트필드는 height 고정
        }
        
        warningLabel.snp.makeConstraints{
            $0.top.equalTo(parkingDescTextField.snp.bottom).offset(4)
            $0.leading.equalTo(20)
        }
        
        addSubviews([warningTitleView, highwayButton, mountainButton, beginnerButton, peopleButton])
        
        warningTitleView.snp.makeConstraints{
            $0.top.equalTo(parkingDescTextField.snp.bottom).offset(33)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(38)
        }
        
        highwayButton.snp.makeConstraints{
            $0.top.equalTo(warningTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(parkingExistButton.snp.width).multipliedBy(buttonHeightRatio)
        }
        
        mountainButton.snp.makeConstraints{
            $0.top.equalTo(warningTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(highwayButton.snp.trailing).offset(7)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(parkingExistButton.snp.width).multipliedBy(buttonHeightRatio)
        }
        
        beginnerButton.snp.makeConstraints{
            $0.top.equalTo(highwayButton.snp.bottom).offset(8)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(parkingExistButton.snp.width).multipliedBy(buttonHeightRatio)
            $0.bottom.equalTo(self.snp.bottom).inset(33)
        }

        peopleButton.snp.makeConstraints{
            $0.top.equalTo(mountainButton.snp.bottom).offset(8)
            $0.leading.equalTo(beginnerButton.snp.trailing).offset(7)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(parkingExistButton.snp.width).multipliedBy(buttonHeightRatio)
            $0.bottom.equalTo(self.snp.bottom).inset(33)
        }
    }
}
