//
//  HomePostVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/07.
//

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
    var cellCount = 6
    var topCVCCell : HomePostDetailCVC?
    var postCell: CommonCVC?
    var topText: String = "요즘 뜨는 드라이브"
    var cellIndexpath: IndexPath = [0,0]
    var postCount: Int = 0
    var newPostCount: Int = 0
    var postData: [DetailModel] = []
    var newPostData: [DetailModel] = []
    
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
        dropDownTableview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setShaow()
        setDropdown()
        setRound()
        setNavigationLabel()
        getData()
        getNewData()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)

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
                    self.postCount = response.data.totalCourse
                    self.postData = [response]
                    
                    DispatchQueue.main.async {
                        if self.postData.count > 0{
                            self.collectionView.reloadData()
                        }
                    }
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
                    self.postCount = response.data.totalCourse
                    self.newPostData = [response]
                    
                    DispatchQueue.main.async {
                        if self.postData.count > 0{
                            self.collectionView.reloadData()
                        }
                    }
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
        
      
        cell.titleLabel.font = UIFont.notoSansBoldFont(ofSize: 14)
        
        guard let topCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePostDetailCVC", for: indexPath) as? HomePostDetailCVC else {return UICollectionViewCell()}
        topCell.delegate = self
        if isFirstLoaded {
            isFirstLoaded = false
            topCVCCell = topCell
        }
        
        switch indexPath.row {
        case 0:
            topCVCCell!.setLabel()
            topCVCCell?.postCount = postCount
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

            return cell
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
        delegate?.setTopTitle(name: cell.name)
        dropDownTableview.isHidden = true
        topCVCCell?.setTitle(data: cell.name)
        
        if cell.name == "인기순" {
            getData()
            DispatchQueue.main.async {
                    self.collectionView.reloadData()
            }
        }
        else if cell.name == "최신순"{
            getNewData()
            DispatchQueue.main.async {
                    self.postData = self.newPostData
                    self.collectionView.reloadData()
            }

        }
        
    }
    
}


