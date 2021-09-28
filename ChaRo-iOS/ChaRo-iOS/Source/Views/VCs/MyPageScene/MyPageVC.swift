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
//MARK: VAR
    //var
    let userWidth = UIScreen.main.bounds.width
    let userheight = UIScreen.main.bounds.height
    var userName: String = "드라이버"
    var followerNumber: String = "999"
    var followNumber: String = "999"
    var tabbarBottomConstraint: Int = 0
    
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
        $0.addTarget(self, action: #selector(saveButtonClicked(_:)), for: .touchUpInside)
    }
    private let tabbarSaveButton = UIButton().then{
        $0.setImage(UIImage(named: "save_inactive"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.addTarget(self, action: #selector(writeButtonClicked(_:)), for: .touchUpInside)
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
    //collectionView
    private let collectionScrollView = UIScrollView().then{
        $0.tag = 1
        $0.isPagingEnabled = true
        $0.bounces = false
        $0.contentSize.width = UIScreen.main.bounds.width
        $0.contentSize = CGSize(width: UIScreen.main.bounds.width*2, height: UIScreen.main.bounds.height)
        $0.backgroundColor = UIColor.white
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
    }
    private let writeView = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    private let saveView = UIView().then{
        $0.backgroundColor = UIColor.white
    }

    private var writeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.backgroundColor = UIColor.white
        collectionView.bounces = false
        return collectionView
    }()
    private var saveCollectioinView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.backgroundColor = UIColor.white
        collectionView.bounces = false
        return collectionView
    }()
    
//MARK: ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderUI()
        setHeaderLayout()
        setTabbarLayout()
        setCollectionViewLayout()
    }
    
    
    
//MARK: function
    //탭바 쉬트 이동 및 버튼클릭시 애니메이션
    func setTabbarBottomViewMove(){
        var contentOffsetX = collectionScrollView.contentOffset.x
        tabbarWriteBottomView.snp.remakeConstraints{
            $0.leading.equalTo(collectionScrollView.contentOffset.x / 2)
            $0.bottom.equalTo(tabbarBottomView.snp.top).offset(0)
            $0.width.equalTo(userWidth/2)
            $0.height.equalTo(2)
        }
        if contentOffsetX > userWidth/3{
            tabbarWriteButton.setImage(UIImage(named: "write_inactive"), for: .normal)
            tabbarSaveButton.setImage(UIImage(named: "save_active"), for: .normal)
        }
        else{
            tabbarWriteButton.setImage(UIImage(named: "write_active"), for: .normal)
            tabbarSaveButton.setImage(UIImage(named: "save_inactive"), for: .normal)
        }
    }

//MARK: buttonClicked
   @objc private func saveButtonClicked(_ sender: UIButton){
       collectionScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
       tabbarWriteButton.setImage(UIImage(named: "write_active"), for: .normal)
       tabbarSaveButton.setImage(UIImage(named: "save_inactive"), for: .normal)
    }
    @objc private func writeButtonClicked(_ sender: UIButton){
        collectionScrollView.setContentOffset(CGPoint(x: userWidth, y: 0), animated: true)
        tabbarWriteButton.setImage(UIImage(named: "write_inactive"), for: .normal)
        tabbarSaveButton.setImage(UIImage(named: "save_active"), for: .normal)
     }
//MARK: ScrollViewdidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //바텀뷰 이동
        setTabbarBottomViewMove()
        //아래 스크롤 방지
        if collectionScrollView.contentOffset.y > 0{
            collectionScrollView.contentOffset.y = 0
        }
        //위스크롤 방지
        if collectionScrollView.contentOffset.y > writeCollectionView.contentSize.height
        {
            collectionScrollView.contentOffset.y = 0;
        }
        //옆스크롤 방지
        if scrollView.contentOffset.x < 0{
            scrollView.contentOffset.x = 0;
        }
    }
//MARK: CollectionViewLayout
    func setCollectionViewLayout(){

        let collectionviewHeight  = userheight - (userheight * 0.27 + 130)
                
        collectionScrollView.delegate = self
        writeCollectionView.delegate = self
        writeCollectionView.dataSource = self
        saveCollectioinView.delegate = self
        saveCollectioinView.dataSource = self
        
        writeCollectionView.tag = 1
        saveCollectioinView.tag = 2
        
        writeCollectionView.registerCustomXib(xibName: "MyPagePostCVC")
        saveCollectioinView.registerCustomXib(xibName: "MyPagePostCVC")
        
        self.view.addSubview(collectionScrollView)
        collectionScrollView.addSubview(writeView)
        collectionScrollView.addSubview(saveView)
        writeView.addSubview(writeCollectionView)
        saveView.addSubview(saveCollectioinView)
       
        collectionScrollView.snp.makeConstraints{
            $0.top.equalTo(tabbarBottomView.snp.bottom).offset(0)
            $0.trailing.equalTo(view).offset(0)
            $0.leading.equalTo(view).offset(0)
            $0.bottom.equalTo(view).offset(0)
        }
        writeView.snp.makeConstraints{
            $0.top.equalTo(collectionScrollView.snp.top).offset(0)
            $0.leading.equalTo(collectionScrollView.snp.leading).offset(0)
            $0.width.equalTo(userWidth)
            $0.height.equalTo(collectionviewHeight)
        }
        writeCollectionView.snp.makeConstraints{
            $0.top.equalTo(writeView.snp.top).offset(0)
            $0.bottom.equalTo(writeView.snp.bottom).offset(0)
            $0.leading.equalTo(writeView.snp.leading).offset(0)
            $0.trailing.equalTo(writeView.snp.trailing).offset(0)
        }
        saveView.snp.makeConstraints{
            $0.top.equalTo(collectionScrollView.snp.top).offset(0)
            $0.leading.equalTo(writeView.snp.trailing).offset(0)
            $0.width.equalTo(userWidth)
            $0.height.equalTo(collectionviewHeight)
        }
        saveCollectioinView.snp.makeConstraints{
            $0.top.equalTo(saveView.snp.top).offset(0)
            $0.bottom.equalTo(saveView.snp.bottom).offset(0)
            $0.leading.equalTo(saveView.snp.leading).offset(0)
            $0.trailing.equalTo(saveView.snp.trailing).offset(0)
        }
       
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


extension MyPageVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
        
    }
    
}
extension MyPageVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellCount = 10
        switch collectionView.tag{
        case 1:
            return 2
        case 2:
            return cellCount
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: MyPagePostCVC.identifier, for: indexPath)
        
        switch collectionView.tag{
        case 1:
            return cell
        case 2:
            return cell
        default:
            return UICollectionViewCell()
            
        }
    }
    
    
}
extension MyPageVC: UICollectionViewDelegateFlowLayout{
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
