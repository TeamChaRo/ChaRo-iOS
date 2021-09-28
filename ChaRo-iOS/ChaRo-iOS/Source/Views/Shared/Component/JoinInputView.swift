//
//  JoinInputView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/09/28.
//

import UIKit

class JoinInputView: UIView {

    
    var titleLabel = UILabel().then {
        $0.font = .notoSansBoldFont(ofSize: 17)
        $0.textColor = .mainBlack
    }

    var subTitleLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 11)
        $0.textColor = .gray40
    }

    var inputTextField = UITextField().then {
        $0.backgroundColor = .gray10
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray20.cgColor
        $0.addLeftPadding(14)
        $0.clearButtonMode = .whileEditing
    }
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, subTitle: String, placeholder: String) {
        super.init(frame: .zero)
    
        
        titleLabel.text = title
        subTitleLabel.text = subTitle
        inputTextField.placeholder = placeholder
        
        setConstraints()
    }
    
    private func setConstraints() {
        addSubviews([titleLabel,
                     subTitleLabel,
                     inputTextField])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        inputTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(48)
        }

    }


}

