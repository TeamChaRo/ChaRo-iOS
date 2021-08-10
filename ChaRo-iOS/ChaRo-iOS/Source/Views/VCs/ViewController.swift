//
//  ViewController.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/06/27.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    static let identifier = "ViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func presentingMapView(){
        let storyboard = UIStoryboard(name: "AddressMain", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: AddressMainVC.identifier) as? AddressMainVC else {
            return 
        }
        vc.setAddressListData(list: [])
        
        self.navigationController?.pushViewController(vc, animated: false)
       
    }
 
    
    
    @IBAction func dismissVC(){
        self.dismiss(animated: false, completion: nil)
    }
    
}

