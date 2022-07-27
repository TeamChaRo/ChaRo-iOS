//
//  PlayListCell.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/06/07.
//

import UIKit

import SnapKit
import Then

final class PlayListTVC: UITableViewCell {
    
    private let viewRatio: CGFloat = UIScreen.getDeviceWidth() / 375.0
    private let albumImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = ImageLiterals.imgAlbumByPale
    }
    
    private let songTitleLabel = UILabel().then {
        $0.font = .notoSansMediumFont(ofSize: 13)
        $0.textColor = .mainBlack
        $0.text = "."
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        contentView.addSubviews([albumImageView, songTitleLabel])
        albumImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(102)
        }
        
        songTitleLabel.snp.makeConstraints {
            $0.top.equalTo(albumImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func setContent(albumImage: UIImage?, title: String) {
        albumImageView.image = albumImage
        songTitleLabel.text = title
    }
}
