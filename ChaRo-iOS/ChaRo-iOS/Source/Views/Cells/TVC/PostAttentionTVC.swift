//
//  PostAttentionTVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/03.
//

import UIKit
import SnapKit

class PostAttentionTVC: UITableViewCell {

    static let identifier = "PostAttentionTVC"
    private let deviceWidthRate = UIScreen.main.bounds.width / 375
    private let deviceHeightRate = UIScreen.main.bounds.height / 812
    public var attentionList = [false, false, false, false]
    
    
    private let titleView = PostCellTitleView(title: "주의사항")

    private var buttonList : [UIButton] = []
    
    private var highwayButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "postAttentionUnselected"), for: .normal)
        button.setTitle("고속도로", for: .normal)
        button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        button.setTitleColor(.gray40, for: .normal)
        
        return button
    }()
   
    private var mountainButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "postAttentionUnselected"), for: .normal)
        button.setTitle("산길포함", for: .normal)
        button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        button.setTitleColor(.gray40, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private var beginnerButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "postAttentionUnselected"), for: .normal)
        button.setTitle("초보힘듦", for: .normal)
        button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        button.setTitleColor(.gray40, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private var peopleButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "postAttentionUnselected"), for: .normal)
        button.setTitle("사람많음", for: .normal)
        button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        button.setTitleColor(.gray40, for: .normal)
        return button
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setButtonList()
        configureLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public func setAttentionList(list: [Bool]){
        for i in 0..<list.count{
            if list[i] {
                changeToActiveButton(button: buttonList[i])
            }
        }
    }

    private func setButtonList(){
        buttonList.append(contentsOf: [highwayButton,
                                       mountainButton,
                                       beginnerButton,
                                       peopleButton])
    }
    
    private func changeToActiveButton(button: UIButton){
        button.setTitleColor(.mainBlue, for: .normal)
        button.setBackgroundImage(UIImage(named: "postAttentionSelected"), for: .normal)
    }
    
    private func configureLayout(){
        addSubviews([titleView,
                     highwayButton,
                     mountainButton,
                     beginnerButton,
                     peopleButton])
        
        let customGap = Int(181*deviceWidthRate)
        
        titleView.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.height.equalTo(22)
        }
        
        highwayButton.snp.makeConstraints{make in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.equalTo(self.snp.leading).offset(7)
            make.trailing.equalTo(self.snp.trailing).offset(-customGap)
            make.height.equalTo(65)
        }
        
        mountainButton.snp.makeConstraints{make in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.equalTo(self.snp.leading).offset(customGap)
            make.trailing.equalTo(self.snp.trailing).offset(-7)
            make.height.equalTo(65)
        }
        
        beginnerButton.snp.makeConstraints{make in
            make.leading.equalTo(self.snp.leading).offset(7)
            make.trailing.equalTo(self.snp.trailing).offset(-customGap)
            make.bottom.equalTo(self.snp.bottom).offset(-21)
            make.height.equalTo(65)
        }
        
        peopleButton.snp.makeConstraints{make in
            make.leading.equalTo(self.snp.leading).offset(customGap)
            make.trailing.equalTo(self.snp.trailing).offset(-7)
            make.bottom.equalTo(self.snp.bottom).offset(-21)
            make.height.equalTo(65)
        }
    }
    
}

