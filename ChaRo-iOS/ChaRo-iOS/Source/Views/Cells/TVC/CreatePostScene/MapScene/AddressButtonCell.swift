//
//  AddressButtonCell.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/06.
//

import UIKit
import SnapKit
import Then
import RxSwift

protocol AddressButtonCellDelegate {
    func addressButtonCellForPreseting(cell: AddressButtonCell)
    func addressButtonCellForRemoving(cell: AddressButtonCell)
    func addressButtonCellForAdding(cell: AddressButtonCell)
}

enum AddressCellType: String{
    case start = "출발지"
    case mid = "경유지"
    case end = "도착지"
}

class AddressButtonCell: UITableViewCell {
    
    private let disposeBag = DisposeBag()
    public var address = AddressDataModel()
    public var delegate: AddressButtonCellDelegate?
    public var cellType: AddressCellType = .start

    public var searchButton = UIButton().then {
        $0.layer.borderWidth = 1
        $0.contentHorizontalAlignment = .left
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 47)
        $0.layer.borderColor = UIColor.gray20.cgColor
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .gray10
        $0.isEnabled = true
    }
    private var plusButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "icWayPointPlusActive"), for: .normal)
        $0.setBackgroundImage(UIImage(named: "icWayPointPlusInactive"), for: .disabled)
        $0.isEnabled = false
        $0.isHidden = false
    }
    
    private var minusButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "icWaypointMinusActive"), for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bindToButton()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        if cellType == .end{
            plusButton.isEnabled = true
        } else if cellType == .mid{
            plusButton.isEnabled = false
        }
    }
    
    func setContent(of address: AddressDataModel, for type: AddressCellType, at totalCount: Int) {
        setCellStyleForType(type: type)
        if address.title == "" {
            searchButton.setTitle("\(type.rawValue)를 입력해주세요", for: .normal)
            searchButton.setTitleColor(.gray30, for: .normal)
            return
        } else {
            self.address = address
            searchButton.setTitle(address.title, for: .normal)
            searchButton.setTitleColor(.mainBlack, for: .normal)
        }
        
        if cellType == .end {
            let hasMidRoute = (totalCount == 3)
            plusButton.isHidden = hasMidRoute
            plusButton.isEnabled = !hasMidRoute
        } else { return }
    }

    private func setCellStyleForType(type: AddressCellType) {
        cellType = type
        switch type {
        case .start:
            setSearchButtonContraints()
        case .end:
            setEndTypeConstraints()
        default:
            setMiddleTypeConstraints()
        }
    }

    private func bindToButton() {
        searchButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                print("search Button click")
                self.delegate?.addressButtonCellForPreseting(cell: self)
            }).disposed(by: disposeBag)

        plusButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.delegate?.addressButtonCellForAdding(cell: self)
            }).disposed(by: disposeBag)
        
        minusButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.delegate?.addressButtonCellForRemoving(cell: self)
            }).disposed(by: disposeBag)
    }
}

//MARK: UI Constraints
extension AddressButtonCell{
    private func setSearchButtonContraints() {
        contentView.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-3)
            $0.height.equalTo(42)
        }
    }

    private func setMiddleTypeConstraints() {
        setSearchButtonContraints()
        contentView.addSubview(minusButton)
        minusButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(searchButton.snp.trailing)
        }
    }
    
    private func setEndTypeConstraints() {
        setSearchButtonContraints()
        contentView.addSubview(plusButton)
        plusButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(searchButton.snp.trailing)
        }
    }
}
