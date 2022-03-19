//
//  SplashVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/16.
//

import UIKit
import Lottie
import SnapKit

class SplashVC: UIViewController {
    
    static let identifier = "SplashVC"
    let button = UIButton()
    private var animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: { [self] in
            self.presentNextOnBoaring()
        })
    }
    
    private func setUpAnimation(){
       
        animationView.frame = view.bounds
        animationView.animation = Animation.named("lottie_test")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        view.bringSubviewToFront(animationView)
        view.backgroundColor = UIColor.white
       
        view.addSubview(animationView)

        DispatchQueue.main.async {
            self.animationView.play()
        }
     
    }
   
    private func presentNextOnBoaring(){
        print("보내기")
        let storyboard = UIStoryboard(name: "OnBoard", bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: OnBoardVC.identifier)
        nextVC.modalPresentationStyle = .fullScreen
        self.dismiss(animated: true) {
            self.present(nextVC, animated: true, completion: nil)
        }
    }

}
