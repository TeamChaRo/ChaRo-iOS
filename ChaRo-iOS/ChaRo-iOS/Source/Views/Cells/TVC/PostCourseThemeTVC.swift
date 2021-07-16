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
    var themeButtonList: [UIButton] = []
    let buttonMultiplier: CGFloat = 148/70
    
    let cityButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.setBackgroundImage(UIImage(named: "selectbox_show"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    let regionButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.setBackgroundImage(UIImage(named: "selectbox_show"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    // MARK: - AwakeFromNib and setSelected
    override func awakeFromNib(){
        selectionStyle = .none
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool){
        super.setSelected(selected, animated: animated)
    }
    
}

extension PostCourseThemeTVC {
    
    func setCourse(city: String, region: String){
        cityButton.setTitle(city, for: .normal)
        regionButton.setTitle(region, for: .normal)
    }
    
    func setTheme(theme: [String]){
        themeButtonList = [] // 빈배열로 초기화
        for i in 0..<theme.count {
            let themeButton: UIButton = {
                let button = UIButton()
                button.setTitle(theme[i], for: .normal)
                button.titleLabel?.font = UIFont.notoSansMediumFont(ofSize: 14)
                button.setTitleColor(UIColor.mainBlue, for: .normal)
                button.setBackgroundImage(UIImage(named: "selectbox_show"), for: .normal)
                button.imageView?.contentMode = .scaleAspectFill
                return button
            }()
            setThemeButtonList(themeButton: themeButton)
        }
    }
    
    func setThemeButtonList(themeButton: UIButton){
        themeButtonList.append(themeButton)
    }

    func configureLayout(){
        addSubviews([courseTitleView, cityButton, regionButton, themeTitleView])
        
        courseTitleView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(37)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).offset(-20)
            $0.height.equalTo(22)
        }
        
        cityButton.snp.makeConstraints {
            $0.top.equalTo(courseTitleView.snp.bottom).inset(2)
            $0.height.equalTo(70)
            $0.leading.equalTo(self.snp.leading)
            $0.width.equalTo(self.cityButton.snp.height).multipliedBy(buttonMultiplier)
        }
        
        regionButton.snp.makeConstraints {
            $0.leading.equalTo(cityButton.snp.trailing).inset(34)
            $0.height.equalTo(70)
            $0.width.equalTo(self.cityButton.snp.height).multipliedBy(buttonMultiplier)
            $0.centerY.equalTo(cityButton.snp.centerY)
        }
        
        themeTitleView.snp.makeConstraints {
            $0.top.equalTo(cityButton.snp.bottom).offset(19)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).offset(-2)
            $0.height.equalTo(22)
        }
    }
    
    func themeButtonConfigureLayer(){
        
        addSubviews(themeButtonList)
        
        themeButtonList[0].snp.makeConstraints {
            $0.top.equalTo(themeTitleView.snp.bottom).inset(2)
            $0.leading.equalTo(self.snp.leading)
            $0.height.equalTo(70)
            $0.width.equalTo(self.cityButton.snp.height).multipliedBy(buttonMultiplier)
        }
        
        if themeButtonList.count > 1 {
            for i in 1..<themeButtonList.count {
                themeButtonList[i].snp.makeConstraints{
                    $0.leading.equalTo(themeButtonList[i-1].snp.trailing).inset(34)
                    $0.height.equalTo(70)
                    $0.width.equalTo(self.cityButton.snp.height).multipliedBy(buttonMultiplier)
                    $0.centerY.equalTo(themeButtonList[i-1].snp.centerY)
                }
            }
        }
    }
    
    func bringButtonToFront(){
        self.bringSubviewToFront(cityButton)
        if themeButtonList.count > 1 {
            for i in 1..<themeButtonList.count {
                self.bringSubviewToFront(themeButtonList[themeButtonList.count-i-1])
            }
        }
    }
}
