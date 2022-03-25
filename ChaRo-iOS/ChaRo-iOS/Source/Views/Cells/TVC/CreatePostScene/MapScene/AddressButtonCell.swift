//
//  AddressButtonCell.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/06.
//

import UIKit
import SnapKit
import Then

protocol AddressButtonCellDelegate {
    func addressButtonCellForPreseting(cell: AddressButtonCell)
    func addressButtonCellForRemoving(cell: AddressButtonCell)
    func addressButtonCellForAdding(cell: AddressButtonCell)
}



class AddressButtonCell: UITableViewCell {
    
    enum AddressCellType: String{
        case start = "출발지"
        case mid = "경유지"
        case end = "도착지"
    }
    
    public var address = AddressDataModel()
    public var delegate: AddressButtonCellDelegate?
    public var cellType: AddressCellType = .start

    public var searchButton = UIButton().then {
        $0.layer.borderWidth = 1
        $0.contentHorizontalAlignment = .left
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 47)
        $0.layer.borderColor = UIColor.gray20.cgColor
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .gray10
        $0.setTitleColor(.gray30, for: .normal)
    }
    private var plusButton = UIButton().then {
        //$0.isUserInteractionEnabled = false
        $0.setBackgroundImage(UIImage(named: "icWayPointPlusActive"), for: .normal)
        $0.setBackgroundImage(UIImage(named: "icWayPointPlusInactive"), for: .disabled)
        $0.isEnabled = false
    }
    
    private var minusButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "icWaypointMinusActive"), for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addActionIntoButtons()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setInitContent(of type: AddressCellType) {
        let title = "\(type.rawValue)를 입력해주세요"
        setCellStyleForType(type: type)
        searchButton.setTitle(title, for: .normal)
        searchButton.setTitleColor(.gray30, for: .normal)
    }
    
    public func setAddressText(address: AddressDataModel) {
        print("setAddressText = \(address), cellType = \(cellType)")
        self.address = address
        searchButton.setTitle(address.title, for: .normal)
        searchButton.setTitleColor(.mainBlack, for: .normal)
        if cellType == .end{
            plusButton.isEnabled = true
        }else if cellType == .mid{
            plusButton.isEnabled = false
        }
    }

    private func setCellStyleForType(type: AddressCellType) {
        cellType = type
        print("현재 cell type = \(cellType)")
        switch type {
        case .start:
            setSearchButtonContraints()
        case .end:
            setEndTypeConstraints()
        default:
            setMiddleTypeConstraints()
        }
    }
    
    private func addActionIntoButtons() {
        searchButton.addTarget(self, action: #selector(goToKeywordSearch), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(addCellAction), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(removeCellAction), for: .touchUpInside)
    }
    
    @objc public func goToKeywordSearch(sender: UIButton) {
        print("여기 잘 눌림?")
        delegate?.addressButtonCellForPreseting(cell: self)
    }
    
    @objc private func addCellAction() {
        delegate?.addressButtonCellForAdding(cell: self)
    }
    
    @objc private func removeCellAction() {
        delegate?.addressButtonCellForRemoving(cell: self)
    }
    
}

//MARK: UI Constraints
extension AddressButtonCell{
    private func setSearchButtonContraints() {
        contentView.addSubview(searchButton)
        searchButton.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top).offset(3)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom).offset(-3)
        }
    }

    private func setMiddleTypeConstraints() {
        setSearchButtonContraints()
        contentView.addSubview(minusButton)
        minusButton.snp.makeConstraints{make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(searchButton.snp.trailing)
        }
    }
    
    private func setEndTypeConstraints() {
        setSearchButtonContraints()
        searchButton.isEnabled = false
        contentView.addSubview(plusButton)
        plusButton.snp.makeConstraints{make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(searchButton.snp.trailing)
        }
    }
}
