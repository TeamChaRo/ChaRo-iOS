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

enum getDataThemeType {
    case recommend
    case new
}

class HomePostVC: UIViewController {
    @IBOutlet weak var NavigationTitleLabel: UILabel!
    @IBOutlet weak var homePostNavigationView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var famousButton: UIButton!
    @IBOutlet weak var newUpdateButton: UIButton!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fromBottomToLabel: NSLayoutConstraint!
    
    var flag: Bool = true
    
    var delegate: SetTopTitleDelegate?
    var isFirstLoaded = true
    var cellCount = 0
    var topCVCCell: HomePostDetailCVC?
    var postCell: CommonCVC?
    var topText: String = "요즘 뜨는 드라이브"
    var cellIndexpath: IndexPath = [0,0]
    var postCount: Int = 0
    var newPostCount: Int = 0
    var postData: [DetailDrive] = []
    var cellLoadFirst: Bool = true
    
    var lastCount = 0
    var lastId = 0
    
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
    
    func setFilterViewCompletion() {
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
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getData() {
        GetDetailDataService.detailData.getRecommendInfo{ (
            response) in
            switch response
            {
            case .success(let data):
                if let response = data as? DetailModel {
                    print("인기순 데이터")
                    DispatchQueue.global().sync {
                        self.flag = true
                        self.postCount = response.data.drive.count
                        self.postData = response.data.drive
                        self.lastId = response.data.lastID
                        self.lastCount = response.data.lastCount ?? 0
                    }
                    self.postCount = response.data.drive.count
                    self.collectionView.reloadData()
                }
            case .requestErr(let message):
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
                if let response = data as? DetailModel {
                    print("최신순 데이터")
                    DispatchQueue.global().sync {
                        self.flag = true
                        self.postCount = response.data.drive.count
                        self.lastCount = response.data.lastCount ?? 0
                        self.lastId = response.data.lastID
                        self.newPostCount = response.data.drive.count
                        self.postData = response.data.drive
                    }
                    self.collectionView.reloadData()
                }
            case .requestErr(let message):
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
    
    func getInfinityData(postId: Int, count: Int, type: getDataThemeType){
        GetInfinityDetailDataService.detailData.getInfo(postId: postId, count: count, type: type){ (response) in
            switch response
            {
            case .success(let data) :
                if let response = data as? DetailModel {
                    print("무한스크롤 테스트")
                    if response.data.drive.count == 0 {
                        break
                    }
                    self.flag = true
                    DispatchQueue.global().sync {
                        if self.currentState == "인기순"{
                            self.lastCount = response.data.lastCount ?? 0
                            self.lastId = response.data.lastID
                            self.postData.append(contentsOf: response.data.drive)
                        }
                        else{
                            self.lastCount = response.data.lastCount ?? 0
                            self.lastId = response.data.lastID
                            self.postData.append(contentsOf: response.data.drive)
                        }
                    }
                    print(self.postData)
                    self.collectionView.reloadData()
                }
            case .requestErr(let message):
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
            return currentState == "인기순" ? postData.count: postData.count
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
                cell.setData(viewModel: self.configureCommonVeiwModel(index: indexPath.row))
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

extension HomePostVC: MenuClickedDelegate {
    func menuClicked(){
        filterView.isHidden = false
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
    func sendPostDriveElement(data: DriveElement?) {
        let nextVC = PostDetailVC()
        nextVC.setAdditionalDataOfPost(data: data)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func setTagArr(region: String, theme: String, warning: String) -> [String]{
        let temp: [String] = [region == nil ? "": region, theme == nil ? "": theme, warning == nil ? "": warning]
        return temp
    }
    
    private func configureCommonVeiwModel(index: Int) -> CommonCVC.ViewModel {
        var tag = setTagArr(region: postData[index].region,
                                  theme: postData[index].theme,
                                  warning: postData[index].warning ?? "")
        return CommonCVC.ViewModel(
            image: postData[index].image,
            title: postData[index].title,
            tagCount: tag.count,
            tagArr: tag,
            isFavorite: postData[index].isFavorite,
            postID: postData[index].postID,
            height: 60
        )
    }
}

extension HomePostVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = collectionView.contentSize.height
        if(collectionView.contentOffset.y > contentHeight - collectionView.frame.height) && collectionView.contentOffset.x == 0 {
            if flag {
                if currentState == "인기순"{
                    flag = false
                    getInfinityData(postId: lastId, count: lastCount, type: .recommend)
                }
                else {
                    flag = false
                    getInfinityData(postId: lastId, count: lastCount, type: .new)
                }
            }
        }
    }
}
