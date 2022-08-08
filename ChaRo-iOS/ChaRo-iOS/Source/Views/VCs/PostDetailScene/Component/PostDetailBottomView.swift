//
//  PostDetailBottomView.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/02/22.
//

import UIKit

import SnapKit
import Then
import RxSwift

class PostDetailBottomView: UIView {
    
    var likeButton = UIButton().then {
        $0.setBackgroundImage(ImageLiterals.icBigHeartInactive, for: .normal)
        $0.setBackgroundImage(ImageLiterals.icBigHeartActive, for: .selected)
    }
    
    var scrapButton = UIButton().then {
        $0.setBackgroundImage(ImageLiterals.icBigSaveInactive, for: .normal)
        $0.setBackgroundImage(ImageLiterals.icBigSaveActive, for: .selected)
    }
    
    var shareButton = UIButton().then {
        $0.setBackgroundImage(ImageLiterals.icShare, for: .normal)
    }
    
    var likeDescriptionButton = UIButton().then {
        $0.titleLabel?.font = .notoSansRegularFont(ofSize: 12)
        $0.setTitleColor(.gray30, for: .normal)
        $0.setTitle("18명이 좋아합니다.", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        drawBackgroundShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        addSubviews([likeButton, likeDescriptionButton,
                     scrapButton, shareButton])
        
        likeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        likeDescriptionButton.snp.makeConstraints {
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.leading.equalTo(likeButton.snp.trailing).inset(2)
        }
        
        shareButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        scrapButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.trailing.equalTo(shareButton.snp.leading).offset(-14)
            $0.height.equalTo(42)
        }
    }
    
    private func drawBackgroundShadow() {
        self.backgroundColor = .white
        self.layer.shadowOffset = CGSize(width: -1, height: -1)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 5
    }
    
    func changeLikeDescription(to count: Int) {
        likeDescriptionButton.setTitle("\(count)명이 좋아합니다.", for: .normal)
    }
}
