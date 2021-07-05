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
    public var attentionList = [false, false, false, false]
    
    //작성하기때 사용하려고 우선 빈코드로 만들었습니다!
    public var isEditingMode: Bool = false {
        didSet{
            if isEditingMode{
            }else {
            }
        }
    }
    
    private let titleView = PostCellTitleView(title: "주의사항")

    private var buttonList : [UIButton] = []
    
    private var highwayButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "postAttentionUnselected"), for: .normal)
        button.setTitle("고속도로", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
   
    private var mountainButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "postAttentionUnselected"), for: .normal)
        button.setTitle("산길포함", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    private var beginnerButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "postAttentionUnselected"), for: .normal)
        button.setTitle("초보힘듦", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    private var peopleButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "postAttentionUnselected"), for: .normal)
        button.setTitle("사람많음", for: .normal)
        button.setTitleColor(.gray, for: .normal)
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
        button.setTitleColor(.blue, for: .normal)
        button.setBackgroundImage(UIImage(named: "postAttentionSelected"), for: .normal)
    }
    
    private func configureLayout(){
        addSubviews([titleView,
                     highwayButton,
                     mountainButton,
                     beginnerButton,
                     peopleButton])
        
        titleView.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.height.equalTo(22)
        }
        
        highwayButton.snp.makeConstraints{make in
            make.top.equalTo(titleView.snp.bottom).offset(5)
            make.leading.equalTo(self.snp.leading).offset(14)
            make.trailing.equalTo(self.snp.trailing).offset(-186)
            make.height.equalTo(57)
        }
        
        mountainButton.snp.makeConstraints{make in
            make.top.equalTo(titleView.snp.bottom).offset(5)
            make.leading.equalTo(self.snp.leading).offset(184)
            make.trailing.equalTo(self.snp.trailing).offset(-11)
            make.height.equalTo(57)
        }
        
        beginnerButton.snp.makeConstraints{make in
            make.top.equalTo(highwayButton.snp.bottom).offset(-8)
            make.leading.equalTo(self.snp.leading).offset(14)
            make.trailing.equalTo(self.snp.trailing).offset(-186)
            make.height.equalTo(57)
        }
        
        peopleButton.snp.makeConstraints{make in
            make.top.equalTo(mountainButton.snp.bottom).offset(-8)
            make.leading.equalTo(self.snp.leading).offset(184)
            make.trailing.equalTo(self.snp.trailing).offset(-11)
            make.height.equalTo(57)
        }
    }
    
}

