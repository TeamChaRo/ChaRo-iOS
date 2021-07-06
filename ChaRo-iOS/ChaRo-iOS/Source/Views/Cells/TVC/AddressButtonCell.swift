//
//  AddressButtonCell.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/06.
//

import UIKit

protocol AddressButtonCellDelegate {
    func addressButtonCellForRemoving(cell: AddressButtonCell)
    func addressButtonCellForAdding(cell: AddressButtonCell)
}

class AddressButtonCell: UITableViewCell {

    static let identifier = "AddressButtonCell"
    private var cellType = 0
    public var address = AddressDataModel()
    public var delegate: AddressButtonCellDelegate?

    private var searchButton : UIButton = {
        let button = UIButton()
        //style
        return button
    }()
    
    private var plusButton: UIButton = {
        let button = UIButton()
        //style
        button.backgroundColor = .mainMint
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
    
    public func setInitContentText(text: String, isAddress: Bool){
        let title = "\(text)를 입력해주세요"
        //setCellType(type: text)
        setCellStyleForType(type: text)
        searchButton.setTitle(text, for: .normal)
        if isAddress{
            searchButton.setTitleColor(.mainBlack, for: .normal)
        }else{ // basic 스타일
            searchButton.setTitleColor(.gray30, for: .normal)
        }
    }
    
    
    private func setCellType(type: String){
        switch type {
        case "출발지":
            cellType = 0
        case "도착지":
            cellType = 2
        default:
            cellType = 1
        }
    }
    
    private func setCellStyleForType(type: String){
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
            make.trailing.equalTo(self.snp.trailing).offset(-39)
            make.bottom.equalTo(self.snp.bottom).offset(-4)
        }
        
    }
    
    private func setMiddleTypeConstraints(){
        print("setMiddleTypeConstraints")
        addSubviews([searchButton,minusButton])
        
        searchButton.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top).offset(4)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing).offset(-39)
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
        addSubviews([searchButton,plusButton])
        searchButton.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top).offset(4)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing).offset(-39)
            make.bottom.equalTo(self.snp.bottom).offset(-4)
        }
     
        plusButton.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top).offset(4)
            make.leading.equalTo(searchButton.snp.trailing).offset(4)
            make.trailing.equalTo(self.snp.trailing).offset(-4)
            make.bottom.equalTo(self.snp.bottom).offset(-4)
        }
    }
    
    @objc public func goToKeywordSearch(sender: UIButton){
        
    }
    
    @objc private func addCellAction(){
        delegate!.addressButtonCellForAdding(cell: self)
    }
    
    @objc private func removeCellAction(){
        delegate!.addressButtonCellForRemoving(cell: self)
    }
    
}
