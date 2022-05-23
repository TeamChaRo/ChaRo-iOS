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
    
    private let firstContentImageView = UIImageView(image: ImageLiterals.imgGangneungCourse1).then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let secondContentImageView = UIImageView(image: ImageLiterals.imgGangneungCourse2).then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }

    override func setConstraints() {
        super.setConstraints()
        scrollView.addSubviews([firstContentImageView, secondContentImageView])
        
        firstContentImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(firstContentImageView.frame.height * viewRetio)
        }
        
        secondContentImageView.snp.makeConstraints {
            $0.top.equalTo(firstContentImageView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(secondContentImageView.frame.height * viewRetio)
        }
    }
}
