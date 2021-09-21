//
//  MyPageVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/10.
//

import UIKit
import Lottie
import SnapKit
import Then

class MyPageVC: UIViewController {
    //var
    let userWidth = UIScreen.main.bounds.width
    let userheight = UIScreen.main.bounds.height
    var userName: String = "드라이버"
    var followerNumber: String = "999"
    var followNumber: String = "999"
    
    //headerView
    var headerViewList: [UIView] = []
    var headerImageViewList: [UIImageView] = []
    var headerLabelList: [UILabel] = []
    var headerButtonList: [UIButton] = []
    
    //tabbarUI
    private let tabbarBackgroundView = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    private let tabbarWriteButton = UIButton().then{
        $0.setImage(UIImage(named: "write_active"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    private let tabbarSaveButton = UIButton().then{
        $0.setImage(UIImage(named: "save_inactive"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    private let tabbarBottomView = UIView().then{
        $0.backgroundColor = UIColor.gray20
    }
    private let tabbarWriteBottomView = UIView().then{
        $0.backgroundColor = UIColor.mainBlue
    }
    private let tabbarSaveBottomView = UIView().then{
        $0.backgroundColor = .none
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderUI()
        setHeaderLayout()
        setTabbarLayout()
    }
//MARK: TabbarLayout
    func setTabbarLayout(){
        self.view.addSubview(tabbarBackgroundView)
        tabbarBackgroundView.addSubview(tabbarSaveButton)
        tabbarBackgroundView.addSubview(tabbarWriteButton)
        tabbarBackgroundView.addSubview(tabbarBottomView)
        tabbarBackgroundView.addSubview(tabbarWriteBottomView)
        tabbarBackgroundView.addSubview(tabbarSaveBottomView)
        
        tabbarBackgroundView.snp.makeConstraints{
            $0.top.equalTo(headerViewList[0].snp.bottom).offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(50)
        }
        tabbarWriteButton.snp.makeConstraints{
            $0.top.equalTo(tabbarBackgroundView).offset(0)
            $0.leading.equalTo(tabbarBackgroundView).offset(0)
            $0.bottom.equalTo(tabbarBackgroundView).offset(0)
            $0.width.equalTo(userWidth/2)
        }
        tabbarSaveButton.snp.makeConstraints{
            $0.top.equalTo(tabbarBackgroundView).offset(0)
            $0.trailing.equalTo(tabbarBackgroundView).offset(0)
            $0.bottom.equalTo(tabbarBackgroundView).offset(0)
            $0.width.equalTo(userWidth/2)
        }
        tabbarBottomView.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(0)
            $0.width.equalTo(userWidth)
            $0.height.equalTo(1)
        }
        tabbarWriteBottomView.snp.makeConstraints{
            $0.bottom.equalTo(tabbarBottomView.snp.top).offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.width.equalTo(userWidth/2)
            $0.height.equalTo(2)
        }
        tabbarSaveBottomView.snp.makeConstraints{
            $0.bottom.equalTo(tabbarBottomView.snp.top).offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.width.equalTo(userWidth/2)
            $0.height.equalTo(2)
        }
        
        
    }
//MARK: HeaderViewLayout
    func setHeaderUI(){
        let headerBackgroundView = UIView().then{
            $0.backgroundColor = UIColor.mainBlue
        }
        headerViewList.append(headerBackgroundView)
        
        let headerTitleLabel = UILabel().then{
            $0.textColor = UIColor.white
            $0.font = UIFont.notoSansMediumFont(ofSize: 17)
            $0.text = "MY PAGE"
        }
        headerLabelList.append(headerTitleLabel)
        
        // buttonlist[0]
        let settingButton = UIButton().then{
            $0.setBackgroundImage(UIImage(named: "setting2_white"), for: .normal)
        }
        headerButtonList.append(settingButton)
        
        let profileImageView = UIImageView().then{
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
            $0.layer.masksToBounds = true
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 3
            $0.image = UIImage(named: "myimage")
            $0.layer.cornerRadius = 32
        }
        headerImageViewList.append(profileImageView)
        
        //1
        let userNameLabel = UILabel().then{
            $0.textColor = UIColor.white
            $0.font = UIFont.notoSansBoldFont(ofSize: 18)
            $0.textAlignment = .left
            $0.text = "\(userName) 드라이버님"
        }
        headerLabelList.append(userNameLabel)
        
        // buttonlist[1]
        let followerButton = UIButton().then{
            $0.backgroundColor = .none
            $0.setTitle("팔로워", for: .normal)
            $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
            $0.titleLabel?.textColor = UIColor.white
            $0.contentHorizontalAlignment = .left
        }
        headerButtonList.append(followerButton)
        
        // buttonlist[2]
        let followerNumButton = UIButton().then{
            $0.backgroundColor = .none
            $0.setTitle(followerNumber, for: .normal)
            $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
            $0.titleLabel?.textColor = UIColor.white
            $0.contentHorizontalAlignment = .left
        }
        headerButtonList.append(followerNumButton)
        
        // buttonlist[3]
        let followButton = UIButton().then{
            $0.backgroundColor = .none
            $0.setTitle("팔로우", for: .normal)
            $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
            $0.titleLabel?.textColor = UIColor.white
            $0.contentHorizontalAlignment = .left
        }
        headerButtonList.append(followButton)
        
        // buttonlist[4]
        let followNumButton = UIButton().then{
            $0.backgroundColor = .none
            $0.setTitle(followNumber, for: .normal)
            $0.titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 13)
            $0.titleLabel?.textColor = UIColor.white
            $0.contentHorizontalAlignment = .left
        }
        headerButtonList.append(followNumButton)
        
        self.view.addSubview(headerBackgroundView)
        headerBackgroundView.addSubview(profileImageView)
        headerBackgroundView.addSubviews(headerButtonList + headerLabelList)
    }
    func setHeaderLayout(){
        let headerViewHeight = userheight * 0.27
        print(userheight)
        //backgroundView
        headerViewList[0].snp.makeConstraints{
            $0.top.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(headerViewHeight)
        }
        //MYPAGELabel
        headerLabelList[0].snp.makeConstraints{
            $0.top.equalToSuperview().offset(58)
            $0.centerX.equalToSuperview()
        }
        //settingButton
        headerButtonList[0].snp.makeConstraints{
            $0.width.equalTo(48)
            $0.height.equalTo(48)
            $0.top.equalToSuperview().offset(58)
            $0.centerY.equalTo(headerLabelList[0])
            $0.trailing.equalToSuperview().offset(-6)
        }
        //profileImage
        headerImageViewList[0].snp.makeConstraints{
            $0.width.equalTo(62)
            $0.height.equalTo(62)
            $0.leading.equalToSuperview().offset(27)
            $0.top.equalTo(headerLabelList[0].snp.bottom).offset(29)
        }
        //userName
        headerLabelList[1].snp.makeConstraints{
            $0.leading.equalTo(headerImageViewList[0].snp.trailing).offset(27)
            $0.top.equalTo(headerLabelList[0].snp.bottom).offset(34)
            $0.width.equalTo(180)
        }
        //followerButton
        headerButtonList[1].snp.makeConstraints{
            $0.top.equalTo(headerLabelList[1].snp.bottom).offset(11)
            $0.leading.equalTo(headerImageViewList[0].snp.trailing).offset(27)
            $0.width.equalTo(45)
        }
        //followerNumButton
        headerButtonList[2].snp.makeConstraints{
            $0.centerY.equalTo(headerButtonList[1])
            $0.leading.equalTo(headerButtonList[1].snp.trailing).offset(3)
            $0.width.equalTo(25)
        }
        //followButton
        headerButtonList[3].snp.makeConstraints{
            $0.centerY.equalTo(headerButtonList[1])
            $0.leading.equalTo(headerButtonList[2].snp.trailing).offset(21)
            $0.width.equalTo(45)
        }
        //followNumButton
        headerButtonList[4].snp.makeConstraints{
            $0.centerY.equalTo(headerButtonList[1])
            $0.leading.equalTo(headerButtonList[3].snp.trailing).offset(3)
            $0.width.equalTo(25)
        }
    }
    
}
