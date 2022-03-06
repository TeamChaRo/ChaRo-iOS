//
//  HomePostVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/07.
//
import Foundation
import UIKit
import SnapKit
import Then

protocol SetTopTitleDelegate {
    func setTopTitle(name: String)
}

class HomePostVC: UIViewController {
    @IBOutlet weak var NavigationTitleLabel: UILabel!
    @IBOutlet weak var homePostNavigationView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var famousButton: UIButton!
    @IBOutlet weak var newUpdateButton: UIButton!
//    @IBOutlet weak var dropDownTableview: UITableView!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fromBottomToLabel: NSLayoutConstraint!
    
    var delegate : SetTopTitleDelegate?
    var isFirstLoaded = true
    var cellCount = 0
    var topCVCCell : HomePostDetailCVC?
    var postCell: CommonCVC?
    var topText: String = "요즘 뜨는 드라이브"
    var cellIndexpath: IndexPath = [0,0]
    var postCount: Int = 0
    var newPostCount: Int = 0
    var postData: [DetailModel] = []
    var newPostData: [DetailModel] = []
    var cellLoadFirst: Bool = true
    
    var currentState: String = "인기순"
    let filterTableView = NewHotFilterView(frame: CGRect(x: 0, y: 0, width: 180, height: 97))
    
    static let identifier : String = "HomePostVC"
    
    func setHeaderBottomView() {
        let bottomView = UIView().then{
            $0.backgroundColor = UIColor.gray20
        }
        homePostNavigationView.addSubview(bottomView)
        bottomView.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(1)
        }
    }
    
    func setTableView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCustomXib(xibName: "CommonCVC")
        collectionView.registerCustomXib(xibName: "HomePostDetailCVC")
    }
    func setNavigationLabel() {
        self.setDetailNavigationViewUI(height: navigationViewHeight, fromBottomToTitle: fromBottomToLabel)
        NavigationTitleLabel.text = topText
    }
    
    
    func filterTableViewLayout() {
        filterTableView.delegate = self
        filterTableView.clickDelegate = self
        filterTableView.isHidden = true
        self.view.addSubview(filterTableView)
        filterTableView.snp.makeConstraints{
            $0.top.equalTo(homePostNavigationView.snp.bottom).offset(60)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(97)
            $0.width.equalTo(180)
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        filterTableViewLayout()
        setNavigationLabel()
        getData()
        setHeaderBottomView()
        self.dismissDropDownWhenTappedAround()

        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getData(){
        GetDetailDataService.detailData.getRecommendInfo{ (response) in
            switch response
            {
            case .success(let data) :
                if let response = data as? DetailModel{
                    
                    DispatchQueue.global().sync {
                        self.postCount = response.data.totalCourse
                        self.postData = [response]
                    }
                    self.postCount = response.data.totalCourse
                    self.collectionView.reloadData()
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
    
    func getNewData(){
        GetNewDetailDataService.detailData.getRecommendInfo{ (response) in
            switch response
            {
            case .success(let data) :
                if let response = data as? DetailModel{
                    
                    DispatchQueue.global().sync {
                        self.postCount = response.data.drive.count
                        self.newPostCount = response.data.drive.count
                    self.postData = [response]
                    }
                    self.collectionView.reloadData()
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
extension HomePostVC: UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return postCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCVC", for: indexPath) as? CommonCVC else { return UICollectionViewCell() }
        
        cell.clickedPostCell = { postid in
            let storyboard = UIStoryboard(name: "PostDetail", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: PostDetailVC.identifier) as! PostDetailVC
            
            nextVC.setPostId(id: postid)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
      
        cell.titleLabel.font = UIFont.notoSansBoldFont(ofSize: 14)
        
        guard let topCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePostDetailCVC", for: indexPath) as? HomePostDetailCVC else {return UICollectionViewCell()}
        topCell.delegate = self
        
        switch indexPath.section{
        case 0:
            if isFirstLoaded {
                isFirstLoaded = false
                topCVCCell = topCell
            }
            topCVCCell?.setTitle(data: currentState)
            return topCVCCell!
        case 1:
            if postData.count == 0{
                return cell
            }
            else{
                cell.setData(image: postData[0].data.drive[indexPath.row].image,
                             title: postData[0].data.drive[indexPath.row].title,
                             tagCount: postData[0].data.drive[indexPath.row].tags.count,
                             tagArr: postData[0].data.drive[indexPath.row].tags,
                             isFavorite: postData[0].data.drive[indexPath.row].isFavorite,
                             postID: postData[0].data.drive[indexPath.row].postID, height: 60)
                topCVCCell?.postCount = postCount
                //cell.titleHeight?.constant = 60
                cell.setLabel()
                return cell
            }
        default:
            print("ERRor")

        }
     return UICollectionViewCell()
    }
    
}


extension HomePostVC: UICollectionViewDataSource{
    
}
extension HomePostVC: UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let Cellwidth = UIScreen.main.bounds.width-40
        if indexPath.section == 0{
            return CGSize(width: Cellwidth, height: 50)
        }
        else{
            return CGSize(width: Cellwidth, height: 260)

        }
    }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0{
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)

       }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        else{
        return 35
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomePostVC: MenuClickedDelegate {
    func menuClicked(){
        filterTableView.isHidden = false
    }
    
}

extension HomePostVC{

func dismissDropDownWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(dismissDropDown))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissDropDown() {
        self.filterTableView.isHidden = true
    }
}

//postID 넘기기 위한 Delegate 구현
extension HomePostVC: PostIdDelegate {
    
    func sendPostID(data: Int) {
        print("이거임 ~~~~\(data)")
        
        let storyboard = UIStoryboard(name: "PostDetail", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: PostDetailVC.identifier) as! PostDetailVC
        
        nextVC.setPostId(id: data)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func sendPostDriveElement(data: DriveElement?) {
        let storyboard = UIStoryboard(name: "PostDetail", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: PostDetailVC.identifier) as! PostDetailVC
        nextVC.setAdditionalDataOfPost(data: data)
        nextVC.modalPresentationStyle = .currentContext
        tabBarController?.present(nextVC, animated: true, completion: nil)
    }
    
}
extension HomePostVC: NewHotFilterClickedDelegate{
    func filterClicked(row: Int) {
        switch row {
        case 0:
            getData()
            currentState = "인기순"
            collectionView.reloadData()
        default:
            getNewData()
            currentState = "최신순"
            collectionView.reloadData()
        }
    }
}
