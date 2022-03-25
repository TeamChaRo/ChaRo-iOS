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
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fromBottomToLabel: NSLayoutConstraint!
    
    var delegate: SetTopTitleDelegate?
    var isFirstLoaded = true
    var cellCount = 0
    var topCVCCell: HomePostDetailCVC?
    var postCell: CommonCVC?
    var topText: String = "요즘 뜨는 드라이브"
    var cellIndexpath: IndexPath = [0,0]
    var postCount: Int = 0
    var newPostCount: Int = 0
    var postData: [DetailModel] = []
    var newPostData: [DetailModel] = []
    var cellLoadFirst: Bool = true
    
    var currentState: String = "인기순"
    let filterView = FilterView()
    
    static let identifier: String = "HomePostVC"
    
    func setNavigationBottomLineView() {
        let bottomLineView = UIView().then{
            $0.backgroundColor = UIColor.gray20
        }
        homePostNavigationView.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(1)
        }
    }
    
    func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCustomXib(xibName: "CommonCVC")
        collectionView.registerCustomXib(xibName: "HomePostDetailCVC")
    }
    func setNavigationLabel() {
        self.setDetailNavigationViewUI(height: navigationViewHeight, fromBottomToTitle: fromBottomToLabel)
        NavigationTitleLabel.text = topText
    }
    
    
<<<<<<< HEAD
    func setDropdown() {
        dropDownTableview.registerCustomXib(xibName: "HotDropDownTVC")
        dropDownTableview.delegate = self
        dropDownTableview.dataSource = self
        dropDownTableview.separatorStyle = .none
    }
    
    func setShaow() {
        homePostNavigationView.getShadowView(color: UIColor.black.cgColor, masksToBounds: false, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8, shadowOpacity: 0.3)
    }
    
    func setRound() {
        dropDownTableview.layer.masksToBounds = true
        dropDownTableview.layer.cornerRadius = 20
//        dropDownTableview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
=======
    func setFilterViewLayout() {
        self.view.addSubview(filterView)
        filterView.isHidden = true
        filterView.snp.makeConstraints{
            $0.top.equalTo(homePostNavigationView.snp.bottom).offset(60)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(97)
            $0.width.equalTo(180)
        }
    }
    
    func setFilterViewCompletion(){
        filterView.touchCellCompletion = { index in
            switch index{
            case 0:
                self.currentState = "인기순"
                self.getData()
            case 1:
                self.currentState = "최신순"
                self.getNewData()
            default:
                print("Error")
            }
            self.collectionView.reloadData()
            self.filterView.isHidden = true
            return index
        }
>>>>>>> develop
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setFilterViewLayout()
        setNavigationLabel()
        getData()
        setNavigationBottomLineView()
        setFilterViewCompletion()
        self.dismissDropDownWhenTappedAround()
        // Do any additional setup after loading the view.

    }

    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getData() {
        GetDetailDataService.detailData.getRecommendInfo{ (response) in
            switch response
            {
            case .success(let data) :
<<<<<<< HEAD
                if let response = data as? DetailModel {
                    
=======
                if let response = data as? DetailModel{
                    print("인기순 데이터")

>>>>>>> develop
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
    
    func getNewData() {
        GetNewDetailDataService.detailData.getRecommendInfo{ (response) in
            switch response
            {
            case .success(let data) :
<<<<<<< HEAD
                if let response = data as? DetailModel {
                    
=======
                if let response = data as? DetailModel{
                    print("최신순 데이터")
>>>>>>> develop
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
extension HomePostVC: UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else {
            return postCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCVC", for: indexPath) as? CommonCVC else { return UICollectionViewCell() }
        
        cell.clickedPostCell = { postid in
            let nextVC = PostDetailVC()
            nextVC.setPostId(id: postid)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
      
        cell.titleLabel.font = UIFont.notoSansBoldFont(ofSize: 14)
        
        guard let topCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePostDetailCVC", for: indexPath) as? HomePostDetailCVC else {return UICollectionViewCell()}
        topCell.delegate = self
        
        switch indexPath.section {
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
            else {
                cell.setData(image: postData[0].data.drive[indexPath.row].image,
                             title: postData[0].data.drive[indexPath.row].title,
                             tagCount: postData[0].data.drive[indexPath.row].tags.count,
                             tagArr: postData[0].data.drive[indexPath.row].tags,
                             isFavorite: postData[0].data.drive[indexPath.row].isFavorite,
                             postID: postData[0].data.drive[indexPath.row].postID, height: 60)
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


extension HomePostVC: UICollectionViewDataSource {
    
}
extension HomePostVC: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let Cellwidth = UIScreen.main.bounds.width-40
        if indexPath.section == 0{
            return CGSize(width: Cellwidth, height: 50)
        }
        else {
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
        else {
        return 35
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

<<<<<<< HEAD
extension HomePostVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellIndexpath = indexPath
        
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
            cell.setCellName(name: "최신순")
            cell.delegate = self

            return cell

        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let HotCell: HotDropDownTVC = tableView.dequeueReusableCell(for: indexPath)
        if indexPath.row == 0 {
            HotCell.setSelectedCell()
            
        }

    }
    
}

extension HomePostVC: UITableViewDataSource {
    
}

extension HomePostVC: MenuClickedDelegate {
    func menuClicked() {
        dropDownTableview.isHidden = false

=======
extension HomePostVC: MenuClickedDelegate {
    func menuClicked(){
        filterView.isHidden = false
>>>>>>> develop
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
        self.filterView.isHidden = true
    }
}

//postID 넘기기 위한 Delegate 구현
extension HomePostVC: PostIdDelegate {
    
    func sendPostID(data: Int) {
        print("이거임 ~~~~\(data)")
        let nextVC = PostDetailVC()
        nextVC.setPostId(id: data)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func sendPostDriveElement(data: DriveElement?) {
        let nextVC = PostDetailVC()
        nextVC.setAdditionalDataOfPost(data: data)
        nextVC.modalPresentationStyle = .currentContext
        tabBarController?.present(nextVC, animated: true, completion: nil)
    }
    
}
