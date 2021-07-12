//
//  CreatePostTitleTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/12.
//

import UIKit

class CreatePostTitleTVC: UITableViewCell {

    static let identifier: String = "CreatePostTitleTVC"
    
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.text = "제목을 입력해주세요" //placeholder
        textView.textColor = UIColor.gray30
        
        return textView
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

