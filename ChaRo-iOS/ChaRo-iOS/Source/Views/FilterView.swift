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
    
    var touchCellCompletion: (() -> Void)?
    
    private func configCell() {
        addSubviews([popularOlderView, newOlderView])
        
        popularOlderView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(40)
        }
        
        newOlderView.snp.makeConstraints{
            $0.top.equalTo(popularOlderView.snp.bottom).offset(0)
            $0.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(40)
        }
        
        let popGesture = UITapGestureRecognizer(target: self, action: #selector(isCellClicked(sender:)))
        let newGesture = UITapGestureRecognizer(target: self, action: #selector(isCellClicked(sender:)))
        popularOlderView.addGestureRecognizer(popGesture)
        newOlderView.addGestureRecognizer(newGesture)
        
        popularOlderView.isUserInteractionEnabled = true
        newOlderView.isUserInteractionEnabled = true
        
    }
    
    
    @objc func isCellClicked(sender: UITapGestureRecognizer) {
        if sender.view == popularOlderView {
            popularOlderView.selectCellColor()
            newOlderView.resetCellColor()
        }
        else {
            popularOlderView.resetCellColor()
            newOlderView.selectCellColor()
        }
        guard let completion = touchCellCompletion else { return }
        completion()
        
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(){
        super.init(frame: .zero)
        configCell()
    }

}
