//
//  CreatePostTitleTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/12.
//

import UIKit

import SnapKit
import Then

protocol PostTitlecTVCDelegate: AnyObject {
    func increaseTextViewHeight(_ cell: CreatePostTitleTVC,_ textView: UITextView)
    func decreaseTextViewHeight(_ cell: CreatePostTitleTVC,_ textView: UITextView)
}

final class CreatePostTitleTVC: UITableViewCell {

    // MARK: Properties
    
    weak var delegateCell: PostTitlecTVCDelegate?
    
    // 데이터 전달 closeur
    var setTitleInfo: ((String) -> Void)?
    private var titleContent: String = "" {
        didSet {
            _ = setTitleInfo?(self.titleContent)
        }
    }
    
    // textview maxText check
    private var enterFlag: Bool = false // 20자 이상 감지
    private let limitTextCount: Int = 38
    private let limitLineTextCount: Int = 23
    private var isWarning: Bool = false {
        didSet {
            if isWarning {
                warningLabel.isHidden = false
                titleTextView.layer.borderColor = UIColor.mainOrange.cgColor
            } else {
                warningLabel.isHidden = true
                titleTextView.layer.borderColor = UIColor.gray20.cgColor
            }
        }
    }
    
    
    // MARK: UI

    private let titleTextView = UITextView().then {
        $0.text = "제목을 입력해주세요"
        $0.textColor = UIColor.gray30
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.gray20.cgColor
        $0.layer.cornerRadius = 12.0
        $0.isScrollEnabled = false
        $0.addPadding(left: 17, right: 17)
    }
    
    private let warningLabel = UILabel().then {
        $0.text = "공백 포함 38자 이내로 작성해주세요."
        $0.textColor = UIColor.mainOrange
        $0.font = .notoSansRegularFont(ofSize: 11)
        $0.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleTextView.delegate = self
        self.configureLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }

}


// MARK: - UITextViewDelegate

extension CreatePostTitleTVC: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        NotificationCenter.default.post(name: .touchTitleTextView, object: nil)
        return true
    }
    
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
        
        if textCount <= self.limitTextCount {
            self.titleContent = titleTextView.text
            self.isWarning = false
            
            // 1줄 최대 글자수 초과시, textview height 조절
            if textCount > self.limitLineTextCount { // 1줄 최대 금액 되면 줄바꾸기
                if self.enterFlag == false {
                    self.titleTextView.text += "\n"
                    self.enterFlag.toggle()
                    if let delegate = delegateCell {
                        delegate.increaseTextViewHeight(self, textView)
                    }
                }
            } else if textCount <= self.limitLineTextCount { // 1줄 최대텍스트 이하
                if self.enterFlag == true {
                    self.enterFlag.toggle()
                    if let delegate = delegateCell {
                        delegate.decreaseTextViewHeight(self, textView)
                    }
                }
            }
        } else if textCount > limitTextCount {
            self.titleTextView.text = titleContent
            self.isWarning = true
        }
    }
}


// MARK: - Layout

extension CreatePostTitleTVC {

    private func configureLayout() {
        self.addSubviews([titleTextView, warningLabel])
        
        self.titleTextView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(23)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.bottom.equalTo(self.snp.bottom).inset(24)
            $0.height.equalTo(42)
        }
        
        self.warningLabel.snp.makeConstraints{
            $0.top.equalTo(self.titleTextView.snp.bottom).offset(4)
            $0.leading.equalTo(self.snp.leading).offset(20)
        }
    }
    
    func increaseTitleHight() {
        titleTextView.snp.makeConstraints{
            $0.height.equalTo(64)
        }
    }
    
    func decreaseTitleHight() {
        titleTextView.snp.makeConstraints{
            $0.height.equalTo(42)
        }
    }
}

