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
    private let popularOlderView = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    private let newOlderView = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(str: String){
        super.init(frame: .zero)
    }

}
