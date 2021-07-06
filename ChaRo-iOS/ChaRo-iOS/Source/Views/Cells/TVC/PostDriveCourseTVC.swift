//
//  PostDriveCourseTVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/06.
//

import UIKit
import SnapKit

class PostDriveCourseTVC: UITableViewCell {

    static let identifier = "PostDriveCourseTVC"
    public var isEditingMode = false
    private let placeHolderText = "드라이브 코스에 대한 설명과 추가적으로 이야기하고 싶은 내용을 마음껏 남겨주세요"
    private let titleView = PostCellTitleView(title: "제 드라이브 코스는요")
    
    private var contentText = ""
    private let limitTextCount = 10
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
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "postCourseBackgroundImage")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let warnningLabel: UILabel = {
        let label = UILabel()
        label.text = "280자 이내로 작성해주세요."
        label.font = .notoSansRegularFont(ofSize: 11)
        label.textColor = .mainOrange
        label.isHidden = true
        return label
    }()
    
    public func setEditingMode(mode: Bool){
        if mode {
            setEditingModeConstraint()
        }else {
            setNonEditingModeConstraint()
        }
    }
    
    public func setContentText(text: String){
        textView.text = text
        textCountLabel.text = "\(text.count)/280자"
        
        if text == ""{
            setEditingModeConstraint()
            setTextViewStyle()
        }else{
            setNonEditingModeConstraint()
            textView.isEditable = false
            textView.textColor = .gray50
        }
    }
    
    private func setTextViewStyle(){
        textView.isEditable = true
        textView.textColor = .gray30
        textView.text = placeHolderText
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray20.cgColor
        textView.contentInset = UIEdgeInsets(top: 21, left: 16, bottom: 16, right: 16)
    }
    
    private func setEditModeContents(){
        setEditingModeConstraint()
    }
    
    private func setNoneEditModeContents(){
        setNonEditingModeConstraint()
    }
    
    private func setEditingModeConstraint(){
        addSubviews([titleView,
                     textView,
                     textCountLabel,
                     warnningLabel])
        
        titleView.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(20)
            make.height.equalTo(22)
        }
        
        textView.snp.makeConstraints{make in
            make.top.equalTo(titleView.snp.bottom).offset(12)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.height.equalTo(356)
        }
        
        textCountLabel.snp.makeConstraints{make in
            make.trailing.equalTo(textView.snp.trailing).offset(-7)
            make.bottom.equalTo(textView.snp.bottom).offset(-8)
        }
        
        warnningLabel.snp.makeConstraints{make in
            make.top.equalTo(textView.snp.bottom).offset(4)
            make.leading.equalTo(self.snp.leading).offset(20)
        }
        
    }
    
    private func setNonEditingModeConstraint(){
        addSubviews([titleView,
                     backgroundImageView])
        
        titleView.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.height.equalTo(22)
        }
        
        backgroundImageView.snp.makeConstraints{make in
            make.top.equalTo(titleView.snp.bottom).offset(12)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.height.equalTo(356)
        }
        
        addSubviews([textView,textCountLabel])
        
        textView.snp.makeConstraints{make in
            make.top.equalTo(backgroundImageView.snp.top).offset(21)
            make.leading.equalTo(backgroundImageView.snp.leading).offset(16)
            make.trailing.equalTo(backgroundImageView.snp.trailing).offset(-16)
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(-16)
        }
        
        textCountLabel.snp.makeConstraints{make in
            make.trailing.equalTo(backgroundImageView.snp.trailing).offset(-7)
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(-8)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

//MARK: TextViewDelegate
extension PostDriveCourseTVC: UITextViewDelegate{

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

