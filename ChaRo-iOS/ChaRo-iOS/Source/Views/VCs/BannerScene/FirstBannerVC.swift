//
//  FirstBannerVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/05/10.
//

import UIKit

import SnapKit
import Then

final class FirstBannerVC: BannerVC {
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = ImageLiterals.imgGangneungCourse
    }
    
    override func setConstraints() {
        super.setConstraints()
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(imageView.frame.height * viewRetio)
        }
    }
}
