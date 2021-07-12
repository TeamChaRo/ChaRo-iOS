//
//  CreatePostTitleTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/12.
//

import UIKit
import SnapKit

protocol PostTitlecTVCDelegate: class {
    func updateTextViewHeight(_ cell: CreatePostTitleTVC,_ textView: UITextView,_ height: CGFloat)
}

class CreatePostTitleTVC: UITableViewCell {

    static let identifier: String = "CreatePostTitleTVC"
    weak var delegateCell: PostTitlecTVCDelegate?
    
    // MARK: UI Components
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.text = "제목을 입력해주세요" //placeholder
        textView.textColor = UIColor.gray30
        textView.font = .notoSansRegularFont(ofSize: 14)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.gray20.cgColor
        textView.layer.cornerRadius = 8.0
        textView.isScrollEnabled = false
        textView.addPadding(left: 17, right: 17)
        
        return textView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextView.delegate = self
        selectionStyle = .none
        configureLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension CreatePostTitleTVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        titleTextView.text = ""
        titleTextView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if titleTextView.text.count == 0 {
            textView.text = "제목을 입력해주세요" //placeholder
            textView.textColor = UIColor.gray30
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if titleTextView.text.count > 20 {
            increaseTitleHight()
            
            if let delegate = delegateCell {
                delegate.updateTextViewHeight(self, textView, 64.0)
            }
        } else {
            decreaseTitleHight()
            
            if let delegate = delegateCell {
                delegate.updateTextViewHeight(self, textView, 42.0)
            }
        }
    }
}

extension CreatePostTitleTVC {
    
    // MARK: - Layout
    func configureLayout(){
        addSubview(titleTextView)
        
        titleTextView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(23)
            $0.left.equalTo(self.snp.left).offset(20)
            $0.right.equalTo(self.snp.right).inset(20)
            $0.bottom.equalTo(self.snp.bottom).inset(24)
            $0.height.equalTo(42)
        }
    }
    
    func increaseTitleHight(){
        titleTextView.snp.makeConstraints{
            $0.height.equalTo(64)
        }
    }
    
    func decreaseTitleHight(){
        titleTextView.snp.makeConstraints{
            $0.height.equalTo(42)
        }
    }
    
}

