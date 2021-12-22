//
//  OtherMyPageVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/12/22.
//

import UIKit
import SnapKit
import Then

class OtherMyPageVC: UIViewController {
    let userWidth = UIScreen.main.bounds.width
    let userheight = UIScreen.main.bounds.height

    //헤더뷰 유아이
    private let profileImageView = UIImageView().then{
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 3
        $0.image = UIImage(named: "myimage")
        $0.layer.cornerRadius = 32
    }
    private let headerBackgroundView = UIView().then{
        $0.backgroundColor = UIColor.mainBlue
    }

    private let headerTitleLabel = UILabel().then{
        $0.textColor = UIColor.white
        $0.font = UIFont.notoSansMediumFont(ofSize: 17)
        $0.text = "MY PAGE"
    }
    
    private let isFollowButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "followButton"), for: .normal)
    }
    
    private let userNameLabel = UILabel().then{
        $0.textColor = UIColor.white
        $0.font = UIFont.notoSansBoldFont(ofSize: 18)
        $0.textAlignment = .left
        $0.text = "none 드라이버님"
    }
    
    private let followerButton = UIButton().then{
        $0.backgroundColor = .none
        $0.setTitle("팔로워", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
        $0.titleLabel?.textColor = UIColor.white
        $0.contentHorizontalAlignment = .left
    }
    
    private let followerNumButton = UIButton().then{
        $0.backgroundColor = .none
        $0.setTitle("0", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
        $0.titleLabel?.textColor = UIColor.white
        $0.contentHorizontalAlignment = .left
    }
    
    private let followButton = UIButton().then{
        $0.backgroundColor = .none
        $0.setTitle("팔로우", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
        $0.titleLabel?.textColor = UIColor.white
        $0.contentHorizontalAlignment = .left
    }
    
    private let followNumButton = UIButton().then{
        $0.backgroundColor = .none
        $0.setTitle("0", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
        $0.titleLabel?.textColor = UIColor.white
        $0.contentHorizontalAlignment = .left
    }
    private var collectionview: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.backgroundColor = UIColor.white
        collectionView.bounces = true
        return collectionView
    }()
    //MARK: viewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderViewLayout()
        setCollectionviewLayout()
    }
    
    
    
    //MARK: setUI
    
    func setCollectionviewLayout(){
        self.view.addSubview(collectionview)
        collectionview.delegate = self
        collectionview.dataSource = self
        
        collectionview.registerCustomXib(xibName: "MyPagePostCVC")
        collectionview.registerCustomXib(xibName: "HomePostDetailCVC")
        
        collectionview.snp.makeConstraints{
            $0.top.equalTo(headerBackgroundView.snp.bottom).offset(0)
            $0.leading.trailing.bottom.equalToSuperview().offset(0)
        }
    }
    
    func setHeaderViewLayout(){
        self.view.addSubview(headerBackgroundView)
        headerBackgroundView.addSubviews([profileImageView,headerTitleLabel,userNameLabel, isFollowButton, followButton, followNumButton, followerButton, followerNumButton])
        
        let headerViewHeight = userheight * 0.27
        
        //backgroundView
        headerBackgroundView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(headerViewHeight)
        }
        //MYPAGELabel
        headerTitleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(58)
            $0.centerX.equalToSuperview()
        }
        //isFollowButton
        isFollowButton.snp.makeConstraints{
            $0.width.equalTo(60)
            $0.height.equalTo(25)
            $0.top.equalTo(headerTitleLabel.snp.bottom).offset(34)
            $0.centerY.equalTo(userNameLabel)
            $0.leading.equalTo(userNameLabel.snp.trailing).offset(12)
        }
        //profileImage
        profileImageView.snp.makeConstraints{
            $0.width.equalTo(62)
            $0.height.equalTo(62)
            $0.leading.equalToSuperview().offset(27)
            $0.top.equalTo(headerTitleLabel.snp.bottom).offset(29)
        }
        //userName
        userNameLabel.snp.makeConstraints{
            $0.leading.equalTo(profileImageView.snp.trailing).offset(27)
            $0.top.equalTo(headerTitleLabel.snp.bottom).offset(34)
            $0.width.equalTo(180)
        }
        //followerButton
        followerButton.snp.makeConstraints{
            $0.top.equalTo(userNameLabel.snp.bottom).offset(11)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(27)
            $0.width.equalTo(45)
        }
        //followerNumButton
        followerNumButton.snp.makeConstraints{
            $0.centerY.equalTo(followerButton)
            $0.leading.equalTo(followerButton.snp.trailing).offset(3)
            $0.width.equalTo(25)
        }
        //followButton
        followButton.snp.makeConstraints{
            $0.centerY.equalTo(followerButton)
            $0.leading.equalTo(followerNumButton.snp.trailing).offset(21)
            $0.width.equalTo(45)
        }
        //followNumButton
        followNumButton.snp.makeConstraints{
            $0.centerY.equalTo(followButton)
            $0.leading.equalTo(followButton.snp.trailing).offset(3)
            $0.width.equalTo(25)
        }
    
    }
    
    //MARK: Function

}


extension OtherMyPageVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: MyPagePostCVC.identifier, for: indexPath) as! MyPagePostCVC
        let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier:HomePostDetailCVC.identifier , for: indexPath) as! HomePostDetailCVC
        return cell
    }
    
    
}
extension OtherMyPageVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0{
            return CGSize(width: userWidth-35, height: 42)
        }
        else{
        return CGSize(width: collectionView.frame.width, height: 100)
        }
    }
    
}
extension OtherMyPageVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
