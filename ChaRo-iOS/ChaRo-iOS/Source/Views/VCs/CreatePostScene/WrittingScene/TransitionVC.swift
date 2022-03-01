//
//  TransitionVC.swift
//  ChaRo-iOS
//
//  Created by 황지은 on 2021/12/28.
//

import UIKit

class TransitionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func transitionBtnDidTap(_ sender: UIButton) {
        guard let slideVC = storyboard?.instantiateViewController(withIdentifier: ThemePopupVC.identifier) else { return }
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
}

extension TransitionVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
