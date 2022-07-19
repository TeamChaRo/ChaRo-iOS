//
//  FollowFollowingTVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/12/27.
//

import UIKit
import SnapKit
import Then

protocol isFollowButtonClickedDelegate {
    func isFollowButtonClicked()
}

class FollowFollowingTVC: UITableViewCell {
    //MARK: Var
    let myId = Constants.userEmail
    var otherUserID: String = "and@naver.com"
    var delegate: isFollowButtonClickedDelegate?
    
    private let profileImageView = UIImageView().then {
        $0.image = ImageLiterals.imgMypageDefaultProfile
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.mainBlue.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 19
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = UIFont.notoSansMediumFont(ofSize: 14)
        $0.textColor = UIColor.black
    }
    
    private lazy var followButton = FollowButton().then {
        $0.addTarget(self, action: #selector(followButtonClicked(_:)), for: .touchUpInside)
    }

    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
//MARK: function
    func setData(data: Follow) {
        guard let url = URL(string: data.image) else { return }
        userNameLabel.text = data.nickname
        otherUserID = data.userEmail
        if url != URL(string: "null"){profileImageView.kf.setImage(with: url)}
        else {profileImageView.image = ImageLiterals.imgMypageDefaultProfile}
        isMyAccount(email: data.userEmail)
        if data.isFollow {
            followButton.isSelected = true
        } else {
            followButton.isSelected = false
        }
    }
    func isMyAccount(email: String) {
        followButton.isHidden = email == myId
    }
    
    func postFollowData() {
        DoFollowService.shared.followService(follower: myId, followed: otherUserID) { result in
            switch result {
            case .success(let data):
                if let response = data as? DoFollowDataModel {
                    print(response.data.isFollow, "isFollow")
                    self.followButton.isSelected = response.data.isFollow
                    self.delegate?.isFollowButtonClicked()
                }
            case .requestErr(let message):
                print(message)
            case .serverErr:
                print("서버에러")
            case .networkFail:
                print("네트워크에러")
            default:
                print("에러임니다")
            }
        }
    }

    @objc private func followButtonClicked(_ sender: UIButton) {
        postFollowData()
    }
    
//MARK: layoutFunction
    func setLayout() {
        self.contentView.addSubviews([profileImageView, userNameLabel, followButton])
        profileImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.width.height.equalTo(42)
        }
        userNameLabel.snp.makeConstraints{
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(21)
            $0.width.equalTo(200)
        }
        followButton.snp.makeConstraints{
            $0.centerY.equalTo(profileImageView)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(60)
            $0.height.equalTo(25)
        }
    }
    
    func updateLayoutArPostLikeList() {
        profileImageView.snp.remakeConstraints{
            $0.top.bottom.equalToSuperview().inset(11)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(38)
        }
        
        userNameLabel.snp.makeConstraints{
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        followButton.snp.makeConstraints{
            $0.centerY.equalTo(profileImageView)
            $0.trailing.equalToSuperview().inset(19)
            $0.width.equalTo(56)
            $0.height.equalTo(22)
        }
    }
    
    func changeUIStyleAtPostListList() {
        updateLayoutArPostLikeList()
        profileImageView.layer.borderWidth = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
}
