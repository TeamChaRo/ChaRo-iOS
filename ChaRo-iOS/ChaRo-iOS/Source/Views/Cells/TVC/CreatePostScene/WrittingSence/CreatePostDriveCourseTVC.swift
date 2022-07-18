//
//  CreatePostDriveCourseTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/12/27.
//

import UIKit

import SnapKit
import Then

final class CreatePostDriveCourseTVC: UITableViewCell {

    var isEditingMode = false
    private let placeHolderText = "앞서 담지 못한 드라이브 코스에 대한 소개 및 표현을 자유롭게 해주세요."
    private let titleView = PostCellTitleView(title: "코스 설명")

    var setCourseDesc: ((String) -> Void)?
    private var contentText = "" {
        didSet {
            _ = setCourseDesc?(self.contentText)
        }
    }
    private let limitTextCount = 280
    private var isWarning: Bool = false {
        didSet {
            if isWarning {
                warnningLabel.isHidden = false
                textView.layer.borderColor = UIColor.mainOrange.cgColor
                textCountLabel.textColor = .mainOrange

            } else {
                warnningLabel.isHidden = true
                textView.layer.borderColor = UIColor.gray30.cgColor
                textCountLabel.textColor = .gray30
            }
        }
    }

    private var textCountLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 11)
        $0.textColor = .gray30
        $0.text = "0/280자"
    }

    private var textView = UITextView().then {
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.textColor = .gray30
        $0.backgroundColor = .clear
        $0.isEditable = true
    }

    private let writeFormView = UIView()

    private let warnningLabel = UILabel().then {
        $0.text = "공백 제외 280자 이내로 작성해주세요."
        $0.font = .notoSansRegularFont(ofSize: 11)
        $0.textColor = .mainOrange
        $0.isHidden = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.delegate = self
    }

    public func setContentText(text: String) {
        self.textView.text = text
        self.textCountLabel.text = "\(text.count)/280자"
        self.configureEditingModeLayout()
        self.configureTextViewStyle()
    }

    private func configureTextViewStyle() {
        self.textView.do {
            $0.isEditable = true
            $0.textColor = .gray30
            $0.text = placeHolderText
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray20.cgColor
            $0.contentInset = UIEdgeInsets(top: 21, left: 16, bottom: 16, right: 16)
        }
    }

    private func configureEditingModeLayout() {
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


//MARK: - UITextViewDelegate

extension CreatePostDriveCourseTVC: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let textCount = textView.text.count
        if textCount <= limitTextCount {
            self.textCountLabel.text = "\(textCount)/280자"
            self.isWarning = false
            self.contentText = textView.text
        } else {
            self.textView.text = self.contentText
            self.isWarning = true
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray30 {
            self.textView.text = nil
            self.textView.textColor = .gray50
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            self.textView.text = placeHolderText
            self.textView.textColor = .gray30
        }
    }

    func removeSpaceInText(text: String) -> Int {
        let stringCount = String(text.filter{ !" \n\t\r".contains($0)})
        return stringCount.count
    }
}
