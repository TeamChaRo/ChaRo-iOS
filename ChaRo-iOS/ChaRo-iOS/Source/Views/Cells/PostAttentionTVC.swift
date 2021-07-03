//
//  PostAttentionTVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/03.
//

import UIKit

class PostAttentionTVC: UITableViewCell {

    static let identifier = "PostAttentionTVC"
    
    private let titleView = PostCellTitleView(title: "주의사항")

    private var stackViewRow1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 7
        return stackView
    }()
    
    private var stackViewRow2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 7
        return stackView
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
