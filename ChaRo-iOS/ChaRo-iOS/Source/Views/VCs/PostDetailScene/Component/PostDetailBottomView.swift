//
//  PostDetailBottomView.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/02/22.
//

import UIKit

class PostDetailBottomView: UIView{
    
    var likeButton = UIButton().then{
        $0.setBackgroundImage(ImageLiterals.icHeartInactive, for: .normal)
        $0.setBackgroundImage(ImageLiterals.icHeartActive, for: .selected)
    }
    
    var scrapButton = UIButton().then{
        $0.setBackgroundImage(ImageLiterals.icScrapInactive, for: .normal)
        $0.setBackgroundImage(ImageLiterals.icScrapActive, for: .selected)
    }
    
    var shareButton = UIButton().then{
        $0.setBackgroundImage(ImageLiterals.icShare, for: .normal)
    }
    
    var likeLabel = UILabel().then{
        $0.font = .notoSansRegularFont(ofSize: 12)
        $0.textColor = .gray30
        $0.text = "18명이 좋아합니다"
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI(){
        addSubviews([likeButton, likeLabel,
                     scrapButton, shareButton])
        
        likeButton.snp.makeConstraints{
            $0.top.equalToSuperview().inset(7)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(5)
        }
        
        likeLabel.snp.makeConstraints{
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.leading.equalTo(likeButton.snp.trailing).inset(2)
        }
        
        shareButton.snp.makeConstraints{
            $0.top.equalToSuperview().inset(7)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(5)
        }
        
        scrapButton.snp.makeConstraints{
            $0.top.equalToSuperview().inset(7)
            $0.trailing.equalTo(shareButton.snp.leading).offset(-14)
            $0.bottom.equalToSuperview().inset(5)
        }
    }
    
}
