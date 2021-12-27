//
//  SNSJoinVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/18.
//

import UIKit

class SNSJoinVC: UIViewController {

    static let identifier = "SNSJoinVC"
    var contractView = JoinContractView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    private func configureUI() {
        self.view.addSubview(contractView)
        contractView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
    }
    

    

}
