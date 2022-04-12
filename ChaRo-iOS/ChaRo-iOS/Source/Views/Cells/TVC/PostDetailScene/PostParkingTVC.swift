//
//  PostParkingTVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/03.
//

import UIKit
import SnapKit
import Then

class PostParkingTVC: UITableViewCell {
    
    private let titleView = PostCellTitleView(title: "주차공간")
    private let descriptionTextFeild = UITextField().then {
        $0.backgroundColor = .gray10
        $0.tintColor = .gray50
        $0.addLeftPadding(16)
        $0.layer.cornerRadius = 12
        $0.font = .notoSansRegularFont(ofSize: 14)
    }
    
    private let parkingStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.distribution = .fillEqually
    }
    
    private let yesButton = PostDetailContentButton()
    private let noButton = PostDetailContentButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setContent(isParking: Bool, description: String) {
        descriptionTextFeild.text = description
        yesButton.setContent(title: "있음", isSelected: isParking)
        noButton.setContent(title: "없음", isSelected: !isParking)
    }
    
    public func idEditMode(isEditing: Bool) {
        descriptionTextFeild.isUserInteractionEnabled = isEditing
    }

    private func setupConstraints() {
        contentView.addSubviews([titleView, parkingStackView, descriptionTextFeild])

        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(38)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(22)
        }
        
        parkingStackView.snp.makeConstraints{
            $0.top.equalTo(titleView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        parkingStackView.addArrangedSubviews(views: [yesButton, noButton])
        
        descriptionTextFeild.snp.makeConstraints{
            $0.top.equalTo(parkingStackView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
    }
    
    private func configureUI() {
        selectionStyle = .none
    }
}
