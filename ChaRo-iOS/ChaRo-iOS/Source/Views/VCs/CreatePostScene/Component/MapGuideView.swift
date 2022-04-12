//
//  MapGuideAnimationView.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/17.
//

import UIKit
import SnapKit
import Then

final class MapGuideView: UIView {
    
    private let containerView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .white.withAlphaComponent(0.8)
    }
    
    private let markImageIvew = UIImageView(image: ImageLiterals.icMapStart)
    private let contentText = UILabel().then {
        $0.text = "출발지와 목적지를 입력하여 경로를 확인 후,\n경유지를 추가해 경로를 수정할 수 있습니다."
        $0.font = .notoSansMediumFont(ofSize: 14)
        $0.textColor = .gray50
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContraints()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContraints() {
        self.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(73)
        }
        
        containerView.addSubviews([markImageIvew, contentText])
        markImageIvew.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(17)
            $0.bottom.equalToSuperview().inset(22)
            $0.width.equalTo(31)
        }
        
        contentText.snp.makeConstraints {
            $0.centerY.equalTo(markImageIvew.snp.centerY)
            $0.leading.equalTo(markImageIvew.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func configUI() {
        self.backgroundColor = .mainBlack.withAlphaComponent(0.8)
    }
}
