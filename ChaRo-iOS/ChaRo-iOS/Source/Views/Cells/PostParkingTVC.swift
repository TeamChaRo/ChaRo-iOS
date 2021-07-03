//
//  PostParkingTVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/03.
//

import UIKit
import SnapKit

class PostParkingTVC: UITableViewCell {

    static let identifier = "PostParkingTVC"
    public var hasParking : Bool?
    
    private let titleView = PostCellTitleView(title: "주차공간")
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 7
        return stackView
    }()
    
    private let yesButton : UIButton = {
        let button = UIButton()
        button.setTitle("있음", for: .normal)
        button.setBackgroundImage(UIImage(named: "postAttentionUnselected"), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    private let noButton : UIButton = {
        let button = UIButton()
        button.setTitle("없음", for: .normal)
        button.setBackgroundImage(UIImage(named: "postAttentionUnselected"), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    private let parkingExplanationTextFeild: UITextField = {
        let textFeild = UITextField()
        textFeild.background = UIImage(named: "postTextFieldParkingShow")
        textFeild.tintColor = .gray
        textFeild.addLeftPadding(16)
        return textFeild
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        containButtonsInStackView()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setParkingStatus(status: Bool){
        setButtonStyleWithParking(hasParking: status)
    }
    
    public func setParkingExplanation(text: String){
        parkingExplanationTextFeild.text = text
    }
    
    private func setSelectedButtonStyle(button: UIButton){
        button.setBackgroundImage(UIImage(named: "postAttentionSelected"), for: .normal)
        button.setTitleColor(.blue, for: .normal)
    }
    

    private func containButtonsInStackView(){
        stackView.addArrangedSubview(yesButton)
        stackView.addArrangedSubview(noButton)
    }
    
    
    private func setButtonStyleWithParking(hasParking: Bool){
        if hasParking{
            setSelectedButtonStyle(button: yesButton)
        }else{
            setSelectedButtonStyle(button: noButton)
        }
    }
    
    private func configureLayout(){
        addSubview(titleView)
        addSubview(stackView)
        //addSubview(parkingExplanationButton)
        addSubview(parkingExplanationTextFeild)
        
        titleView.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.height.equalTo(22)
        }
        
        stackView.snp.makeConstraints{make in
            make.top.equalTo(titleView.snp.bottom).offset(12)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.height.equalTo(42)
        }
        parkingExplanationTextFeild.snp.makeConstraints{make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.bottom.equalTo(self.snp.bottom).offset(-33)
        }
        
    
    }
}
