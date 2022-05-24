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
    //MARK: Var
    
    static let identifier: String = "SettingTVC"
    
    private let backGroundView = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "adfsfsa"
        $0.font = UIFont.notoSansRegularFont(ofSize: 14)
        $0.textColor = UIColor.black
        
    }
    private let toggle = UISwitch().then {
        $0.tintColor = UIColor.mainBlue
        $0.onTintColor = UIColor.mainBlue
    }
    private let subLabel = UILabel().then {
        $0.font = UIFont.notoSansRegularFont(ofSize: 14)
        $0.textAlignment = .right
        $0.textColor = UIColor.black
        $0.sizeToFit()
    }

    //MARK: setData
    
    func setData(isToggle: Bool, toggleData: Bool, isSubLabel: Bool, subLabelString: String, titleString: String, titleLabelColor: UIColor, subLabelColor: UIColor) {
        addSubview(backGroundView)
        backGroundView.addSubview(titleLabel)
        
        //배경화면
        backGroundView.snp.makeConstraints {
            $0.leading.trailing.bottom.top.equalToSuperview().offset(0)
        }
        
        
        //기본 라벨
        titleLabel.text = titleString
        titleLabel.textColor = titleLabelColor
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backGroundView)
            $0.leading.equalToSuperview().offset(19)
            $0.width.equalTo(150)
        }
        
        //토글 존재시
        if isToggle == true {
            addSubview(toggle)
            toggle.isOn = toggleData
            toggle.snp.makeConstraints{
                $0.centerY.equalTo(titleLabel)
                $0.trailing.equalToSuperview().offset(-20)
            }
        }
        
        //서브라벨 존재시
        if isSubLabel == true {
            addSubview(subLabel)
            subLabel.text = subLabelString
            subLabel.textColor = subLabelColor
            subLabel.snp.makeConstraints{
                $0.centerY.equalTo(titleLabel)
                $0.trailing.equalToSuperview().offset(-20)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        removeAllSubViews()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none

        // Configure the view for the selected state
    }
    
}
