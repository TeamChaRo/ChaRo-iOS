//
//  SearchKeywordCell.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/07.
//

import UIKit
import SnapKit
import Then

class SearchKeywordCell: UITableViewCell {

    private var addressData: AddressDataModel?
    public var presentingMapViewClosure: ((AddressDataModel) -> Void)?
    
    private var titleLabel = UILabel().then {
        $0.font = .notoSansMediumFont(ofSize: 16)
        $0.textColor = .gray50
    }
    
    private var addressLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.textColor = .gray40
    }
    
    var dateLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 12)
        $0.textColor = .gray30
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            presentingMapViewClosure?(addressData!)
        }
    }
    
    private func setupConstraints() {
        contentView.addSubviews([titleLabel,
                     addressLabel,
                     dateLabel])
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(13)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).offset(-70)
        }
        
        addressLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(self.snp.leading).offset(20)
        }
        
        dateLabel.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(16)
            $0.trailing.equalTo(self.snp.trailing).offset(-20)
        }
    }
    
    func setContent(element: AddressDataModel, keyword: String, date: String) {
        titleLabel.text = element.title
        let attributedKeyword = NSMutableAttributedString(string: titleLabel.text ?? "")
        attributedKeyword.addAttribute(.foregroundColor,
                                       value: UIColor.mainBlue,
                                       range: NSString(string: element.title).range(of: keyword))
        titleLabel.attributedText = attributedKeyword
        addressLabel.text = element.address
        dateLabel.text = date
    }
}
