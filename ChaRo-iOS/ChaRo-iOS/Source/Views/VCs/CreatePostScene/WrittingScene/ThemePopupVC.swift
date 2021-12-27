//
//  ThemePopupVC.swift
//  ChaRo-iOS
//
//  Created by 황지은 on 2021/11/23.
//

import UIKit
import SnapKit
import Then

class ThemePopupVC: UIViewController {
    
    static let identifier = "ThemePopupVC"
    
    @IBOutlet var themeItemBtns: [UIButton]!
    @IBOutlet var themeTitleLabel: UILabel!
    @IBOutlet var themeTopView: UIView!
    
    private var onlineStatusDotView: UIView!
    private var isAllThemeSeleted: Bool = false
    private var isPresenting = false
    private var filterData = FilterDatas()
    private var currentList: [String] = []
    private var themeList: [Int : String] = [1 : "", 2 : "", 3 : ""]
    private var themeSelectedList: [String] = ["","",""]
    
    //MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        customThemeTopView()
        customThemeItemBtns()
    }
    
    //MARK: Custom Func
    /// setSelectedIndex - Theme 선택시 3개 딕셔너리의 키 값 유무에 따라 테마 선택 순서 지정하는 함수
    func setSelectedIndex(senderIdx: Int) {
        
        if themeList[1] == "" {
            isAllThemeSeleted = false
            themeList[1] = themeItemBtns[senderIdx].titleLabel?.text ?? ""
            insertSelectedImageView(sender: senderIdx, selectedNum: 1)
        }
        else if themeList[1] == "" && senderIdx == 15 {
            insertSelectedImageView(sender: senderIdx, selectedNum: 1)
        }
        else if themeList[2] == "" {
            isAllThemeSeleted = false
            themeList.updateValue(themeItemBtns[senderIdx].titleLabel?.text ?? "", forKey: 2)
            insertSelectedImageView(sender: senderIdx, selectedNum: 2)
        }
        else if themeList[2] == "" && senderIdx == 15 {
            insertSelectedImageView(sender: senderIdx, selectedNum: 2)
        }
        else if themeList[3] == "" {
            isAllThemeSeleted = true
            themeList.updateValue(themeItemBtns[senderIdx].titleLabel?.text ?? "", forKey: 3)
            insertSelectedImageView(sender: senderIdx, selectedNum: 3)
        }
        else if themeList[3] == "" && senderIdx == 15 {
            insertSelectedImageView(sender: senderIdx, selectedNum: 3)
        }
    }
    
    /// removeUnselectedIndex - Theme 선택시 3개 딕셔너리의 키 값 유무에 따라 선택된 테마 값을 remove하는 함수
    func removeUnselectedIndex(senderIdx: Int) {
        
        for (key, value) in themeList {
            if value == themeItemBtns[senderIdx].titleLabel?.text {
                themeList[key] = ""
                removeSelectedImageView(sender: senderIdx)
                isAllThemeSeleted = false
            }
        }
    }
    
    //MARK: IBAction
    @IBAction func dismissBtnDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func themeBtnDidTap(_ sender: UIButton) {
        
        if sender.isSelected {
            removeUnselectedIndex(senderIdx: sender.tag)
            themeItemBtns[sender.tag].backgroundColor = .white
            themeItemBtns[sender.tag].layer.borderColor = UIColor.gray20.cgColor
            sender.isSelected = false
        }
        else {
            if themeItemBtns[15].isSelected || isAllThemeSeleted == true {
                //더 이상 선택 불가 alert 띄우기
                themeItemBtns[sender.tag].isSelected = false
            }
            else {
                themeItemBtns[sender.tag].backgroundColor = .blueSelect
                themeItemBtns[sender.tag].layer.borderColor = UIColor.mainBlue.cgColor
                themeItemBtns[sender.tag].setTitleColor(UIColor.mainBlue, for: .selected)
                sender.isSelected = true
                setSelectedIndex(senderIdx: sender.tag)
            }
        }
    }
    
    @IBAction func confirmThemeBtn(_ sender: UIButton) {
        let sortedDict = themeList.sorted { $0.0 < $1.0 }
        themeSelectedList = Array(sortedDict.map({ $0.value }))
    }
}

//MARK: - UI
extension ThemePopupVC {
    func customThemeTopView() {
        themeTitleLabel.font = .notoSansMediumFont(ofSize: 17)
        themeTopView.layer.cornerRadius = 21
        themeTopView.clipsToBounds = true
        themeTopView.layer.maskedCorners = [ .layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func customThemeItemBtns() {
        themeItemBtns.forEach({
            $0.layer.cornerRadius = 21
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray20.cgColor
            $0.tintColor = .clear
            $0.setTitleColor(UIColor.gray40, for: .normal)
            $0.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        })
        
        currentList = filterData.thema.reversed()
        
        for i in 0...currentList.count - 1 {
            themeItemBtns[i].setTitle(currentList[i], for: .normal)
        }
    }
    
    /// insertSelectedImageView - Theme 선택시 선택 순서 나타내는 ImageView를 addSubView하는 함수
    func insertSelectedImageView(sender: Int, selectedNum: Int) {
        
        let selectNumImageView = UIImageView(frame: CGRect(x: 9, y: 13, width: 14, height:15))
        selectNumImageView.tag = sender + 1
        selectNumImageView.image = UIImage(named: "themeNumber\(selectedNum)")
        selectNumImageView.clipsToBounds = true
        themeItemBtns[sender].addSubview(selectNumImageView)
    }
    
    /// removeSelectedImageView - Theme 선택시 선택 순서 나타내는 ImageView를 removeFromSuperView하는 함수
    func removeSelectedImageView(sender: Int) {
        
        for subview in themeItemBtns[sender].subviews {
            if subview.tag == sender + 1 {
                subview.removeFromSuperview()
            }
        }
    }
}
