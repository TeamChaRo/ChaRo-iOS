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
    private let deviceWidthRate: CGFloat = UIScreen.getDeviceWidth() / 375
    private let deviceHeightRate = UIScreen.getDeviceWidth() / 896
    public var hasParking : Bool?
    
    private let titleView = PostCellTitleView(title: "주차공간")

    private let parkingExplanationTextFeild: UITextField = {
        let textFeild = UITextField()
        textFeild.background = UIImage(named: "uiViewTextfieldParkingShow")
        textFeild.tintColor = .gray
        textFeild.addLeftPadding(36)
        return textFeild
    }()
    
    private let yesButton : UIButton = {
            let button = UIButton()
            button.setTitle("있음", for: .normal)
            button.setBackgroundImage(UIImage(named: "uiViewSelectboxParkingNo"), for: .normal)
            button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
            button.setTitleColor(.gray40, for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
            return button
        }()
        
        private let noButton : UIButton = {
            let button = UIButton()
            button.setTitle("없음", for: .normal)
            button.setBackgroundImage(UIImage(named: "uiViewSelectboxParkingNo"), for: .normal)
            button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
            button.setTitleColor(.gray40, for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
            return button
        }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        yesButton.isUserInteractionEnabled = false
        noButton.isUserInteractionEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setParkingStatus(status: Bool){
        changeToActiveButton(hasParking: status)
    }
    
    
    public func setParkingExplanation(text: String){
        parkingExplanationTextFeild.text = text
    }
    
   
    public func idEditMode(isEditing: Bool){
        parkingExplanationTextFeild.isUserInteractionEnabled = isEditing
    }
    
    private func setSelectedButtonStyle(button: UIButton){
       button.setBackgroundImage(UIImage(named: "uiViewSelectboxParkingYes"), for: .normal)
       button.setTitleColor(.mainBlue, for: .normal)
    }
       
   private func changeToActiveButton(hasParking: Bool){
       if hasParking{
           setSelectedButtonStyle(button: yesButton)
       }else{
           setSelectedButtonStyle(button: noButton)
       }
   }
    
    private func configureLayout(){
        addSubviews([titleView,
                     yesButton,
                     noButton,
                     parkingExplanationTextFeild])
        
        let customGap = 171 * deviceWidthRate
        
        titleView.snp.makeConstraints{make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.height.equalTo(22)
        }
                                               
        yesButton.snp.makeConstraints{make in
            make.top.equalTo(titleView.snp.bottom).offset(0)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing).offset(-customGap)
            make.height.equalTo(70)
        }
        
        noButton.snp.makeConstraints{make in
            make.top.equalTo(titleView.snp.bottom).offset(0)
            make.leading.equalTo(self.snp.leading).offset(customGap)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(70)
        }
    
        parkingExplanationTextFeild.snp.makeConstraints{make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom).offset(-19)
            make.height.equalTo(70)
        }
    }
}
