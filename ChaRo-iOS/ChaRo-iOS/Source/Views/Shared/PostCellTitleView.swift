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
    
    init(title: String, subTitle:String = ""){
        super.init(frame: .zero)
        titleLabel.text = title
        
        if subTitle == ""{
            setTitleContraints()
        }else{
            subTitleLabel.text = subTitle
            setSubTitleContraints()
        }
    }
    
    private func setTitleContraints(){
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
        }
    }
    
    private func setSubTitleContraints(){
        addSubviews([titleLabel,
                     subTitleLabel])
        
        titleLabel.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.height.equalTo(22)
        }
        
        subTitleLabel.snp.makeConstraints{make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(self.snp.leading)
        }
    }
}
