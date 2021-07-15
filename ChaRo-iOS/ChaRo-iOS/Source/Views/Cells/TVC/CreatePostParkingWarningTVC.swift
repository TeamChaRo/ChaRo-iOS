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
    
    // MARK: UI Components
    private let parkingTitleView = PostCellTitleView(title: "주차 공간은 어땠나요?")
    private let warningTitleView = PostCellTitleView(title: "드라이브 시 주의해야 할 사항이 있으셨나요?", subTitle: "고려해야 할 사항이 있다면 선택해주세요. 선택 사항입니다.")
    
    private let parkingExistButton: UIButton = {
        let button = UIButton()
        button.setTitle("있음", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.setEmptyTitleColor()
        button.setGray20Border(8)
        return button
    }()
    
    private let parkingNonExistButton: UIButton = {
        let button = UIButton()
        button.setTitle("없음", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        button.setEmptyTitleColor()
        button.setGray20Border(8)
        return button
    }()
    
    private let parkingDescTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "주차공간에 대해 적어주세요. 예) 주차장이 협소해요."
        textField.addLeftPadding(16)
        textField.textColor = .gray50
        textField.font = .notoSansRegularFont(ofSize: 14)
        textField.setGray20Border(8)
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let highwayButton: UIButton = {
        let button = UIButton()
        button.setTitle("고속도로", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.setEmptyTitleColor(colorNum: 40)
        button.setGray20Border(21)
        return button
    }()
    
    private let mountainButton: UIButton = {
        let button = UIButton()
        button.setTitle("산길포함", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.setEmptyTitleColor(colorNum: 40)
        button.setGray20Border(21)
        return button
    }()
    
    private let beginnerButton: UIButton = {
        let button = UIButton()
        button.setTitle("초보힘듦", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.setEmptyTitleColor(colorNum: 40)
        button.setGray20Border(21)
        return button
    }()
    
    private let peopleButton: UIButton = {
        let button = UIButton()
        button.setTitle("사람많음", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        button.setEmptyTitleColor(colorNum: 40)
        button.setGray20Border(21)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
}


extension CreatePostParkingWarningTVC {
    //MARK: - UI Layout
    func configureLayout(){
        addSubviews([parkingTitleView, parkingExistButton, parkingNonExistButton, parkingDescTextField])
        
        let buttonHeightRatio: CGFloat = 42/164
        let buttonWidth: CGFloat = (UIScreen.getDeviceWidth() - 47)/2
        let textFieldHeightRatio: CGFloat = 42/335
        
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
            $0.height.equalTo(parkingDescTextField.snp.width).multipliedBy(textFieldHeightRatio)
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
