//
//  NotificationTVC.swift
//  ChaRo-iOS
//
//  Created by hwangJi on 2022/03/22.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class NotificationTVC: UITableViewCell {
    
    // MARK: UI Components
    private let profileImageView = UIImageView().then {
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.mainBlue.cgColor
        $0.layer.masksToBounds = true
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
    }
    
    override func layoutSubviews() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray20.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        selectionStyle = .none
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
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
            $0.width.equalTo(43)
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
    func bindData(model: NotificationListModel) {
        guard let url = URL(string: model.image) else { return }
        profileImageView.kf.setImage(with: url)
        notiStateLabel.text = model.title
        notiTitleLabel.text = model.body
        notiDateLabel.text = convertNotiDateString(month: model.month, day: model.day)
        self.backgroundColor = model.isRead == 0 ? .blueSelect : .white
    }
}


