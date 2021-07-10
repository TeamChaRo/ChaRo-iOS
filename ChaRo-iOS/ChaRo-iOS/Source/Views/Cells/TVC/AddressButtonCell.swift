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
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray20.cgColor
        button.layer.cornerRadius = 17
        button.backgroundColor = .gray10
        button.setTitleColor(.gray30, for: .normal)
        return button
    }()
    
    private var plusButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icWayPointPlusInactive"), for: .normal)
        return button
    }()
    
    private var minusButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icWaypointMinusActive"), for: .normal)
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
        self.address = address
        searchButton.setTitle(address.address, for: .normal)
        searchButton.setTitleColor(.mainBlack, for: .normal)
        
        if cellType == "도착지"{
            plusButton.setBackgroundImage(UIImage(named: "icWayPointPlusActive"), for: .normal)
        }
    }
//
//    public func setAddressText(addressText: String){
//        searchButton.setTitle(addressText, for: .normal)
//        searchButton.setTitleColor(.mainBlack, for: .normal)
//    }
    
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
        print("addActionIntoButtons")
        searchButton.addTarget(self, action: #selector(goToKeywordSearch), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(addCellAction), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(removeCellAction), for: .touchUpInside)
    }
    
    private func setSearchButtonContraints(){
        addSubview(searchButton)
        searchButton.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top).offset(3)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom).offset(-3)
        }
    }
    
    
    private func setStartTypeConstraints(){
        setSearchButtonContraints()
    }
    
    private func setMiddleTypeConstraints(){
        setSearchButtonContraints()
        
        addSubview(minusButton)
        minusButton.snp.makeConstraints{make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(searchButton.snp.trailing)
        }
    }
    
    private func setEndTypeConstraints(){
        setSearchButtonContraints()
        addSubview(plusButton)
        plusButton.snp.makeConstraints{make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(searchButton.snp.trailing)
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
