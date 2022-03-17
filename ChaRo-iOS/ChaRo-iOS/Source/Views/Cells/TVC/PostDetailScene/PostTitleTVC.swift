//
//  PostTitleTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/05.
//

import UIKit
import SnapKit
import Then

class PostTitleTVC: UITableViewCell {
    
    // MARK: - properties
    
    private let postTitleLabel = UILabel().then {
        $0.font = .notoSansBoldFont(ofSize: 19)
        $0.textColor = .mainBlack
        $0.numberOfLines = 0
        $0.autoresizesSubviews = true
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = .notoSansMediumFont(ofSize: 13)
        $0.textColor = .mainBlack
    }
    
    private let postDateLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 12)
        $0.textColor = .gray30
    }
    
    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 29.0 / 2.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.addSubviews([postTitleLabel, profileImageView,
                     userNameLabel, postDateLabel])
        
        postTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(21)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(15)
            $0.leading.equalTo(postTitleLabel.snp.leading)
            $0.width.height.equalTo(29)
            $0.bottom.equalToSuperview().offset(-17)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(63)
        }
        
        postDateLabel.snp.makeConstraints{
            $0.top.equalTo(userNameLabel.snp.bottom).inset(1)
            $0.leading.equalTo(userNameLabel.snp.leading)
            $0.height.equalTo(22)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    private func configureUI() {
        selectionStyle = .none
    }
    
    func setContent(title: String, userName: String, date: String, imageName: String) {
        postTitleLabel.text = title
        postTitleLabel.sizeToFit()
        postTitleLabel.layoutIfNeeded()
        userNameLabel.text = userName
        postDateLabel.text = date
        profileImageView.kf.setImage(with: URL(string: imageName))
    }
    
}
