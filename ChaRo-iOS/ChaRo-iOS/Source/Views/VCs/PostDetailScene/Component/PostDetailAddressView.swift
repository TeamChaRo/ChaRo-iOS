//
//  PostDetailAddressView.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/15.
//

import UIKit

final class PostDetailAddressView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.font = .notoSansMediumFont(ofSize: 14)
        $0.textColor = .mainBlack
    }
    
    private let addressTextField = UITextField().then {
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.textColor = .gray50
        $0.addLeftPadding(9)
        $0.addRightPadding(9)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
    }
    
    private let copyButton = UIButton().then {
        $0.setImage(ImageLiterals.icCopy, for: .normal)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        addSubviews([titleLabel, addressTextField, copyButton])
        
        copyButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(copyButton.snp.centerY)
            $0.leading.equalToSuperview().inset(10)
        }
        
        addressTextField.snp.makeConstraints {
            //$0.centerY.equalTo(copyButton.snp.centerY)
            $0.top.bottom.equalToSuperview().inset(3)
            $0.leading.equalTo(titleLabel.snp.trailing).inset(3)
            $0.trailing.equalTo(copyButton.snp.leading).inset(3)
        }
    }
    
}
