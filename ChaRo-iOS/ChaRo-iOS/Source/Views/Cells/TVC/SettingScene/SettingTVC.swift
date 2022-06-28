//
//  SettingTVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/12/29.
//

import UIKit
import SnapKit
import Then

class SettingTVC: UITableViewCell {
   
    // MARK: Variables
    static let identifier: String = "SettingTVC"
    
    private let backGroundView = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.notoSansRegularFont(ofSize: 14)
        $0.textColor = UIColor.black
    }
    
    private let subLabel = UILabel().then {
        $0.font = UIFont.notoSansRegularFont(ofSize: 14)
        $0.textAlignment = .right
        $0.textColor = UIColor.black
        $0.sizeToFit()
    }
    
    let toggle = UISwitch().then {
        $0.tintColor = UIColor.mainBlue
        $0.onTintColor = UIColor.mainBlue
    }
    
    var settingDelegate: SettingSwitchDelegate?
    
    // MARK: Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpConstraints()
        toggle.addTarget(self, action: #selector(toggleSwitched(_:)), for: UIControl.Event.valueChanged)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
}

// MARK: - UI
extension SettingTVC {
    private func setUpConstraints() {
        addSubviews([backGroundView, toggle, subLabel])
        backGroundView.addSubview(titleLabel)
        
        backGroundView.snp.makeConstraints {
            $0.leading.trailing.bottom.top.equalToSuperview().offset(0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backGroundView)
            $0.leading.equalToSuperview().offset(19)
            $0.width.equalTo(150)
        }
        
        toggle.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        subLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Custom Methods
extension SettingTVC {
    
    /// setData
    func setData(model: SettingDataModel) {
        titleLabel.text = model.titleString
        titleLabel.textColor = model.titleLabelColor
        
        // 토글 존재시
        toggle.isHidden = model.isToggle ? false : true
        toggle.isOn = model.isToggle ? model.toggleData : false
        
        // 서브라벨 존재시
        if model.isSubLabel == true {
            subLabel.isHidden = false
            subLabel.text = model.subLabelString
            subLabel.textColor = model.subLabelColor
        } else {
            subLabel.isHidden = true
        }
    }
    
    @objc
    private func toggleSwitched(_ sender: UISwitch) {
        settingDelegate?.switchAction(sender: self.toggle)
    }
}

// MARK: - Protocol
protocol SettingSwitchDelegate {
    func switchAction(sender: UISwitch)
}

