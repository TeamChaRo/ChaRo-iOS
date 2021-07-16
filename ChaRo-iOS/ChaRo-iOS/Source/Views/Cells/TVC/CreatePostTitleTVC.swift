//
//  CreatePostTitleTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/12.
//

import UIKit
import SnapKit

protocol PostTitlecTVCDelegate: class {
    func increaseTextViewHeight(_ cell: CreatePostTitleTVC,_ textView: UITextView)
    func decreaseTextViewHeight(_ cell: CreatePostTitleTVC,_ textView: UITextView)
}

class CreatePostTitleTVC: UITableViewCell {

    static let identifier: String = "CreatePostTitleTVC"
    weak var delegateCell: PostTitlecTVCDelegate?
    
    // MARK: 데이터 전달 closeur
    public var setTitleInfo: ((String) -> Void)?
    private var titleContent: String = "" {
        didSet{
            _ = setTitleInfo?(self.titleContent)
        }
    }
    
    // MARK: textview maxText check
    private var enterFlag: Bool = false // 20자 이상 감지
    private let limitTextCount: Int = 38
    private let limitLineTextCount: Int = 23
    private var isWarning: Bool = false {
        didSet{
            if isWarning {
                warningLabel.isHidden = false
                titleTextView.layer.borderColor = UIColor.mainOrange.cgColor
            } else {
                warningLabel.isHidden = true
                titleTextView.layer.borderColor = UIColor.gray20.cgColor
            }
        }
    }
    
    
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
    
    let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "공백 포함 38자 이내로 작성해주세요."
        label.textColor = UIColor.mainOrange
        label.font = .notoSansRegularFont(ofSize: 11)
        label.isHidden = true
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextView.delegate = self
        configureLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
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
        let textCount = titleTextView.text.count
        
        if textCount <= limitTextCount {
            titleContent = titleTextView.text
            isWarning = isWarning ? false : isWarning
            
            // 1줄 최대 글자수 초과시, textview height 조절
            if textCount > limitLineTextCount { // 1줄 최대 금액 되면 줄바꾸기
                if !enterFlag {
                    titleTextView.text += "\n"
                    enterFlag = true
                    if let delegate = delegateCell {
                        delegate.increaseTextViewHeight(self, textView)
                    }
                }
            } else if textCount <= limitLineTextCount { // 1줄 최대텍스트 이하
                if enterFlag {
                    enterFlag = false
                    if let delegate = delegateCell {
                        delegate.decreaseTextViewHeight(self, textView)
                    }
                }
            }
            
        } else if textCount > limitTextCount {
            titleTextView.text = titleContent
            isWarning = !isWarning ? true : isWarning
        }
    }
}

extension CreatePostTitleTVC {
 
    // MARK: - Layout
    func configureLayout(){
        addSubviews([titleTextView, warningLabel])
        
        titleTextView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(23)
            $0.left.equalTo(self.snp.left).offset(20)
            $0.right.equalTo(self.snp.right).inset(20)
            $0.bottom.equalTo(self.snp.bottom).inset(24)
            $0.height.equalTo(42)
        }
        
        warningLabel.snp.makeConstraints{
            $0.top.equalTo(self.titleTextView.snp.bottom).offset(4)
            $0.leading.equalTo(self.snp.leading).offset(20)
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

