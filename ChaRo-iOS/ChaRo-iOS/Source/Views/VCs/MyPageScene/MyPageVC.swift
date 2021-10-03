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
import Kingfisher

class MyPageVC: UIViewController {
//MARK: VAR
    //var
    let userWidth = UIScreen.main.bounds.width
    let userheight = UIScreen.main.bounds.height
    var tabbarBottomConstraint: Int = 0
    
    var userProfileData: [UserInformation] = []
    var writenPostData: [MyPagePost] = []
    var savePostData: [MyPagePost] = []
    
    //headerView
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
    
    private let settingButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "setting2_white"), for: .normal)
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
        setHeaderLayout()
        setTabbarLayout()
        setCollectionViewLayout()
        getProfileData()
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
    
    func setHeaderData(){
        guard let url = URL(string: userProfileData[0].profileImage) else { return }
        userNameLabel.text = userProfileData[0].nickname
        profileImageView.kf.setImage(with: url)
        followerNumButton.setTitle(String(userProfileData[0].follower), for: .normal)
        followNumButton.setTitle(String(userProfileData[0].following), for: .normal) 
    }
    
    func getProfileData(){
        GetMyPageDataService.MyPageData.getRecommendInfo{ (response) in
                   switch response
                   {
                   case .success(let data) :
                       if let response = data as? MyPageDataModel{
                           self.userProfileData.append(response.data.userInformation)
                           self.writenPostData.append(response.data.writtenPost)
                           self.savePostData.append(response.data.savedPost)
                           self.setHeaderData()
                           self.writeCollectionView.reloadData()
                           self.saveCollectioinView.reloadData()
                       }
                   case .requestErr(let message) :
                       print("requestERR")
                   case .pathErr :
                       print("pathERR")
                   case .serverErr:
                       print("serverERR")
                   case .networkFail:
                       print("networkFail")
                   }
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
        writeCollectionView.registerCustomXib(xibName: "HomePostDetailCVC")
        saveCollectioinView.registerCustomXib(xibName: "HomePostDetailCVC")
             
        
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
            $0.top.equalTo(headerBackgroundView.snp.bottom).offset(0)
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
    
    func setHeaderLayout(){
        self.view.addSubview(headerBackgroundView)
        headerBackgroundView.addSubview(profileImageView)
        headerBackgroundView.addSubview(headerTitleLabel)
        headerBackgroundView.addSubview(userNameLabel)
        headerBackgroundView.addSubview(settingButton)
        headerBackgroundView.addSubview(followButton)
        headerBackgroundView.addSubview(followNumButton)
        headerBackgroundView.addSubview(followerButton)
        headerBackgroundView.addSubview(followerNumButton)
        
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
        //settingButton
        settingButton.snp.makeConstraints{
            $0.width.equalTo(48)
            $0.height.equalTo(48)
            $0.top.equalToSuperview().offset(58)
            $0.centerY.equalTo(headerTitleLabel)
            $0.trailing.equalToSuperview().offset(-6)
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
    
}


extension MyPageVC: UICollectionViewDelegate{
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
//MARK: Extension
extension MyPageVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var writeCellCount = 0
        var saveCellCount = 0
        
        if(writenPostData.count == 0){
            writeCellCount = 0
        }
        else{
            writeCellCount = writenPostData[0].drive.count + 1
        }
        
        if(savePostData.count == 0){
            saveCellCount = 0
        }
        else{
            saveCellCount = savePostData[0].drive.count + 1
        }
        
        switch collectionView.tag{
        case 1:
            return writeCellCount
        case 2:
            return saveCellCount
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: MyPagePostCVC.identifier, for: indexPath) as! MyPagePostCVC
        let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier:HomePostDetailCVC.identifier , for: indexPath) as! HomePostDetailCVC
        

        switch collectionView.tag{
            
        case 1:
            if(indexPath.row == 0){
                detailCell.postCountLabel.text = ""
                return detailCell
            }
            else{
                let writenElement = writenPostData[0].drive[indexPath.row-1]
                var writenTags = [writenElement.region, writenElement.theme,
                            writenElement.warning ?? ""] as [String]
            cell.setData(image: writenPostData[0].drive[indexPath.row-1].image, title: writenPostData[0].drive[indexPath.row-1].title, tagCount:writenTags.count, tagArr: writenTags, heart:writenPostData[0].drive[indexPath.row-1].favoriteNum, save: writenPostData[0].drive[indexPath.row-1].saveNum, year: writenPostData[0].drive[indexPath.row-1].year, month: writenPostData[0].drive[indexPath.row-1].month, day: writenPostData[0].drive[indexPath.row-1].day, postID: writenPostData[0].drive[indexPath.row-1].postID)
            return cell
            }
        case 2:
            if(indexPath.row == 0){
                detailCell.postCountLabel.text = ""
                return detailCell
            }
            
            else{
                let saveElement = savePostData[0].drive[indexPath.row-1]
                var saveTags = [saveElement.region, saveElement.theme, saveElement.warning ?? ""] as [String]
                
            cell.setData(image: savePostData[0].drive[indexPath.row-1].image, title: savePostData[0].drive[indexPath.row-1].title, tagCount:saveTags.count, tagArr: saveTags, heart:savePostData[0].drive[indexPath.row].favoriteNum, save: savePostData[0].drive[indexPath.row].saveNum, year: savePostData[0].drive[indexPath.row].year, month: savePostData[0].drive[indexPath.row].month, day: savePostData[0].drive[indexPath.row].day, postID: savePostData[0].drive[indexPath.row].postID)
            return cell
            }
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
