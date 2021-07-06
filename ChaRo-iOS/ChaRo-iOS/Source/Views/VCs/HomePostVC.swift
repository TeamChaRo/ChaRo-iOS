//
//  HomePostVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/07.
//

import UIKit

class HomePostVC: UIViewController {
    @IBOutlet weak var NavigationTitleLabel: UILabel!
    @IBOutlet weak var homePostTableVIew: UITableView!
    
    func setTableView(){
        homePostTableVIew.delegate = self
        homePostTableVIew.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomePostVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
