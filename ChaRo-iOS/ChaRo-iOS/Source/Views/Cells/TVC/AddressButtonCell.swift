//
//  AddressButtonCell.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/06.
//

import UIKit

protocol AddressButtonCellDelegate {
    func addressButtonCellForPreseting(cell: AddressButtonCell)
    func addressButtonCellForRemoving(cell: AddressButtonCell)
    func addressButtonCellForAdding(cell: AddressButtonCell)
}

class AddressButtonCell: UITableViewCell {

    static let identifier = "AddressButtonCell"
    public var address = AddressDataModel()
    public var delegate: AddressButtonCellDelegate?
    public var cellType = ""

    private var searchButton : UIButton = {
        let button = UIButton()
        //style
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray50.cgColor
        button.layer.cornerRadius = 17
        button.backgroundColor = .gray10
        return button
    }()
    
    private var plusButton: UIButton = {
        let button = UIButton()
        //style
        button.backgroundColor = .mainBlue
        return button
    }()
    
    private var minusButton: UIButton = {
        let button = UIButton()
        //style
        button.backgroundColor = .mainOrange
        return button
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addActionIntoButtons()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setInitContentText(text: String){
        let title = "\(text)를 입력해주세요"
        setCellStyleForType(type: text)
        searchButton.setTitle(title, for: .normal)
        searchButton.setTitleColor(.gray30, for: .normal)
    }
    
    public func setAddressText(address: AddressDataModel){
        searchButton.setTitle(address.address, for: .normal)
        searchButton.setTitleColor(.mainBlack, for: .normal)
    }

    public func setAddressText(addressText: String){
        searchButton.setTitle(addressText, for: .normal)
        searchButton.setTitleColor(.mainBlack, for: .normal)
    }
    
    private func setCellStyleForType(type: String){
        cellType = type
        switch type {
        case "출발지":
            setStartTypeConstraints()
        case "도착지":
            setEndTypeConstraints()
        default:
            setMiddleTypeConstraints()
        }
    }
    
    private func addActionIntoButtons(){
        searchButton.addTarget(self, action: #selector(goToKeywordSearch), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(addCellAction), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(removeCellAction), for: .touchUpInside)
    }
    
    private func setStartTypeConstraints(){
        print("setStartTypeConstraints")
        addSubview(searchButton)
        
        searchButton.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top).offset(4)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing).offset(-29)
            make.bottom.equalTo(self.snp.bottom).offset(-4)
        }
        
    }
    
    private func setMiddleTypeConstraints(){
        print("setMiddleTypeConstraints")
        addSubviews([searchButton,minusButton])
        
        searchButton.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top).offset(4)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing).offset(-29)
            make.bottom.equalTo(self.snp.bottom).offset(-4)
        }
        
        minusButton.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top).offset(4)
            make.leading.equalTo(searchButton.snp.trailing).offset(4)
            make.trailing.equalTo(self.snp.trailing).offset(-4)
            make.bottom.equalTo(self.snp.bottom).offset(-4)
        }
    }
    
    private func setEndTypeConstraints(){
        print("setEndTypeConstraints")
        addSubview(searchButton)
        
        searchButton.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top).offset(4)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing).offset(-29)
            make.bottom.equalTo(self.snp.bottom).offset(-4)
        }
        
        addSubview(plusButton)
        plusButton.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top).offset(4)
            make.trailing.equalTo(searchButton.snp.trailing).offset(-5)
            make.bottom.equalTo(self.snp.bottom).offset(-4)
        }
    }
    
    @objc public func goToKeywordSearch(sender: UIButton){
        delegate!.addressButtonCellForPreseting(cell: self)
       
        
    }
    
    @objc private func addCellAction(){
        delegate!.addressButtonCellForAdding(cell: self)
    }
    
    @objc private func removeCellAction(){
        delegate!.addressButtonCellForRemoving(cell: self)
    }
    
}
