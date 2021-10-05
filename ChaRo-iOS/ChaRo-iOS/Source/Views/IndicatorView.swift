//
//  LottieIndicatorView.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/09/19.
//

import Foundation
import UIKit
import Lottie

protocol AnimateIndicatorDelegate {
    func startIndicator()
    func endIndicator()
}

class IndicatorView: UIView{
    let view = UIView()
    lazy var lottieView: AnimationView = {
            let animationView = AnimationView(name: "loading")
            animationView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.stop()
        animationView.loopMode = .loop
        animationView.isHidden = false
        animationView.backgroundColor = .none
        return animationView
        }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    private func loadView(){
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.backgroundColor = .none
        view.backgroundColor = UIColor.mainBlack.withAlphaComponent(0.2)
        addSubview(view)
        addSubview(lottieView)
    }

}
