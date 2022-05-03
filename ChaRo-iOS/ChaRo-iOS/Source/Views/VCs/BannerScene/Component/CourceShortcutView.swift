//
//  CourceShortcutView.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/05/03.
//

import UIKit

import SnapKit
import Then

private class CourceShortcutView: UIView {
    
    private let carImageView = UIImageView(image: ImageLiterals.imgBlueCar)
    private let locationView = UIView()
    private let titleLabel = UILabel().then {
        $0.font = .notoSansBoldFont(ofSize: 17)
        $0.textColor = .black
    }
    private let tagStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.distribution = .equalSpacing
    }
    
    private let thumbnailStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.distribution = .equalSpacing
    }
    
    private let courseContentTextView = UITextView().then {
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.textColor = .gray50
        $0.contentInset = UIEdgeInsets(top: 19, left: 16, bottom: 21, right: 16)
        $0.backgroundColor = .gray10
        $0.layer.cornerRadius = 13
    }
    
    private let descriptionTextView = UITextView().then {
        $0.font = .notoSansMediumFont(ofSize: 15)
        $0.textColor = .gray50
    }
    
    private let shourtcutButton = UIButton().then {
        $0.backgroundColor = .mainBlue
        $0.setTitle("드라이브 코스 바로가기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    private var imageSize: CGFloat {
        return (UIScreen.getDeviceWidth() - 45) / 2.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(shortcutData: CourceShortcutDataModel) {
        super.init(frame: .zero)
        configureUI(data: shortcutData)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        self.addSubviews([carImageView, locationView, titleLabel, tagStackView,
                          thumbnailStackView, courseContentTextView, descriptionTextView, shourtcutButton])
        
        carImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(38)
        }
        
        locationView.snp.makeConstraints {
            $0.top.equalTo(carImageView.snp.bottom).inset(13)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(locationView.snp.bottom).inset(13)
            $0.centerX.equalToSuperview()
        }
        tagStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(13)
            $0.centerX.equalToSuperview()
        }
        
        thumbnailStackView.snp.makeConstraints {
            $0.top.equalTo(tagStackView.snp.bottom).inset(22)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(imageSize)
        }
        
        courseContentTextView.snp.makeConstraints {
            $0.top.equalTo(thumbnailStackView.snp.bottom).inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(courseContentTextView.snp.bottom).inset(18)
            $0.leading.trailing.equalToSuperview().inset(89)
            $0.height.equalTo(34)
        }
    }
    
    private func configureUI(data: CourceShortcutDataModel) {
        configLocationView(text: data.location)
        titleLabel.text = data.location
        configStackView(tagList: data.tags)
        configThumnailIamgeViews(images: data.thumnails)
        courseContentTextView.text = data.courseContent
        descriptionTextView.text = data.description
    }
    
    private func configLocationView(text: String) {
        let marker = UIImageView(image: ImageLiterals.icMapStart).then {
            $0.contentMode = .scaleToFill
        }
        let locationLabel = UILabel().then {
            $0.text = text
            $0.font = .notoSansMediumFont(ofSize: 14)
            $0.textColor = .gray50
        }
        
        locationView.addSubviews([marker, locationLabel])
        marker.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }

    private func configThumnailIamgeViews(images: [UIImage]) {
        images.forEach {
            let imageView = UIImageView(image: $0)
            imageView.contentMode = .scaleAspectFit
            thumbnailStackView.addArrangedSubview(imageView)
        }
    }
    
    private func configStackView(tagList: [String]) {
        tagList.forEach {
            tagStackView.addArrangedSubview(getTagButton(text: $0))
        }
    }
    
    private func getTagButton(text: String) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 23)).then {
            $0.setTitle(text, for: .normal)
            $0.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
            $0.layer.cornerRadius = 21
            $0.layer.borderColor = UIColor.mainSkyBlue.cgColor
            $0.layer.borderWidth = 1
        }
        return button
    }
}
