//
//  PostResultHeaderCVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/15.
//

import UIKit
import SnapKit

class PostResultHeaderCVC: UICollectionViewCell {

    static let identifier = "PostResultHeaderCVC"
    
    public var filterResultList: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setConstraint()
        print("PostResultHeaderCVC = \(filterResultList)")
    }
    
    public func setStackViewData(list: [String]){
        filterResultList = list
        setConstraint()
    }
    
    
    func setConstraint(){
        let header = setHearderView()
        addSubview(header)
        
        header.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
    }
    
    private func makeTagLabelList() -> [UIButton] {
        var list: [UIButton] = []
        for index in 0..<filterResultList.count {
           
            if filterResultList[index] == "" || filterResultList[index] == "선택안함"{
                continue
            }
            
            let button = UIButton()
            button.titleLabel?.font = .notoSansRegularFont(ofSize: 14)
            button.layer.cornerRadius = 17
            button.layer.borderWidth = 1
            
            if index == 3 {
                button.setTitle(" #\(filterResultList[index])X ", for: .normal)
                button.setTitleColor(.gray30, for: .normal)
                button.layer.borderColor = UIColor.gray30.cgColor
            }else{
                button.setTitle(" #\(filterResultList[index]) ", for: .normal)
                button.setTitleColor(.mainBlue, for: .normal)
                button.layer.borderColor = UIColor.mainLightBlue.cgColor
            }
            
            list.append(button)
        }
        
        return list
    }
    
    
    private func setHearderView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0,
                                        width: UIScreen.getDeviceWidth(),
                                        height: 65))
        
        let stackView = UIStackView(arrangedSubviews: makeTagLabelList())
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints{
            $0.top.equalTo(view.snp.top).offset(0)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.height.equalTo(34)
        }
        return view
    }
   
    

}
