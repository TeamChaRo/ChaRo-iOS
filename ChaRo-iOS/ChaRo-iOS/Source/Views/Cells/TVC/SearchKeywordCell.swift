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
        //style
        return label
    }()
    
    private var addressLabel: UILabel = {
        let label = UILabel()
        //style
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
            addressData?.displayContent()
            print("selected = \(selected)")
            presentingMapViewClosure?(addressData!)
        }
        
    }
    
    private func setConstraints(){
        addSubviews([titleLabel,
                     addressLabel])
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(13)
            $0.leading.equalTo(self.snp.leading).offset(20)
        }
        
        addressLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(self.snp.leading).offset(20)
        }
    }
    
    public func setContents(title: String, address: String){
        titleLabel.text = title
        addressLabel.text = address
    }
    
    public func setContents(addressMadel: AddressDataModel){
        addressData = addressMadel
        titleLabel.text = addressData!.title
        addressLabel.text = addressData!.address
    }
    
}
