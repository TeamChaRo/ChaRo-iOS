//
//  PostCourseThemeTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/07.
//

import UIKit
import SnapKit

class PostCourseThemeTVC: UITableViewCell {
    
    // MARK: - Title View
    private let themeTitleView = PostCellTitleView(title: "테마")
    private var themeButtonList: [PostDetailContentButton] = []
    private let locationImageView = UIImageView(image: ImageLiterals.icMapStart)
    private let locationLabel = UILabel().then {
        $0.font = .notoSansMediumFont(ofSize: 14)
        $0.textColor = .gray50
    }
    private let themeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.distribution = .fillEqually
    }
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func setEditingMode() {
        for item in themeButtonList {
            item.isUserInteractionEnabled = false
        }
    }
    
    func setContent(city: String, region: String, theme: [String]) {
        guard themeStackView.arrangedSubviews.count == 3 else { return }
        locationLabel.text = getLocationText(city: city, region: region)
        for index in 0..<3 {
            let button = PostDetailContentButton()
            index < theme.count ? button.setContent(title: theme[index], isSelected: true) : button.clearUI()
            themeStackView.insertArrangedSubview(button, at: index)
        }
    }
    
    private func configureUI() {
        selectionStyle = .none
    }
    
    private func setupConstraints() {
        addSubviews([locationImageView, locationLabel, themeTitleView, themeStackView])
     
        locationImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(18)
            $0.width.height.equalTo(18)
        }
        
        locationLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationImageView.snp.centerY)
            $0.leading.equalTo(locationImageView.snp.trailing).offset(6)
        }
    
        themeTitleView.snp.makeConstraints {
            $0.top.equalTo(locationImageView.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(22)
        }
        themeStackView.snp.makeConstraints {
            $0.top.equalTo(themeTitleView.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().offset(-34)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
    }
    
    private func getLocationText(city: String, region: String) -> String{
        if city == "광역시" || city == "특별시" {
            return "\(region)\(city)"
        }
        return "\(city) \(region)"
    }
}

