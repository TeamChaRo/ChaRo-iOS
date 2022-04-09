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
    let myId = UserDefaults.standard.string(forKey: "userId") ?? "ios@gmail.com"
    var otherUserID: String = "and@naver.com"
    var delegate: isFollowButtonClickedDelegate?
    
    private let profileImageView = UIImageView().then {
        $0.image = ImageLiterals.imgMypageDefaultProfile
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.mainBlue.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 21
    }
    
    private let userNameLabel = UILabel().then {
        $0.text = ""
        $0.font = UIFont.notoSansMediumFont(ofSize: 14)
        $0.textColor = UIColor.black
    }
    private var followButton = UIButton().then{
        $0.setTitleColor(.mainBlue, for: .selected)
        $0.setTitleColor(.gray30, for: .normal)
        $0.setTitle("팔로잉" , for: .selected)
        $0.setTitle("팔로워", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 13)
    }

    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        setFollowButtonAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
//MARK: function
    func setData(data: Follow) {
        guard let url = URL(string: data.image) else { return }
        userNameLabel.text = data.nickname
        otherUserID = data.userEmail
        profileImageView.kf.setImage(with: url)
        isMyAccount(email: data.userEmail)
        if data.isFollow{
            followButton.isSelected = true
        } else {
            followButton.isSelected = false
        }
            setFollowButtonUI()
    }
    func isMyAccount(email: String) {
        if email == myId {
            followButton.isHidden = true
        }
    }
    
    func setFollowButtonUI() {
        followButton.backgroundColor = .none
        followButton.layer.cornerRadius = 13
        followButton.layer.borderColor = followButton.isSelected ? UIColor.mainBlue.cgColor : UIColor.gray30.cgColor
        followButton.layer.borderWidth = 1
    }
    
    func setFollowButtonAddTarget() {
        followButton.addTarget(self, action: #selector(followButtonClicked(_:)), for: .touchUpInside)
    }
    
    func postFollowData() {
        DoFollowService.shared.followService(follower: myId, followed: otherUserID) { result in
            switch result {
            case .success(let data):
                if let response = data as? DoFollowDataModel {
                    print(response.data.isFollow, "isFollow")
                    self.followButton.isSelected = response.data.isFollow
                    self.setFollowButtonUI()
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
            $0.width.equalTo(41)
            $0.height.equalTo(41)
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
            $0.width.height.equalTo(37)
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
        userNameLabel.font = .notoSansMediumFont(ofSize: 13)
        followButton.setBackgroundImage(nil, for: .normal)
        followButton.layer.borderColor = followButton.isSelected ? UIColor.mainBlue.cgColor : UIColor.gray30.cgColor
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 11
        followButton.backgroundColor = followButton.isSelected ? .mainBlue : .white
        followButton.setTitle("팔로잉", for: .normal)
        followButton.setTitle("팔로우", for: .selected)
        followButton.setTitleColor(.mainBlack, for: .normal)
        followButton.setTitleColor(.white, for: .selected)
        followButton.titleLabel?.font = .notoSansRegularFont(ofSize: 12)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    
}
