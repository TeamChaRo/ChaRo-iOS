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
    
    let addressTextField = UITextField().then {
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.textColor = .gray50
        $0.addLeftPadding(9)
        $0.addRightPadding(9)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.isUserInteractionEnabled = false
    }
    
    private lazy var copyButton = UIButton().then {
        $0.setImage(ImageLiterals.icCopy, for: .normal)
        $0.addTarget(self, action: #selector(touchUpCopyButton), for: .touchUpInside)
    }
    var copyAddressClouser: ((String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.addSubviews([copyButton, titleLabel, addressTextField ])
        
        copyButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(copyButton.snp.centerY)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(43)
        }
        
        addressTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(3)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(3)
            $0.trailing.equalTo(copyButton.snp.leading).offset(-3)
        }
    }
    
    @objc private func touchUpCopyButton() {
        copyAddressClouser?("\(titleLabel.text ?? "")")
        UIPasteboard.general.string = addressTextField.text
    }
}
