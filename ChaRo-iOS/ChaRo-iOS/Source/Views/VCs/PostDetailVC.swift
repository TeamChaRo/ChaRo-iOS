//
//  PostDetailVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/02.
//

import UIKit

class PostDetailVC: UIViewController {

    @IBOutlet weak var postDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTableView()
    }
    
    private func configureTableView(){
        registerXibs()
        postDetailTableView.delegate = self
        postDetailTableView.dataSource = self
    }
    
    private func registerXibs(){
        postDetailTableView.registerCustomXib(xibName: PostParkingTVC.identifier)
    }
}

//MARK:- TableView Delegate
extension PostDetailVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 151
    }
}

extension PostDetailVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostParkingTVC.identifier) as? PostParkingTVC else {
            return UITableViewCell()
        }
        
        cell.setParkingStatus(status: true)
        cell.setParkingExplanation(text: "100m 이내에 주차공간이 있었어요 :)")
        return cell
    }
    
    
}

