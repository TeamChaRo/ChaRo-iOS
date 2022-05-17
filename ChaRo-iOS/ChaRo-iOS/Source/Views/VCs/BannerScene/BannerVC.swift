//
//  BannerVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/05/10.
//

import UIKit

import Then
import RxSwift

class BannerVC: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewRetio: CGFloat = UIScreen.getDeviceWidth() / 375
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        configureUI()
        setConstraints()
        bind()
    }
    
    func setConstraints() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func bind() {
        
    }
}
