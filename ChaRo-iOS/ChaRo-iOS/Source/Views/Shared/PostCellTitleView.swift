//
//  PostCellTitleView.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/03.
//

import UIKit
import SnapKit

class PostCellTitleView: UIView {

    //title만 있으면 높이 22
    private var titleLabel : UILabel = {
        let label = UILabel()
        label.font = .notoSansBoldFont(ofSize: 16)
        label.textColor = .mainBlack
        return label
    }()
    
    //subTitle도 있으면 38
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansRegularFont(ofSize: 11)
        label.textColor = .gray40
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String){
        super.init(frame: .zero)
        titleLabel.text = title
        setContraints()
    }
    
    private func setContraints(){
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
        }
        
        titleLabel.font = UIFont.notoSansBoldFont(ofSize: 16)
        titleLabel.textColor = UIColor.mainBlack
    }
}
