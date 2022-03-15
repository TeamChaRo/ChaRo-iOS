//
//  PostAttentionTVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/03.
//

import UIKit
import SnapKit

class PostAttentionTVC: UITableViewCell {

    public var attentionList = [false, false, false, false]
    private let titleView = PostCellTitleView(title: "주의사항")

    private let attentionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    private let highwayButton = PostDetailContentButton()
    private let mountainButton = PostDetailContentButton()
    private let beginnerButton = PostDetailContentButton()
    private let peopleButton = PostDetailContentButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setAttentionList(list: [Bool]){
        if list.count != 4 { return }
        highwayButton.setContent(title: "고속도로", isSelected: list[0])
        mountainButton.setContent(title: "산길포함", isSelected: list[1])
        beginnerButton.setContent(title: "초보힘듦", isSelected: list[2])
        peopleButton.setContent(title: "사람많음", isSelected: list[3])
    }

    private func setupConstraints() {
        contentView.addSubviews([titleView, attentionStackView])
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(34)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(22)
        }
        
        attentionStackView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(12)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(92)
        }
        attentionStackView.addArrangedSubviews(views: [getHorizentalStackView(views: [highwayButton, mountainButton]),
                                                       getHorizentalStackView(views: [beginnerButton, peopleButton])])
    }

    private func configureUI() {
        selectionStyle = .none
    }
    
    private func getHorizentalStackView(views: [UIView]) -> UIStackView{
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        return stackView
    }
}

