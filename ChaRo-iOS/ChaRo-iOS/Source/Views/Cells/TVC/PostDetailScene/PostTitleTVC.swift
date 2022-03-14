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
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = .notoSansMediumFont(ofSize: 13)
        $0.textColor = .mainBlack
    }
    
    private let postDateLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 12)
        $0.textColor = .gray30
    }
    
    private let profileImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupConstraints() {
        addSubviews([postTitleLabel, profileImageView,
                     userNameLabel, postDateLabel])
        
        postTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(21)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).inset(15)
            $0.leading.equalTo(postTitleLabel.snp.leading)
            $0.width.height.equalTo(29)
            $0.bottom.equalToSuperview().inset(17)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).inset(10)
            $0.leading.equalTo(profileImageView.snp.trailing).inset(14)
        }
        
        postDateLabel.snp.makeConstraints{
            $0.top.equalTo(userNameLabel.snp.bottom).inset(1)
            $0.leading.equalTo(userNameLabel.snp.leading)
        }
    }
    
    func configureUI() {
        selectionStyle = .none
    }
    
    func setContent(title: String, userName: String, date: String, imageName: String) {
        postTitleLabel.text = title
        userNameLabel.text = userName
        postDateLabel.text = date
        profileImageView.layer.masksToBounds = true
        profileImageView.kf.setImage(with: URL(string: imageName))
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.0
    }
    
}
