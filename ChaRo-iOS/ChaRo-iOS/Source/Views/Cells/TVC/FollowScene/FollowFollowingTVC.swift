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
    
    static let identifier: String = "FollowFollowingTVC"
    
    private let profileImageView = UIImageView().then{
        $0.image = UIImage(named: "myimage")
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.mainBlue.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 21
    }
    
    private let userNameLabel = UILabel().then{
        $0.text = "name"
        $0.font = UIFont.notoSansMediumFont(ofSize: 14)
        $0.textColor = UIColor.black
    }
    private let followButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "FollowButtonImage"), for: .normal)
        $0.addTarget(self, action: #selector(followButtonClicked(_:)), for: .touchUpInside)
    }
//MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
        // Initialization code
    }
    
//MARK: function
    func setData(image: String, userName: String, isFollow: Bool, userEmail: String){
        guard let url = URL(string: image) else { return }
        userNameLabel.text = userName
        otherUserID = userEmail
        profileImageView.kf.setImage(with: url)
        if isFollow == true{
            followButton.setBackgroundImage(UIImage(named: "followingButtonImage"), for: .normal)
        }
        else{
            followButton.setBackgroundImage(UIImage(named: "FollowButtonImage"), for: .normal)
        }
    }
    
    func postFollowData(){
        DoFollowService.shared.followService(follower: myId, followed: otherUserID){ result in
            switch result {
            case .success(let data):
                if let response = data as? DoFollowDataModel{
                    print(response.data.isFollow)
//                    if response.data.isFollow == true{
//                        self.followButton.setBackgroundImage(UIImage(named: "followingButtonImage"), for: .normal)
//                    }
//                    else{
//                        self.followButton.setBackgroundImage(UIImage(named: "FollowButtonImage"), for: .normal)
//                    }
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
    
    
    
    @objc private func followButtonClicked(_ sender: UIButton){
        postFollowData()
    }
//MARK: layoutFunction
    func setLayout(){
        addSubviews([profileImageView, userNameLabel, followButton])
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    
}
