//
//  OnBoardCVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/14.
//

import UIKit

class OnBoardCVC: UICollectionViewCell {

    static let identifier = "OnBoardCVC"
    
    private var imageView = UIImageView()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansBoldFont(ofSize: 23)
        label.textColor = .mainBlue
        label.textAlignment = .center
        return label
    }()
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansMediumFont(ofSize: 15)
        label.textColor = .gray50
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setContraints()
    }

    public func setContent(image: UIImage, title: String, subTitle: String) {
        imageView.image = image
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    private func setContraints() {
        addSubviews([imageView,
                     titleLabel,
                     subTitleLabel])
        
        subTitleLabel.snp.makeConstraints{
            $0.bottom.equalTo(self.snp.bottom).offset(-50)
            $0.centerX.equalTo(self.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints{
            $0.bottom.equalTo(subTitleLabel.snp.top).offset(-21)
            $0.centerX.equalTo(self.snp.centerX)
        }
        
        imageView.snp.makeConstraints{
            $0.bottom.equalTo(titleLabel.snp.top).offset(-15)
            $0.top.leading.trailing.equalToSuperview()
        }
    }
    
}
