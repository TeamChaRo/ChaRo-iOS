//
//  PostCourseThemeTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/07.
//

import UIKit
import SnapKit

class PostCourseThemeTVC: UITableViewCell {

    static let identifier = "PostCourseThemeTVC"
    
    // MARK: - Title View
    let courseTitleView = PostCellTitleView(title: "드라이브 코스 지역")
    let themeTitleView = PostCellTitleView(title: "테마")
    
    // MARK: - Buttons
    var courseButtonList: [UIButton] = []
    var themeButtonList: [UIButton] = []
    
    let cityButton: UIButton = {
        let button = UIButton()
        button.setTitle("서울특별시", for: .normal) // dummy
        button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.setBackgroundImage(UIImage(named: "selectbox_show"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    let regionButton: UIButton = {
        let button = UIButton()
        button.setTitle("마포구", for: .normal) // dummy
        button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.setBackgroundImage(UIImage(named: "selectbox_show"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    let firstThemeButton: UIButton = {
        let button = UIButton()
        button.setTitle("봄", for: .normal) // dummy
        button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.setBackgroundImage(UIImage(named: "selectbox_show"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    let secondThemeButton: UIButton = {
        let button = UIButton()
        button.setTitle("산", for: .normal) // dummy
        button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.setBackgroundImage(UIImage(named: "selectbox_show"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    let thirdThemeButton: UIButton = {
        let button = UIButton()
        button.setTitle("벚꽃", for: .normal) // dummy
        button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.setBackgroundImage(UIImage(named: "selectbox_show"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    let buttonWidthContainer: CGFloat = 148
    let buttonHeightContainer: CGFloat = 70
    
    // MARK: - AwakeFromNib and setSelected
    override func awakeFromNib() {
        super.awakeFromNib()
        setCourseButtonList()
        setThemeButtonList()
        configureLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension PostCourseThemeTVC {
    
    func setCourseButtonList(){
        courseButtonList.append(contentsOf: [cityButton, regionButton])
    }
    
    func setThemeButtonList(){
        courseButtonList.append(contentsOf: [firstThemeButton, secondThemeButton, thirdThemeButton])
    }

    func configureLayout(){
        addSubviews([courseTitleView, cityButton, regionButton, themeTitleView, firstThemeButton, secondThemeButton, thirdThemeButton])
        
        courseTitleView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(37)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).offset(-20)
            $0.height.equalTo(22)
        }
        
        cityButton.snp.makeConstraints {
            $0.top.equalTo(courseTitleView.snp.bottom).inset(2)
            $0.leading.equalTo(self.snp.leading)
            $0.height.equalTo(buttonHeightContainer)
            $0.width.equalTo(self.snp.height).multipliedBy(buttonWidthContainer / buttonHeightContainer)
        }
        
        regionButton.snp.makeConstraints {
            $0.height.equalTo(buttonHeightContainer)
            $0.leading.equalTo(cityButton.snp.trailing).inset(34)
            $0.centerX.equalTo(cityButton.snp.centerX)
        }
        
        themeTitleView.snp.makeConstraints{
            $0.top.equalTo(cityButton.snp.bottom).offset(19)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).offset(-2)
            $0.height.equalTo(22)
        }
        
    }
}
