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
    var postTitle: PostTitleDataModel = PostTitleDataModel(title: "서강준이 다녀온 응봉산 드라이브  코스,\n서강준 얼굴 말고 야경을 보여줘!", userName: "킹왕짱 드라이버님", date: "2021년 7월 4일", imageName: "myimage", likedCount: "1.8K")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    

    func setTableView(){
        postDetailTableView.registerCustomXib(xibName: "PostTitleTVC")
        postDetailTableView.delegate = self
        postDetailTableView.dataSource = self
    }

}

extension PostDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let titleCell = tableView.dequeueReusableCell(withIdentifier: PostTitleTVC.identifier, for: indexPath)
        as? PostTitleTVC else { return UITableViewCell() }
        
        titleCell.setTitle(title: postTitle.title, userName: postTitle.userName, date: postTitle.date, imageName: postTitle.imageName, likedCount: postTitle.likedCount)
        
        return titleCell
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 146
    }
    
}
