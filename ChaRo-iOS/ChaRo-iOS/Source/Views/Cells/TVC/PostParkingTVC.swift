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

    private let parkingExplanationTextFeild: UITextField = {
        let textFeild = UITextField()
        textFeild.background = UIImage(named: "postTextFieldParkingShow")
        textFeild.tintColor = .gray
        textFeild.addLeftPadding(16)
        return textFeild
    }()
    
    private let yesButton : UIButton = {
            let button = UIButton()
            button.setTitle("있음", for: .normal)
            button.setBackgroundImage(UIImage(named: "postParkingUnselected"), for: .normal)
            button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
            button.setTitleColor(.gray40, for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
            return button
        }()
        
        private let noButton : UIButton = {
            let button = UIButton()
            button.setTitle("없음", for: .normal)
            button.setBackgroundImage(UIImage(named: "postParkingUnselected"), for: .normal)
            button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
            button.setTitleColor(.gray40, for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
            return button
        }()
    
    private var yesButtonView = UIView()
    private var noButtonView = UIView()
    
    private func setButtonView(view: UIView, text: String, parking: Bool){
        var image = UIImageView()
        let label = UILabel()
        label.text = text
        label.font = UIFont.notoSansMediumFont(ofSize: 14)
        
        if parking {
            print("selected")
            image.image = UIImage(named: "postParkingSelected")
            label.tintColor = .mainBlue
            view.tintColor = .mainBlue
        }else{
            print("Unselected")
            image.image = UIImage(named: "postParkingUnselected")
            label.tintColor = .gray40
            view.tintColor = .gray40
        }
        
        view.addSubviews([image,label])
        
        label.snp.makeConstraints{make in
            make.center.equalTo(view.snp.center)
        }
        
        image.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    public func setParkingStatus(isParking: Bool){
        print("isParking \(isParking)")
        setButtonView(view: yesButtonView, text: "있음", parking: isParking)
        setButtonView(view: noButtonView, text: "없음", parking: !isParking)
    }
    
    public func setParkingStatus(status: Bool){
        changeToActiveButton(hasParking: status)
    }
    
    
    public func setParkingExplanation(text: String){
        parkingExplanationTextFeild.text = text
    }
    
   
    public func idEditMode(isEditing: Bool){
        if isEditing {
            parkingExplanationTextFeild.isUserInteractionEnabled = true
        }else{
            parkingExplanationTextFeild.isUserInteractionEnabled = false
        }
    }
    
    private func setSelectedButtonStyle(button: UIButton){
           button.setBackgroundImage(UIImage(named: "postParkingSelected"), for: .normal)
           button.setTitleColor(.blue, for: .normal)
       }
       
   private func changeToActiveButton(hasParking: Bool){
       if hasParking{
           setSelectedButtonStyle(button: yesButton)
       }else{
           setSelectedButtonStyle(button: noButton)
       }
   }
    
    private func configureLayout(){
        addSubviews([parkingExplanationTextFeild,
                    titleView,
                     yesButton,
                     noButton])
        
        titleView.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.height.equalTo(22)
        }
        
        yesButton.snp.makeConstraints{make in
            make.top.equalTo(titleView.snp.bottom).offset(-3)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing).offset(-181)
            make.height.equalTo(70)
        }
        
        noButton.snp.makeConstraints{make in
            make.top.equalTo(titleView.snp.bottom).offset(-3)
            make.leading.equalTo(self.snp.leading).offset(181)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(70)
        }
    
        parkingExplanationTextFeild.snp.makeConstraints{make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.bottom.equalTo(self.snp.bottom).offset(-33)
            make.height.equalTo(42)
        }
    }
}
