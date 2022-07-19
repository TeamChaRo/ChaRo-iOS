//
//  ThirdBannerVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/05/17.
//

import UIKit

import SnapKit
import Then

final class ThirdBannerVC: BannerVC {
    
    private var imageViewList: [UIImageView] = []
    private var buttonList: [UIButton] = []
    
    override func setConstraints() {
        super.setConstraints()
        initImageViewList()
        initButtonList()
        if imageViewList.count != 4 && buttonList.count != 2 { return }
        
        scrollView.addSubviews(imageViewList)
        scrollView.addSubviews(buttonList)
        
        imageViewList[0].snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(imageViewList[0].frame.height * viewRetio)
        }
        
        imageViewList[1].snp.makeConstraints {
            $0.top.equalTo(imageViewList[0].snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(imageViewList[1].frame.height * viewRetio)
        }
        
        buttonList[0].snp.makeConstraints {
            $0.top.equalTo(imageViewList[1].snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(93)
            $0.height.equalTo(32 * viewRetio)
        }
        
        imageViewList[2].snp.makeConstraints {
            $0.top.equalTo(buttonList[0].snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(imageViewList[2].frame.height * viewRetio)
        }
        
        buttonList[1].snp.makeConstraints {
            $0.top.equalTo(imageViewList[2].snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(93)
            $0.height.equalTo(32 * viewRetio)
        }
        
        imageViewList[3].snp.makeConstraints {
            $0.top.equalTo(imageViewList[2].snp.bottom).offset(100)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(imageViewList[3].frame.height * viewRetio)
        }
        
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    private func initImageViewList() {
        imageViewList.append(contentsOf: [ UIImageView(image: ImageLiterals.imgCarTheaterCourse1),
                                           UIImageView(image: ImageLiterals.imgCarTheaterCourse2),
                                           UIImageView(image: ImageLiterals.imgCarTheaterCourse3),
                                           UIImageView(image: ImageLiterals.imgCarTheaterCourse4)
        ])
        
        imageViewList.forEach {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
    }
    
    private func initButtonList() {
        for i in 0...1 {
            let button = UIButton().then {
                $0.setTitle("드라이브 코스 바로가기", for: .normal)
                $0.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
                $0.setTitleColor(.white, for: .normal)
                $0.backgroundColor = .blue
                $0.layer.cornerRadius = 8
                $0.tag = i
            }
            buttonList.append(button)
        }
    }
    
    override func bind() {
        super.bind()
        guard buttonList.count == 2 else { return }
        
        buttonList[0].rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let nextVC = PostDetailVC()
                nextVC.setPostId(id: 41)
                self?.present(nextVC, animated: true)
            }).disposed(by: disposeBag)
        
        buttonList[1].rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let nextVC = PostDetailVC()
                nextVC.setPostId(id: 27)
                self?.present(nextVC, animated: true)
            }).disposed(by: disposeBag)

    }
}
