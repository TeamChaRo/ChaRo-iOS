//
//  PostCellTitleView.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/03.
//

import UIKit
import SnapKit

class PostCellTitleView: UIView {

    private var titleLabel : UILabel = {
        let label = UILabel()
        //style 지정
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
    }
}
