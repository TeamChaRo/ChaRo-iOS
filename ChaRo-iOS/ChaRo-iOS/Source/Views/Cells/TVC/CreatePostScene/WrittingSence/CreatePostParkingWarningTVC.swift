//
//  CreatePostLastTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/15.
//

import UIKit

import SnapKit
import Then

final class CreatePostParkingWarningTVC: UITableViewCell {

    // MARK: Properties

    private let limitTextCount: Int = 23
    private var isWarning: Bool = false {
        didSet {
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
        didSet {
            _ = setParkingDesc?(self.parkingContent)
        }
    }
    private var warningValue: [Bool] = [false, false, false, false] {
        didSet {
            _ = setWraningData?(self.warningValue)
        }
    }
    var availableParking: Bool = false {
        didSet {
            _ = setParkingInfo?(self.availableParking)
        }
    }
    private var parkingSelectFlag: Bool = false
    
    // 데이터 전달 closure
    var setParkingInfo: ((Bool) -> Void)?
    var setWraningData: (([Bool]) -> Void)?
    var setParkingDesc: ((String) -> Void)?
    
    // cell height 동적으로 계산
    private let buttonHeightRatio: CGFloat = 42/164
    private let buttonWidth: CGFloat = (UIScreen.getDeviceWidth() - 47)/2
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


    // MARK: UI

    private let parkingTitleView = PostCellTitleView(title: "주차 공간은 어땠나요?")
    private let warningTitleView = PostCellTitleView(title: "드라이브 시 주의해야 할 사항이 있으셨나요?", subTitle: "고려해야 할 사항이 있다면 선택해주세요. 선택 사항입니다.")

    private let parkingExistButton = UIButton().then {
        $0.tag = 4
        $0.setTitle("있음", for: .normal)
        $0.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        $0.titleLabel?.textAlignment = .center
        $0.setEmptyTitleColor()
        $0.setGray20Border(21)
    }
    
    private let parkingNonExistButton = UIButton().then {
        $0.tag = 5
        $0.setTitle("없음", for: .normal)
        $0.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        $0.titleLabel?.textAlignment = .center
        $0.setEmptyTitleColor()
        $0.setGray20Border(21)
    }
    
    private let parkingDescTextField = UITextField().then {
        $0.placeholder = "주차공간에 대해 적어주세요. 예) 주차장이 협소해요."
        $0.addLeftPadding(16)
        $0.textColor = .gray50
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.setGray20Border(12)
        $0.clearButtonMode = .whileEditing
    }
    
    private let warningLabel = UILabel().then {
        $0.isHidden = true
    }
    
    private let highwayButton = UIButton().then {
        $0.tag = 0
        $0.setTitle("고속도로", for: .normal)
        $0.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        $0.setEmptyTitleColor(colorNum: 40)
        $0.setGray20Border(21)
    }
    
    private let mountainButton = UIButton().then {
        $0.tag = 1
        $0.setTitle("산길포함", for: .normal)
        $0.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        $0.setEmptyTitleColor(colorNum: 40)
        $0.setGray20Border(21)
    }
    
    private let beginnerButton = UIButton().then {
        $0.tag = 2
        $0.setTitle("초보힘듦", for: .normal)
        $0.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        $0.setEmptyTitleColor(colorNum: 40)
        $0.setGray20Border(21)
    }
    
    private let peopleButton = UIButton().then {
        $0.tag = 3
        $0.setTitle("사람많음", for: .normal)
        $0.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        $0.setEmptyTitleColor(colorNum: 40)
        $0.setGray20Border(21)
    }
    
    private func configureTextFieldDelegate() {
        parkingDescTextField.delegate = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureLayout()
        self.addButtonActions()
        self.configureTextFieldDelegate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
}


// MARK: - UITextFieldDelegate

extension CreatePostParkingWarningTVC: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let textCount = parkingDescTextField.text!.count
        
        if textCount <= self.limitTextCount {
            self.parkingContent = parkingDescTextField.text!
            self.isWarning.toggle()
        } else {
            self.parkingDescTextField.text = parkingContent
            self.isWarning.toggle()
        }
    }
}


// MARK: - Button Actions

extension CreatePostParkingWarningTVC {

