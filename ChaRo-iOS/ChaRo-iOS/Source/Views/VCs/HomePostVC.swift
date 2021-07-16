//
//  HomePostVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/07.
//
import Foundation
import UIKit

protocol SetTopTitleDelegate {
    func setTopTitle(name: String)
}

class HomePostVC: UIViewController {
    @IBOutlet weak var NavigationTitleLabel: UILabel!
    @IBOutlet weak var homePostNavigationView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var famousButton: UIButton!
    @IBOutlet weak var newUpdateButton: UIButton!
    @IBOutlet weak var dropDownTableview: UITableView!
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
    
    static let identifier : String = "HomePostVC"
    
    func setTableView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCustomXib(xibName: "CommonCVC")
        collectionView.registerCustomXib(xibName: "HomePostDetailCVC")
    }
    func setNavigationLabel(){
        NavigationTitleLabel.text = topText
    }
    
    
    func setDropdown(){
        dropDownTableview.registerCustomXib(xibName: "HotDropDownTVC")
        dropDownTableview.delegate = self
        dropDownTableview.dataSource = self
        dropDownTableview.separatorStyle = .none
    }
    func setShaow(){
        homePostNavigationView.getShadowView(color: UIColor.black.cgColor, masksToBounds: false, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8, shadowOpacity: 0.3)
    }
    func setRound(){
        dropDownTableview.layer.masksToBounds = true
        dropDownTableview.layer.cornerRadius = 20
//        dropDownTableview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setShaow()
        setDropdown()
        setRound()
        setNavigationLabel()
        getData()
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
                    print("ddd", self.postCount)
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postCount+1
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
        
     
        switch indexPath.row {
        case 0:
            if isFirstLoaded {
                isFirstLoaded = false
                topCVCCell = topCell
            }
            topCVCCell?.postCount = postCount
            topCVCCell?.setLabel()
            return topCVCCell!
        default:
            if postData.count == 0{
                return cell
            }
            else{
                cell.setData(image: postData[0].data.drive[indexPath.row-1].image, title: postData[0].data.drive[indexPath.row-1].title, tagCount: postData[0].data.drive[indexPath.row-1].tags.count, tagArr: postData[0].data.drive[indexPath.row-1].tags, isFavorite: postData[0].data.drive[indexPath.row-1].isFavorite, postID: postData[0].data.drive[indexPath.row-1].postID)
                topCVCCell?.postCount = postCount
                return cell
            }

        }
        

    }
    
}
extension HomePostVC: UICollectionViewDataSource{
    
}
extension HomePostVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let Cellwidth = UIScreen.main.bounds.width-40
        
        switch indexPath.row {
        case 0:
            print(Cellwidth)
            return CGSize(width: Cellwidth, height: 55)
        default:
            print(Cellwidth)
            return CGSize(width: Cellwidth, height: 260)
        }
        
    }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)

       }
}

extension HomePostVC: UITableViewDelegate{
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

extension HomePostVC: UITableViewDataSource{
    
}

extension HomePostVC: MenuClickedDelegate {
    func menuClicked(){
        dropDownTableview.isHidden = false

    }
    
}

extension HomePostVC: SetTitleDelegate {
    func setTitle(cell: HotDropDownTVC) {
        
        if cell.name == "인기순"{
            print("인기순 실행")
            self.getData()
            self.cellCount = self.postData[0].data.drive.count
            self.dropDownTableview.isHidden = true
            topCVCCell?.setTitle(data: "인기순")
            topCVCCell?.setTopTitle(name: "인기순")
            topCVCCell?.setSelectName(name: "인기순")
        }
        
        else if cell.name == "최신순"{
            print("최신순 실행")
            self.getNewData()
            self.cellCount = self.postData[0].data.drive.count
            self.dropDownTableview.isHidden = true
            topCVCCell?.setTitle(data: "최신순")
            topCVCCell?.setTopTitle(name: "최신순")
            topCVCCell?.setSelectName(name: "최신순")

        }
        
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
        self.dropDownTableview.isHidden = true
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
    
}
