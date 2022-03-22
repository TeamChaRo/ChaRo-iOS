//
//  NotificationTVC.swift
//  ChaRo-iOS
//
//  Created by hwangJi on 2022/03/22.
//

import UIKit
import SnapKit
import Then

class NotificationTVC: UITableViewCell {
    
    // MARK: UI Components
    private let profileImageView = UIImageView().then {
        $0.layer.borderWidth = 4
        $0.layer.borderColor = UIColor.mainBlue.cgColor
        $0.layer.cornerRadius = $0.frame.height / 2
    }
    
    private let notiStateLabel = UILabel().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainBlue.cgColor
        $0.layer.cornerRadius = 8.5
        $0.font = UIFont.notoSansMediumFont(ofSize: 10)
        $0.textColor = .mainBlue
        $0.textAlignment = .center
    }
    
    private let notiTitleLabel = UILabel().then {
        $0.font = UIFont.notoSansMediumFont(ofSize: 12)
        $0.textColor = .subBlack
    }
    
    private let notiDateLabel = UILabel().then {
        $0.font = UIFont.notoSansRegularFont(ofSize: 11)
        $0.textColor = .gray40
        $0.textAlignment = .right
    }

    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}

// MARK: - UI
extension NotificationTVC {
    private func configureUI() {
        self.addSubviews([profileImageView, notiStateLabel, notiTitleLabel, notiDateLabel])
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(45).multipliedBy(getDeviceHeight()/375)
            $0.centerY.equalToSuperview()
        }
        
        notiStateLabel.snp.makeConstraints {
            let heightRatio: CGFloat = 17/45
            $0.top.equalTo(profileImageView.snp.top)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.height.equalTo(profileImageView.snp.height).multipliedBy(heightRatio)
            $0.width.equalTo(notiStateLabel.snp.height).multipliedBy(43/17)
        }
        
        notiTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(notiStateLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(profileImageView.snp.bottom)
        }
        
        notiDateLabel.snp.makeConstraints {
            $0.trailing.equalTo(notiTitleLabel.snp.trailing)
            $0.centerY.equalTo(notiStateLabel)
        }
    }
}

// MARK: - Custom Method
extension NotificationTVC {
    func bindData() {
    }
}