    func addButtonActions() {
        self.parkingExistButton.addTarget(self, action: #selector(ButtonDidTap), for: .touchUpInside)
        self.parkingNonExistButton.addTarget(self, action: #selector(ButtonDidTap), for: .touchUpInside)
        self.highwayButton.addTarget(self, action: #selector(ButtonDidTap), for: .touchUpInside)
        self.mountainButton.addTarget(self, action: #selector(ButtonDidTap), for: .touchUpInside)
        self.beginnerButton.addTarget(self, action: #selector(ButtonDidTap), for: .touchUpInside)
        self.peopleButton.addTarget(self, action: #selector(ButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func ButtonDidTap(_ sender: UIButton) {
        self.changeButtonStatus(tag: sender.tag)
    }
    
    private func changeButtonStatus(tag: Int) {
        switch tag {
        case 0:
            self.configureWarningList(highwayButton, index: 0)
        case 1:
            self.configureWarningList(mountainButton, index: 1)
        case 2:
            self.configureWarningList(beginnerButton, index: 2)
        case 3:
            self.configureWarningList(peopleButton, index: 3)
        case 4:
            if self.availableParking == false {
                self.availableParking.toggle()
                self.updateParkingButtonState()
            } else {
                initParkingButton()
            }
        case 5:
            if self.availableParking == true {
                self.availableParking.toggle()
                self.updateParkingButtonState()
            } else {
                if parkingSelectFlag {
                    self.initParkingButton()
                } else { // 처음부터 없음 눌렀을 때
                    self.availableParking = false
                    self.updateParkingButtonState()
                }
            }
        default:
            print("버튼 탭 오류")
        }
        
        if tag > 3 { // parking butoon select
            self.parkingSelectFlag = true
        }
    }
    
    private func updateParkingButtonState() {
        if self.availableParking == true {
            self.parkingExistButton.setMainBlueBorder(8)
            self.parkingExistButton.setBenefitTitleColor()
            self.parkingExistButton.backgroundColor = .blueSelect
            
            self.parkingNonExistButton.setGray20Border(8)
            self.parkingNonExistButton.setEmptyTitleColor(colorNum: 40)
            self.parkingNonExistButton.backgroundColor = .clear
        } else {
            self.parkingNonExistButton.setMainBlueBorder(8)
            self.parkingNonExistButton.setBenefitTitleColor()
            self.parkingNonExistButton.backgroundColor = .blueSelect
            
            self.parkingExistButton.setGray20Border(8)
            self.parkingExistButton.setEmptyTitleColor(colorNum: 40)
            self.parkingExistButton.backgroundColor = .clear
        }
    }
    
    private func initParkingButton() {
        self.parkingExistButton.setGray20Border(8)
        self.parkingExistButton.setEmptyTitleColor(colorNum: 40)
        self.parkingExistButton.backgroundColor = .clear

        self.parkingNonExistButton.setGray20Border(8)
        self.parkingNonExistButton.setEmptyTitleColor(colorNum: 40)
        self.parkingNonExistButton.backgroundColor = .clear
    }
    
    private func configureWarningList(_ button: UIButton, index: Int) {
        if self.warningValue[index] { // true 일 때
            self.warningValue[index] = false
        } else {
            self.warningValue[index] = true
        }
        
        self.updateWarningButtonUI(button, value: self.warningValue[index])
    }
    
    private func updateWarningButtonUI(_ button: UIButton, value: Bool) {
        // warning value에 맞춰서 색상 업데이트
        if value == true {
            button.setMainBlueBorder(21)
            button.setBenefitTitleColor()
            button.backgroundColor = .blueSelect
        } else {
            button.setGray20Border(21)
            button.setEmptyTitleColor(colorNum: 40)
            button.backgroundColor = .clear
        }
    }
}

    
//MARK: - Layout

extension CreatePostParkingWarningTVC {

    private func configureLayout() {
        // 주차정보
        self.addSubviews([
            self.parkingTitleView,
            self.parkingExistButton,
            self.parkingNonExistButton,
            self.parkingDescTextField,
            self.warningLabel
        ])
        
        self.parkingTitleView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(22)
        }
        
        self.parkingExistButton.snp.makeConstraints {
            $0.top.equalTo(parkingTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(parkingExistButton.snp.width).multipliedBy(buttonHeightRatio)
        }
        
        self.parkingNonExistButton.snp.makeConstraints {
            $0.top.equalTo(parkingTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(parkingExistButton.snp.trailing).offset(7)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(parkingExistButton.snp.width).multipliedBy(buttonHeightRatio)
        }
        
        self.parkingDescTextField.snp.makeConstraints {
            $0.top.equalTo(parkingExistButton.snp.bottom).offset(8)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(42) // 텍스트필드는 height 고정
        }
        
        self.warningLabel.snp.makeConstraints {
            $0.top.equalTo(parkingDescTextField.snp.bottom).offset(4)
            $0.leading.equalTo(20)
        }


        // 드라이브 특이사항
        self.addSubviews([
            self.warningTitleView,
            self.highwayButton,
            self.mountainButton,
            self.beginnerButton,
            self.peopleButton
        ])
        
        self.warningTitleView.snp.makeConstraints {
            $0.top.equalTo(parkingDescTextField.snp.bottom).offset(33)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(38)
        }
        
        self.highwayButton.snp.makeConstraints {
            $0.top.equalTo(warningTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(parkingExistButton.snp.width).multipliedBy(buttonHeightRatio)
        }
        
        self.mountainButton.snp.makeConstraints {
            $0.top.equalTo(warningTitleView.snp.bottom).offset(12)
            $0.leading.equalTo(highwayButton.snp.trailing).offset(7)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(parkingExistButton.snp.width).multipliedBy(buttonHeightRatio)
        }
        
        self.beginnerButton.snp.makeConstraints {
            $0.top.equalTo(highwayButton.snp.bottom).offset(8)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(parkingExistButton.snp.width).multipliedBy(buttonHeightRatio)
            $0.bottom.equalTo(self.snp.bottom).inset(33)
        }

        self.peopleButton.snp.makeConstraints {
            $0.top.equalTo(mountainButton.snp.bottom).offset(8)
            $0.leading.equalTo(beginnerButton.snp.trailing).offset(7)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(parkingExistButton.snp.width).multipliedBy(buttonHeightRatio)
            $0.bottom.equalTo(self.snp.bottom).inset(33)
        }
    }
}
