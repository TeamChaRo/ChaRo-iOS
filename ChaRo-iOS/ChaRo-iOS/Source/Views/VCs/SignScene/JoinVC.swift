//
//  JoinVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/09/13.
//

import UIKit

class JoinVC: UIViewController {

    static let identifier = "JoinVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationConrtroller()
    }
    
    private func configureNavigationConrtroller() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //타이틀 지정해주기
    }
    

    

}
