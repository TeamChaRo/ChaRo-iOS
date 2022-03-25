//
//  CreatePostDriveCourseTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/12/27.
//

import UIKit
import SnapKit

final class CreatePostDriveCourseTVC: UITableViewCell {

    static let identifier = "CreatePostDriveCourseTVC"

    public var isEditingMode = false
    private let placeHolderText = "드라이브 코스에 대한 설명과 추가적으로 이야기하고 싶은 내용을 마음껏 남겨주세요"
    private let titleView = PostCellTitleView(title: "그래서 제 드라이브 코스는요!")

    public var setCourseDesc: ((String) -> Void)?
    public var contentText = "" {
        didSet{
            _ = setCourseDesc?(self.contentText)
        }
    }
    private let limitTextCount = 280
    private var isWarnning : Bool = false {
        didSet{
            if isWarnning{
                warnningLabel.isHidden = false
                textView.layer.borderColor = UIColor.mainOrange.cgColor
                textCountLabel.textColor = .mainOrange

            }else{
                warnningLabel.isHidden = true
                textView.layer.borderColor = UIColor.gray30.cgColor
                textCountLabel.textColor = .gray30
            }
        }
    }

    public var textCountLabel : UILabel = {
        let label = UILabel()
        label.font = .notoSansRegularFont(ofSize: 11)
        label.textColor = .gray30
        label.text = "0/280자"
        return label
    }()

    private var textView : UITextView = {
        let textView = UITextView()
        textView.font = .notoSansRegularFont(ofSize: 14)
        textView.textColor = .gray30
        textView.backgroundColor = .clear
        textView.isEditable = true
        return textView
    }()

    private let writeFormView: UIView = UIView()

    private let warnningLabel: UILabel = {
        let label = UILabel()
        label.text = "280자 이내로 작성해주세요."
        label.font = .notoSansRegularFont(ofSize: 11)
        label.textColor = .mainOrange
        label.isHidden = true
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }

    public func setContentText(text: String) {
        textView.text = text
        textCountLabel.text = "\(text.count)/280자"
        self.setEditingModeConstraint()
        setTextViewStyle()
    }

    private func setTextViewStyle() {
        textView.isEditable = true
        textView.textColor = .gray30
        textView.text = placeHolderText
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray20.cgColor
        textView.contentInset = UIEdgeInsets(top: 21, left: 16, bottom: 16, right: 16)
    }

    private func setEditingModeConstraint() {
        addSubviews([
            self.titleView,
            self.textView,
            self.textCountLabel,
            self.warnningLabel
        ])

        self.titleView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(22)
        }

        self.textView.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.bottom).offset(12)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.height.equalTo(356)
            $0.bottom.equalTo(self.snp.bottom).inset(16)
        }

        self.textCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.textView.snp.trailing).inset(8)
            $0.bottom.equalTo(self.textView.snp.bottom).inset(12)
        }

        self.warnningLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(4)
            $0.leading.equalTo(self.snp.leading).offset(20)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }

}

//MARK: TextViewDelegate

extension CreatePostDriveCourseTVC: UITextViewDelegate{

    func textViewDidChange(_ textView: UITextView) {
        let textCount = textView.text.count
        if textCount <= limitTextCount {
            textCountLabel.text = "\(textCount)/280자"
            isWarnning = isWarnning ? false : isWarnning
            contentText = textView.text
        }else{
            textView.text = contentText
            isWarnning = !isWarnning ? true : isWarnning
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray30 {
            textView.text = nil
            textView.textColor = .gray50
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeHolderText
            textView.textColor = .gray30
        }
    }

    func removeSpaceInText(text: String) -> Int{
        let stringCount = String(text.filter{ !" \n\t\r".contains($0)})
        return stringCount.count
    }
}
