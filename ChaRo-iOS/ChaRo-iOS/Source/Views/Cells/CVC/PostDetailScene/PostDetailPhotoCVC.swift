//
//  PostDetailPhotoCVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/06/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class PostDetailPhotoCVC: UICollectionViewCell {
    
    // MARK: - properties
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setImage(to url: String) {
        let url = URL(string: url)
        imageView.kf.setImage(with: url)
    }
}
