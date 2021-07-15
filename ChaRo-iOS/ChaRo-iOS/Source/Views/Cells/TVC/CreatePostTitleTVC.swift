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
    var maxLineFlag: Bool = false // 20자 이상 감지
    
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
        return label
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.endEditing(true)
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
        if !maxLineFlag && titleTextView.text.count == 20 {
            maxLineFlag = true
            titleTextView.text += "\n"
            if let delegate = delegateCell {
                delegate.increaseTextViewHeight(self, textView)
            }
        } else if maxLineFlag && titleTextView.text.count <= 20 {
            maxLineFlag = false
            if let delegate = delegateCell {
                delegate.decreaseTextViewHeight(self, textView)
            }
        } else if maxLineFlag && titleTextView.text.count > 38 {
            setWarningTextField(titleTextView)
            warningConfigureLayout()
            print("38자 넘었어유~")
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
    
    func warningConfigureLayout(){
        addSubview(warningLabel)
        
        warningLabel.snp.makeConstraints{
            $0.top.equalTo(self.titleTextView.snp.bottom).offset(4)
            $0.leading.equalTo(self.snp.leading).offset(21)
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
    
    //MARK: - Function
    func setWarningTextField(_ textView: UITextView){
        textView.layer.borderColor = UIColor.mainOrange.cgColor
        textView.layer.borderWidth = 1
    }
}

