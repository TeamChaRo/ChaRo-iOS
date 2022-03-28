//
//  NotificationVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/15.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setShadow()

        // Do any additional setup after loading the view.
    }
    func setShadow() {
        headerView.getShadowView(color: UIColor.black.cgColor, masksToBounds: false, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8, shadowOpacity: 0.3)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
