//
//  JoinInputView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/09/28.
//

import UIKit

class JoinInputView: UIView {
    
    var width: CGFloat?
    
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
    
    var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .gray30
        $0.setTitleColor(.white, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    lazy var stickyView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: width!, height: 48)
    }

    let stickyNextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .gray30
        $0.titleLabel?.font = .notoSansBoldFont(ofSize: 16)
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, subTitle: String, placeholder: String, width: CGFloat) {
        super.init(frame: .zero)
        
        self.width = width
        
        titleLabel.text = title
        subTitleLabel.text = subTitle
        inputTextField.placeholder = placeholder
        
        setConstraints()
        setStickyKeyboardButton(width: width)
    }
    
    private func setConstraints() {
        addSubviews([titleLabel,
                     subTitleLabel,
                     inputTextField,
                     nextButton])
        
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
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-75)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(48)
        }

    }
    
    private func setStickyKeyboardButton(width: CGFloat) {
        stickyView.addSubview(stickyNextButton)
        
        stickyNextButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        inputTextField.inputAccessoryView = stickyView

    }

}

