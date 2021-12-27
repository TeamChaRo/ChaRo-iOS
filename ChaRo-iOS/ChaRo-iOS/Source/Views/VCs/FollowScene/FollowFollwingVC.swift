//
//  FollowFollwingVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/12/24.
//

import UIKit
import SnapKit
import Then

class FollowFollwingVC: UIViewController {
//MARK: VAR
    //var
    let userWidth = UIScreen.main.bounds.width
    let userheight = UIScreen.main.bounds.height
    var tabbarBottomConstraint: Int = 0

    var followerNum: Int = 0
    var followingNum: Int = 0
        
    var userProfileData: [UserInformation] = []
    //var writenPostData: [MyPagePost] = []
    var writenPostDriveData: [MyPageDrive] = []
    var savePostDriveData: [MyPageDrive] = []
        
    //무한스크롤을 위함
    var lastId: Int = 0
    var lastFavorite: Int = 0
    var isLast: Bool = false
    var scrollTriger: Bool = false
    var lottieView = IndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var delegate: AnimateIndicatorDelegate?
    
    //headerView
    private let headerBackgroundView = UIView().then{
        $0.backgroundColor = UIColor.white
    }

    private let headerTitleLabel = UILabel().then{
        $0.textColor = UIColor.black
        $0.font = UIFont.notoSansMediumFont(ofSize: 17)
        $0.text = "none"
    }
    
    private let backButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "backIcon"), for: .normal)
    }

    //tabbarUI
    private let tabbarBackgroundView = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    private let followerButton = UIButton().then{
        $0.setTitle("팔로워", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        $0.addTarget(self, action: #selector(followerButtonClicked(_:)), for: .touchUpInside)
    }
    private let followingButton = UIButton().then{
        $0.setTitle("팔로잉", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        $0.addTarget(self, action: #selector(followingButtonClicked(_:)), for: .touchUpInside)
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
    
    
    //TableView
    private let TableScrollView = UIScrollView().then{
        let userHeigth = UIScreen.main.bounds.height
        $0.tag = 1
        $0.isPagingEnabled = true
        $0.bounces = false
        $0.contentSize.width = UIScreen.main.bounds.width
        
        //아무튼 아이폰 12에서는 잘 돌아가는데 이거 기기마다 테스트 매우 필요한 항목일듯요,, 스크롤뷰랑 컬렉션뷰의 설정된 heigth가 조금이라도 다르면 화면 지혼자 휙휙 돌아감...이걸 우짠담..제발 다른기기에서도 잘 돌아갔으면 좋겟다 제발 제발 제발 제발 제발 제발
        $0.contentSize = CGSize(width: UIScreen.main.bounds.width*2, height: userHeigth - (userHeigth * 0.27 + 151))
        $0.backgroundColor = UIColor.white
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
    }
    private let followerTableView = UITableView()
    private let followingTableView = UITableView()

    private let followerView = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    private let followingView = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    
//MARK: viewDidLoad
    override func viewDidLoad(){
        setHeaderLayout()
        setTabbarLayout()
        super.viewDidLoad()

    }
//MARK: Func
       @objc private func followerButtonClicked(_ sender: UIButton){
           TableScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
           followerButton.setTitleColor(UIColor.mainBlue, for: .normal)
           followingButton.setTitleColor(UIColor.gray40, for: .normal)
        }
        @objc private func followingButtonClicked(_ sender: UIButton){
            TableScrollView.setContentOffset(CGPoint(x: userWidth, y: 0), animated: true)
            followerButton.setTitleColor(UIColor.gray40, for: .normal)
            followingButton.setTitleColor(UIColor.mainBlue, for: .normal)
         }

//MARK: layoutFunction
    func setHeaderLayout(){
        self.view.addSubview(headerBackgroundView)
        headerBackgroundView.addSubview(headerTitleLabel)
        headerBackgroundView.addSubview(backButton)

        
        let headerViewHeight = userheight * 0.15
        
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
        //settingButton
        backButton.snp.makeConstraints{
            $0.width.equalTo(48)
            $0.height.equalTo(48)
            $0.top.equalToSuperview().offset(58)
            $0.centerY.equalTo(headerTitleLabel)
            $0.leading.equalToSuperview().offset(0)
        }
        //profileImage
      
    }
    func setTabbarLayout(){
        self.view.addSubview(tabbarBackgroundView)
        tabbarBackgroundView.addSubview(followingButton)
        tabbarBackgroundView.addSubview(followerButton)
        tabbarBackgroundView.addSubview(tabbarBottomView)
        tabbarBackgroundView.addSubview(tabbarWriteBottomView)
        tabbarBackgroundView.addSubview(tabbarSaveBottomView)
        
        tabbarBackgroundView.snp.makeConstraints{
            $0.top.equalTo(headerBackgroundView.snp.bottom).offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(50)
        }
        followerButton.snp.makeConstraints{
            $0.top.equalTo(tabbarBackgroundView).offset(0)
            $0.leading.equalTo(tabbarBackgroundView).offset(0)
            $0.bottom.equalTo(tabbarBackgroundView).offset(0)
            $0.width.equalTo(userWidth/2)
        }
        followingButton.snp.makeConstraints{
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
            $0.leading.equalToSuperview().offset(tabbarBottomConstraint)
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
}
