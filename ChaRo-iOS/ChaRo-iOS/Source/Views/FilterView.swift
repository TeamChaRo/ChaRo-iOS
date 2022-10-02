//
//  FilterView.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2022/03/08.
//

import Foundation
import UIKit
import Then
import SnapKit

class FilterView: UIView {
    private let popularOlderView = FilterCellView(type: .populationOrderCell)
    private let newOlderView = FilterCellView(type: .newOrderCell)
    
    var touchCellCompletion: ((Int) -> Int)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configCell()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configCell() {
        setFilterLayout()
        let popGesture = UITapGestureRecognizer(target: self, action: #selector(isCellClicked(sender:)))
        let newGesture = UITapGestureRecognizer(target: self, action: #selector(isCellClicked(sender:)))
        popularOlderView.addGestureRecognizer(popGesture)
        popularOlderView.tag = 0
        newOlderView.addGestureRecognizer(newGesture)
        newOlderView.tag = 1
        
        popularOlderView.isUserInteractionEnabled = true
        newOlderView.isUserInteractionEnabled = true
        
    }
    private func setFilterLayout() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        addSubviews([popularOlderView, newOlderView])
        
        popularOlderView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(40)
        }
        
        newOlderView.snp.makeConstraints {
            $0.top.equalTo(popularOlderView.snp.bottom).offset(0)
            $0.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(40)
        }
        
    }
    
    
    @objc func isCellClicked(sender: UITapGestureRecognizer) {
        if sender.view == popularOlderView {
            popularOlderView.selectCellColor()
            newOlderView.resetCellColor()
        } else {
            popularOlderView.resetCellColor()
            newOlderView.selectCellColor()
        }
        guard let completion = touchCellCompletion else { return }
        completion(sender.view?.tag ?? 99)
        
    }
}
