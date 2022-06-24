//
//  NoticeTitleTVC.swift
//  ChaRo-iOS
//
//  Created by hwangJi on 2022/04/26.
//

import UIKit

class NoticeTitleTVC: UITableViewCell {

    // MARK: UIComponent
    private let titleLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 14.0)
        $0.textColor = .mainBlack
    }
    private let dateLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 14.0)
        $0.textColor = .gray30
    }
    private let expandBtn = UIButton().then {
        $0.setBackgroundImage(ImageLiterals.icNoticeDown, for: .normal)
    }
    private let bottomLineView = UIView().then {
        $0.backgroundColor = .gray20
    }
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - UI
extension NoticeTitleTVC {
    private func configureUI() {
        addSubviews([titleLabel, dateLabel, expandBtn, bottomLineView])
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.equalToSuperview().inset(13)
        }
        
        expandBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.trailing.equalToSuperview().inset(18)
            $0.width.height.equalTo(48)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

// MARK: - Custom Methods
extension NoticeTitleTVC {
    func setData(model: NoticeDataModel) {
        titleLabel.text = model.title
        dateLabel.text = model.date.convertDateComponentsToString()
    }
}
