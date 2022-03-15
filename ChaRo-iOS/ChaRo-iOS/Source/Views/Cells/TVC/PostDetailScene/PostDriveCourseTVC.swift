//
//  PostDriveCourseTVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/06.
//

import UIKit
import SnapKit
import Then

class PostDriveCourseTVC: UITableViewCell {

    public var isEditingMode = false
    private let titleView = PostCellTitleView(title: "코스 소개")
    
    public var setCourseDesc: ((String) -> Void)?
    public var contentText = "" {
        didSet{
            _ = setCourseDesc?(self.contentText)
        }
    }
    private let limitTextCount = 280
    private var isWarnning: Bool = false {
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
    
    public let textCountLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 11)
        $0.textColor = .gray30
        $0.text = "0/280자"
    }
    
    private let textView = UITextView().then {
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.textColor = .gray50
        $0.backgroundColor = .gray10
        $0.layer.cornerRadius = 12
        $0.contentInset = UIEdgeInsets(top: 21, left: 16, bottom: 16, right: 16)
        $0.isEditable = false
    }
    
    private let writeFormView: UIView = UIView()
    
    private let warnningLabel = UILabel().then {
        $0.text = "280자 이내로 작성해주세요."
        $0.font = .notoSansRegularFont(ofSize: 11)
        $0.textColor = .mainOrange
        $0.isHidden = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        contentView.addSubviews([titleView, textView, textCountLabel, warnningLabel])
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(22)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(356)
        }
        
        textCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(textView.snp.trailing).offset(-8)
            $0.bottom.equalTo(textView.snp.bottom).offset(-8)
        }
        
        warnningLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).inset(8)
            $0.leading.equalTo(textView.snp.leading)
        }
    }
    
    private func configureUI() {
        selectionStyle = .none
    }
    
    public func setContent(text: String){
        textView.text = text
        textCountLabel.text = "\(text.count)/280자"
        //setTextViewStyle()
    }
    
    private func setTextViewStyle(){
        textView.textColor = .gray50
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray50.cgColor
        textView.contentInset = UIEdgeInsets(top: 21, left: 16, bottom: 16, right: 16)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.endEditing(true)
    }
}
