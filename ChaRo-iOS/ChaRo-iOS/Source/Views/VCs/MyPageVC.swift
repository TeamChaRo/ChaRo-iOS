//
//  MyPageVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/10.
//

import UIKit


class MyPageVC: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var customTabbar: UICollectionView!
    @IBOutlet weak var myTableCollectionView: UICollectionView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var saveTableCollectionView: UICollectionView!
    @IBOutlet weak var followingCountButton: UIButton!
    @IBOutlet weak var folloerCountButton: UIButton!
    
    var myCellCount = 0
    var saveCellCount = 0
    
    var myCVCCell: HomePostDetailCVC?
    var saveCVCCell: HomePostDetailCVC?
    
    var LikePostData: [MyPageDataModel] = []
    var newPostData: [MyPageDataModel] = []
    
    var customTabbarList: [TabbarCVC] = []
    @IBOutlet weak var dropDownTableView: UITableView!
    
    var myCellIsFirstLoaded: Bool = true
    var saveCellIsFirstLoaded: Bool = true
    
    var delegate: SetTopTitleDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCircleLayout()
        setCollectionView()
        customTabbarInit()
        setDropDown()
        getData()
        self.dismissDropDownWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    func setHeaderView(){
        headerView.backgroundColor = .mainBlue
        nameLabel.text = LikePostData[0].data.userInformation.nickname
        folloerCountButton.setTitle(String(LikePostData[0].data.userInformation.follower), for: .normal)
        followingCountButton.setTitle(String(LikePostData[0].data.userInformation.following), for: .normal)
        guard let url = URL(string: LikePostData[0].data.userInformation.profileImage) else { return }
        self.profileImageView.kf.setImage(with: url)
        setCircleLayout()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setDropDown(){
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        dropDownTableView.isHidden = true
        dropDownTableView.registerCustomXib(xibName: "HotDropDownTVC")
        dropDownTableView.clipsToBounds = true
        dropDownTableView.layer.cornerRadius = 10
//        dropDownTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        dropDownTableView.separatorStyle = .none
        
    }
    
    func customTabbarInit(){
        guard let myCell = customTabbar.dequeueReusableCell(withReuseIdentifier: "TabbarCVC", for: [0,0]) as? TabbarCVC else {return}
        guard let SaveCell = customTabbar.dequeueReusableCell(withReuseIdentifier: "TabbarCVC", for: [0,1]) as? TabbarCVC else {return}
        
        customTabbarList.append(myCell)
        customTabbarList.append(SaveCell)
        
    }
    
    
    
    func setCircleLayout(){
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        profileImageButton.setBackgroundImage(UIImage(named: "camera_mypage_wth_circle.png"), for: .normal)
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageButton.clipsToBounds = true
        profileImageButton.layer.borderWidth = 0
        profileImageButton.layer.borderColor = .none
        profileImageButton.layer.masksToBounds = false
        profileImageButton.layer.cornerRadius = profileImageButton.frame.height/2
    }
    
    func setCollectionView(){
        customTabbar.delegate = self
        customTabbar.dataSource = self
        myTableCollectionView.delegate = self
        myTableCollectionView.dataSource = self
        saveTableCollectionView.delegate = self
        saveTableCollectionView.dataSource = self
        
        customTabbar.tag = 1
        myTableCollectionView.tag = 2
        saveTableCollectionView.tag = 3
        
        customTabbar.layer.addBorder([.bottom], color: UIColor.gray20, width: 1.0)
        customTabbar.registerCustomXib(xibName: "TabbarCVC")
        myTableCollectionView.registerCustomXib(xibName: "MyPagePostCVC")
        myTableCollectionView.registerCustomXib(xibName: "HomePostDetailCVC")
        saveTableCollectionView.registerCustomXib(xibName: "MyPagePostCVC")
        saveTableCollectionView.registerCustomXib(xibName: "HomePostDetailCVC")
    
    }
    
    func getData(){
        GetMyPageDataService.MyPageData.getRecommendInfo{ (response) in
            switch response
            {
            case .success(let data) :
                if let response = data as? MyPageDataModel{
                    

                    DispatchQueue.global().sync {
                        self.LikePostData = [response]
                        self.myCellCount = self.LikePostData[0].data.writtenTotal
                        self.saveCellCount = self.LikePostData[0].data.savedTotal
                        self.setHeaderView()
                    }
                    self.myTableCollectionView.reloadData()
                    self.saveTableCollectionView.reloadData()
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
    
    

}

extension MyPageVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //커스텀 탭바 설정
        if collectionView.tag == 1{
        switch indexPath.row{
        case 0:
            customTabbarList[0].setSelectedView()
            customTabbarList[1].setDeselectedView()
            customTabbarList[0].setIcon(data: "write_active")
            customTabbarList[1].setIcon(data: "save5_inactive")
            saveTableCollectionView.isHidden = true
//            myTableCollectionView.reloadData()
//            saveTableCollectionView.reloadData()
        case 1:
            customTabbarList[0].setDeselectedView()
            customTabbarList[1].setSelectedView()
            customTabbarList[0].setIcon(data: "write_inactive")
            customTabbarList[1].setIcon(data: "save5_active")
            saveTableCollectionView.isHidden = false
//            saveTableCollectionView.reloadData()
//            myTableCollectionView.reloadData()
        default:
            print("Error")
        }
        }
        //나중에 누르면 구현되게 여기다가 구현 할 예정
    }
}

extension MyPageVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let customTabbarCount: Int = 2
        switch collectionView.tag {
        case 1:
            return customTabbarCount
        case 2:
            return myCellCount + 1
        default:
            return saveCellCount + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let myCell = myTableCollectionView.dequeueReusableCell(withReuseIdentifier: "MyPagePostCVC", for: indexPath) as? MyPagePostCVC else {return UICollectionViewCell()}
        guard let detailCell = myTableCollectionView.dequeueReusableCell(withReuseIdentifier: "HomePostDetailCVC", for: indexPath) as? HomePostDetailCVC else {return UICollectionViewCell()}
        
        myCell.clickedPostCell = { postid in
            let storyboard = UIStoryboard(name: "PostDetail", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: PostDetailVC.identifier) as! PostDetailVC
            
            nextVC.setPostId(id: postid)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        switch collectionView.tag {
        // 커스텀 탭바
        case 1:
            if indexPath.row == 0{
                customTabbarList[0].setSelectedView()
                customTabbarList[0].setIcon(data: "write_active")
                return customTabbarList[0]
            }
            if indexPath.row == 1{
                customTabbarList[1].setIcon(data: "save5_inactive")
                return customTabbarList[1]
            }
        //내가 쓴 글
        case 2:
            detailCell.delegate = self
            switch indexPath.row {
            case 0:
                if myCellIsFirstLoaded {
                    myCellIsFirstLoaded = false
                    myCVCCell = detailCell
                    myCVCCell?.postCount = myCellCount
                    myCVCCell?.setLabel()
                }
                return myCVCCell as! UICollectionViewCell
            default:
                if LikePostData.count == 0{
                    return myCell
                }
                else{
                    print(myCellCount, indexPath.row)
                    myCVCCell?.postCount = myCellCount
                    myCVCCell?.setLabel()
                    myCell.setData(image: LikePostData[0].data.writtenPost[indexPath.row-1
                    ].image, title: LikePostData[0].data.writtenPost[indexPath.row-1].title, tagCount: LikePostData[0].data.writtenPost[indexPath.row-1].tags.count, tagArr: LikePostData[0].data.writtenPost[indexPath.row-1].tags, heart: LikePostData[0].data.writtenPost[indexPath.row-1].favoriteNum, save: LikePostData[0].data.writtenPost[indexPath.row-1].saveNum, year: LikePostData[0].data.writtenPost[indexPath.row-1].year, month: LikePostData[0].data.writtenPost[indexPath.row-1].month, day: LikePostData[0].data.writtenPost[indexPath.row-1].day, postID: LikePostData[0].data.writtenPost[indexPath.row-1].postID)
            return myCell
                
            }
            }
        case 3:
            detailCell.delegate = self
            switch indexPath.row {
            case 0:
                if saveCellIsFirstLoaded {
                    saveCellIsFirstLoaded = false
                    saveCVCCell = detailCell
                    saveCVCCell?.postCount = saveCellCount
                    saveCVCCell?.postCountLabel.text = String(saveCellCount)
                    saveCVCCell?.setLabel()
                }
                return saveCVCCell as! UICollectionViewCell
            default:
                if LikePostData.count == 0{
                    return myCell
                }
                else{
                    print(myCellCount, indexPath.row)
                    saveCVCCell?.postCount = saveCellCount
                    saveCVCCell?.setLabel()
                    myCell.setData(image: LikePostData[0].data.savedPost[indexPath.row-1
                    ].image, title: LikePostData[0].data.savedPost[indexPath.row-1].title, tagCount: LikePostData[0].data.savedPost[indexPath.row-1].tags.count, tagArr: LikePostData[0].data.savedPost[indexPath.row-1].tags, heart: LikePostData[0].data.savedPost[indexPath.row-1].favoriteNum, save: LikePostData[0].data.savedPost[indexPath.row-1].saveNum, year: LikePostData[0].data.savedPost[indexPath.row-1].year, month: LikePostData[0].data.savedPost[indexPath.row-1].month, day: LikePostData[0].data.savedPost[indexPath.row-1].day, postID: LikePostData[0].data.savedPost[indexPath.row-1].postID)
            return myCell
            }
                
            }

        default:
            print("Error")
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = UIScreen.main.bounds.width
        
        if collectionView.tag == 1{
        return CGSize(width: width/2, height: 50)
        }
        else {
            if indexPath.row == 0{
                return CGSize(width: width-40, height: 30)
            }
            else{
            return CGSize(width: width, height: 100)
            }
        }
    }
    
}

extension MyPageVC: UICollectionViewDelegateFlowLayout{
    
}
//이거 컬렉션뷰 밑부분만 테두리 그릴라고 익스텐션해놓음
extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}

extension MyPageVC: UITableViewDelegate{
    
}
extension MyPageVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: HotDropDownTVC = tableView.dequeueReusableCell(for: indexPath)
            var bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.mainBlue.withAlphaComponent(0.2)
            cell.selectedBackgroundView = bgColorView
            cell.setLabel()
            cell.setCellName(name: "인기순")
            cell.delegate = self
            return cell

        case 1:
            let cell: HotDropDownTVC = tableView.dequeueReusableCell(for: indexPath)
            var bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.mainBlue.withAlphaComponent(0.2)
            cell.selectedBackgroundView = bgColorView
            cell.setLabel()
            cell.setCellName(name: "최신순")
            cell.delegate = self
            return cell

        default:
            return UITableViewCell()
        }
    }

}

