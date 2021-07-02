//
//  HomeVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/01.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var HomeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()

        // Do any additional setup after loading the view.
    }
    
    func setTableView(){
        HomeTableView.registerCustomXib(xibName: "HomeAnimationTVC")
        HomeTableView.delegate = self
        HomeTableView.dataSource = self
    }
}

extension HomeVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView : UITableView, heightForRowAt indextPath: IndexPath) -> CGFloat{
        let width = UIScreen.main.bounds.width
        let heigth = UIScreen.main.bounds.height/2
        return heigth
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let homeTableViewCell = tableView.dequeueReusableCell(withIdentifier: HomeAnimationTVC.identifier) as? HomeAnimationTVC else {return UITableViewCell()}
        homeTableViewCell.setDelegate()
        
        return homeTableViewCell
    }
    
    
}
