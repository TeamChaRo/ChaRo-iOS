//
//  PostDetailVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/02.
//

import UIKit

class PostDetailVC: UIViewController {

    @IBOutlet weak var postDetailTableView: UITableView!
    
    // MARK: - Dummy data
    var postTitle: PostTitleDataModel = PostTitleDataModel(title: "서강준이 다녀온 응봉산 드라이브  코스,\n서강준 얼굴 말고 야경을 보여줘!",
                                                           userName: "킹왕짱 드라이버님",
                                                           date: "2021년 7월 4일",
                                                           imageName: "myimage",
                                                           likedCount: "1.8K")
    
    var location: [String] = ["출발지", "경유지", "경유지", "도착지"]
    let cellFixedCount: Int = 3 // 0~2 cell은 무조건 존재
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView(){
        registerXibs()
        postDetailTableView.delegate = self
        postDetailTableView.dataSource = self
    }
    
    private func registerXibs(){
        postDetailTableView.registerCustomXib(xibName: PostTitleTVC.identifier)
        postDetailTableView.registerCustomXib(xibName: PostImagesTVC.identifier)
        postDetailTableView.registerCustomXib(xibName: PostParkingTVC.identifier)
        postDetailTableView.registerCustomXib(xibName: PostAttentionTVC.identifier)
        postDetailTableView.registerCustomXib(xibName: PostDriveCourseTVC.identifier)
        postDetailTableView.registerCustomXib(xibName: PostCourseThemeTVC.identifier)
        postDetailTableView.registerCustomXib(xibName: PostLocationTVC.identifier)
        postDetailTableView.registerCustomXib(xibName: PostPathmapTCV.identifier)
    }
    
}


//MARK: TableView Delegate
extension PostDetailVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let rowAdjustment: Int = cellFixedCount + location.count - 1
        
        switch indexPath.row {
        case 0:
            return 146
        case 1:
            return 222
        case 2:
            return 259
        case 3:
            return 50
        case rowAdjustment:
            return 50
        case rowAdjustment+1:
            return 451
        case rowAdjustment+2:
            return 159
        case rowAdjustment+3:
            return 159
        case rowAdjustment+4:
            return 408
        default:
            return 50
        }
    }
}


//MARK: - UITableView extension
extension PostDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7 + location.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowAdjustment: Int = cellFixedCount + location.count - 1
        
        switch indexPath.row {
        case 0:
            return getPostTitleCell(tableView: tableView)
        case 1:
            return getPostImagesCell(tableView: tableView)
        case 2:
            return getPostCourseThemeCell(tableView: tableView)
        case 3:
            return getPostLocationCell(tableView: tableView, row: indexPath.row) // 출발지
        case rowAdjustment:
            return getPostLocationCell(tableView: tableView, row: indexPath.row) // 도착지
        case rowAdjustment+1:
            return getPostPathMapCell(tableView: tableView)
        case rowAdjustment+2:
            return getPostParkingCell(tableView: tableView)
        case rowAdjustment+3:
            return getPostAttensionCell(tableView: tableView)
        case rowAdjustment+4:
            return getPostDriveCourceCell(tableView: tableView)
        default: // 경유지 일로 들어왕
            return getPostLocationCell(tableView: tableView, row: indexPath.row)
        }
    }

}

//MARK: - import cell funcions
extension PostDetailVC {
    func getPostTitleCell(tableView: UITableView) -> UITableViewCell{
        guard let titleCell = tableView.dequeueReusableCell(withIdentifier: PostTitleTVC.identifier)
        as? PostTitleTVC else { return UITableViewCell() }
        
        titleCell.setTitle(title: postTitle.title, userName: postTitle.userName, date: postTitle.date, imageName: postTitle.imageName, likedCount: postTitle.likedCount)
        return titleCell
    }
    
    func getPostAttensionCell(tableView: UITableView) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostAttentionTVC.identifier) as? PostAttentionTVC else { return UITableViewCell()}
        cell.setAttentionList(list: [true,false,false,true])
        return cell
    }
    
    func getPostParkingCell(tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostParkingTVC.identifier) as? PostParkingTVC else {return UITableViewCell()}
        
        cell.setParkingStatus(status: true)
        cell.setParkingExplanation(text: "100m 이내에 주차공간이 있었어요 :)")
        cell.idEditMode(isEditing: false)
        return cell
    }
    
    func getPostImagesCell(tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostImagesTVC.identifier) as? PostImagesTVC else { return UITableViewCell() }
        cell.setImage(["testimage", "Mask Group", "Mask Group"])
        return cell
    }
    
    func getPostDriveCourceCell(tableView: UITableView) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostDriveCourseTVC.identifier) as? PostDriveCourseTVC else {return UITableViewCell()}
        
        cell.setContentText(text: "안녕하세요. 이제 점점 봄이 오나봐요. 아파트 내에 목련과 개나리가 피었더라구요. 코로나19때문에 집콕하는 동안에도, 어김없이 봄과함께 벚꽃축제 시즌이 우리 곁에 왔나봅니다. 가족과 서울 금천 벚꽃 십리길에 드라이브를 갔다왔어요. 길게 뻗은 벚꽃 길의 길이가 3.7Km로 약10리에 달한다고 해요. 딸이 이 얘길 듣고 어찌나 놀라던지. 철도길과 함께 뻗은 길을 따라 드라이브 하면 흩날리는 꽃 비를 즐길 수도 있다고 하네요. 모두 봄의 내음을 듬뿍 받을 수 있는 금천 벚꽃 십리길에 다녀와보세요~:)")
        return cell
    }

    func getPostCourseThemeCell(tableView: UITableView) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCourseThemeTVC.identifier) as? PostCourseThemeTVC else {return UITableViewCell()}
        
        cell.setCourse(city: "서울특별시", region: "마포구")
        cell.setTheme(theme: ["최","인정", "디자인짱"])
        cell.configureLayout()
        cell.themeButtonConfigureLayer()
        cell.bringButtonToFront()
        return cell
    }
    
    func getPostLocationCell(tableView: UITableView, row: Int) -> UITableViewCell{
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostLocationTVC.identifier) as? PostLocationTVC else {return UITableViewCell()}
        
        switch row {
        case 3:
            cell.titleView.titleLabel.text = "출발지"
        case 3+location.count-1:
            cell.titleView.titleLabel.text = "도착지"
        default:
            cell.titleView.titleLabel.text = "경유지"
        }
        
        return cell
    }
    

    func getPostPathMapCell(tableView: UITableView) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPathmapTCV.identifier) as? PostPathmapTCV else {return UITableViewCell()}
        
        return cell
    }
}