extension MyPageVC: MenuClickedDelegate{
    func menuClicked(){
        dropDownTableView.isHidden = false
    }
    
}

extension MyPageVC: SetTitleDelegate {
    func setTitle(cell: HotDropDownTVC) {
        if cell.name == "인기순"{
            print("인기순 실행")
            GetMyPageDataService.URL = Constants.myPageLikeURL
            getData()
            self.myCellCount = self.LikePostData[0].data.writtenPost.count
            self.dropDownTableView.isHidden = true
            myCVCCell?.postCount = myCellCount
            myCVCCell?.setLabel()
            saveCVCCell?.postCount = saveCellCount
            saveCVCCell?.setLabel()
            saveCVCCell?.setSelectName(name: "인기순")
            myCVCCell?.setSelectName(name: "인기순")
            
        }
        
        else if cell.name == "최신순"{
            print("최신순 실행")
            GetMyPageDataService.URL = Constants.myPageNewURL
            getData()
            self.myCellCount = self.LikePostData[0].data.writtenPost.count
            self.dropDownTableView.isHidden = true
            myCVCCell?.postCount = myCellCount
            myCVCCell?.setLabel()
            saveCVCCell?.postCount = saveCellCount
            myCVCCell?.setLabel()
            saveCVCCell?.setSelectName(name: "최신순")
            myCVCCell?.setSelectName(name: "최신순")
        }
        
    }
    
}

extension MyPageVC{

func dismissDropDownWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(dismissDropDown))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissDropDown() {
        self.dropDownTableView.isHidden = true
    }
}

