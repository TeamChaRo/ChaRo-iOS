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
        postDetailTableView.registerCustomXib(xibName: PostParkingTVC.identifier)
        postDetailTableView.registerCustomXib(xibName: PostAttentionTVC.identifier)
    }
    
}


//MARK: TableView Delegate
extension PostDetailVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 159
        case 1:
            return 159
        case 2:
            return 159
        default:
            return 159
        }
    }
}

extension PostDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return getPostTitleCell(tableView: tableView)
        case 1:
            return getPostParkingCell(tableView: tableView)
        case 2:
            return getPostAttensionCell(tableView: tableView)
        default:
            return getPostAttensionCell(tableView: tableView)
        }
    }
    
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
        
        //cell.setParkingStatus(isParking: true)
        cell.setParkingStatus(status: true)
        cell.setParkingExplanation(text: "100m 이내에 주차공간이 있었어요 :)")
        cell.idEditMode(isEditing: false)
        return cell
    }
}
