//
//  PostPhotoCVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/16.
//

import UIKit
import SnapKit
import Then

final class PostPhotoCVC: UICollectionViewCell{

    private let imageView = UIImageView().then{
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContraints() {
        addSubview(imageView)
        imageView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setImage(to imgString: String) {
        imageView.kf.setImage(with: URL(string: imgString))
    }
    
}
