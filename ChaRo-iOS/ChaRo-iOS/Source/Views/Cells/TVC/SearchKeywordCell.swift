//
//  SearchKeywordCell.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/07.
//

import UIKit

class SearchKeywordCell: UITableViewCell {

    static let identifier = "SearchKeywordCell"
    private var addressData : AddressDataModel?
    public var presentingMapViewClosure: ((AddressDataModel) -> Void)?
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansMediumFont(ofSize: 16)
        label.textColor = .gray50
        return label
    }()
    
    private var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansRegularFont(ofSize: 14)
        label.textColor = .gray40
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansRegularFont(ofSize: 12)
        label.textColor = .gray30
        label.text = ""
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setConstraints()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            presentingMapViewClosure?(addressData!)
        }
    }
    
    private func setConstraints(){
        addSubviews([titleLabel,
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
    
    public func setContents(addressMadel: AddressDataModel){
        addressData = addressMadel
        titleLabel.text = addressData!.title
        addressLabel.text = addressData!.address
        dateLabel.text = ""
    }
    
    public func setContents(addressMadel: KeywordResult){
        addressData = AddressDataModel(latitude: addressMadel.latitude,
                                       longitude: addressMadel.longitude,
                                       address: addressMadel.address,
                                       title: addressMadel.title)
        titleLabel.text = addressData!.title
        addressLabel.text = addressData!.address
        dateLabel.text = "\(addressMadel.month). \(addressMadel.day)"
    }
}
