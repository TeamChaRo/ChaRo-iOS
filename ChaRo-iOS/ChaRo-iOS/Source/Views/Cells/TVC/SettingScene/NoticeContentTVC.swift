//
//  NoticeContentTVC.swift
//  ChaRo-iOS
//
//  Created by hwangJi on 2022/04/26.
//

import UIKit
import SnapKit
import Then

class NoticeContentTVC: UITableViewCell {

    // MARK: UIComponent
    private let contentTextView = UITextView().then {
        $0.font = .notoSansMediumFont(ofSize: 13.0)
        $0.textColor = .gray50
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
    }
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .gray10
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - UI
extension NoticeContentTVC {
    private func configureUI() {
        addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.trailing.bottom.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Custom Methods
extension NoticeContentTVC {
    func setData(model: NoticeDataModel) {
        contentTextView.text = model.content
    }
}
