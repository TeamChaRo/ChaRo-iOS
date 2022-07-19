//
//  BannerAboutCell.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/05/23.
//

import UIKit

class BannerAboutCell: UICollectionViewCell {
    
    private let contentImageView = UIImageView().then {
        //$0.contentMode = .scaleAspectFit
        $0.contentMode = .top
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .mainBlue
        $0.font = .notoSansBoldFont(ofSize: 23)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.textColor = .gray50
        $0.font = .notoSansMediumFont(ofSize: 15)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        self.contentView.addSubviews([contentImageView, titleLabel, subTitleLabel])
        
        contentImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setContent(image: UIImage?, title: String, subTitle: String) {
        contentImageView.image = image
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
