//
//  ThemePopupVC.swift
//  ChaRo-iOS
//
//  Created by 황지은 on 2021/11/23.
//

import UIKit
import SnapKit
import Then

enum ThemeRemoveCase {
    case removeFront
    case removeLast
}

class ThemePopupVC: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet var themeBtnItems: [UIButton]!
    @IBOutlet var topTitleLabel: UILabel!
    @IBOutlet var topView: UIView!
    
    // MARK: Variables
    private var filterData = FilterDatas()
    private var themeList: [String] = []
    private var senderIndexList: [Int] = []
    private var removeCase: ThemeRemoveCase?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTopView()
        configureThemeBtns()
    }
    
    // MARK: IBAction
    @IBAction func dismissBtnDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func themeBtnDidTap(_ sender: UIButton) {
        if sender.isSelected {
            let removeIndex = senderIndexList.firstIndex(where: { $0 == sender.tag }) ?? 0
            removeCase = senderIndexList.count == removeIndex + 1 ? .removeLast : .removeFront
            
            configureThemeBtnsBySelect(selectedBtn: sender, isSelected: false, senderTag: sender.tag)
            removeSelectedIndexImageView(senderTag: sender.tag, removeCase: removeCase ?? .removeFront)
            themeList.remove(at: removeIndex)
            senderIndexList.remove(at: removeIndex)
            
            // removeCase: removeFront의 경우 -> 현재 list에 맞는 index를 새로 add
            if !senderIndexList.isEmpty && removeCase == .removeFront {
                for i in 0...senderIndexList.count - 1 {
                    addSelectedIndexImageView(senderTag: senderIndexList[i], selectedIndex: i)
                }
            }
        } else {
            if themeList.count == 3 || themeList.contains("선택안함") {
                // 테마 최대 선택 개수에 도달하거나, "선택안함"이 이미 선택되어 있는 경우
                themeBtnItems[sender.tag].isSelected = false
                makeAlert(title: "", message: themeList.count == 3 ? "테마는 3개까지만 선택할 수 있습니다." : "테마를 추가로 선택하려면 \n‘선택안함’을 취소 후 다시 선택해 주세요.")
            } else {
                configureThemeBtnsBySelect(selectedBtn: sender, isSelected: true, senderTag: sender.tag)
                themeList.append(themeBtnItems[sender.tag].titleLabel?.text ?? "")
                senderIndexList.append(sender.tag)
                addSelectedIndexImageView(senderTag: sender.tag, selectedIndex: senderIndexList.firstIndex(where: { $0 == sender.tag }) ?? 0)
            }
        }
    }
    
    @IBAction func confirmThemeBtn(_ sender: UIButton) {
        var passList: [String] = themeList
        
        if passList.count == 1 {
            passList.append(contentsOf: ["선택안함", "선택안함"])
        } else if passList.count == 2 {
            passList.append("선택안함")
        }
        
        if let presentingVC = presentingViewController as? CreatePostVC {
            presentingVC.theme = passList
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - UI
extension ThemePopupVC {
    private func configureTopView() {
        topTitleLabel.font = .notoSansMediumFont(ofSize: 17)
        topView.layer.cornerRadius = 21
        topView.clipsToBounds = true
        topView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    /// 테마 아이템 버튼들의 첫 UI를 구성하는 함수
    private func configureThemeBtns() {
        themeBtnItems.forEach({
            $0.layer.cornerRadius = 21
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray20.cgColor
            $0.tintColor = .clear
            $0.setTitleColor(UIColor.gray40, for: .normal)
            $0.setTitleColor(UIColor.mainBlue, for: .selected)
            $0.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
        })
        
        let entireFilterList: [String] = filterData.thema.reversed()
        
        for i in 0...entireFilterList.count - 1 {
            themeBtnItems[i].setTitle(entireFilterList[i], for: .normal)
        }
    }
    
    /// 버튼 선택상태에 따라 테마 아이템 버튼들의 UI를 구성하는 함수
    private func configureThemeBtnsBySelect(selectedBtn: UIButton, isSelected: Bool, senderTag: Int) {
        selectedBtn.isSelected = isSelected
        themeBtnItems[senderTag].backgroundColor = isSelected ? .blueSelect : .white
        themeBtnItems[senderTag].layer.borderColor = isSelected ? UIColor.mainBlue.cgColor : UIColor.gray20.cgColor
    }
    
    /// Theme 선택시 선택 순서 나타내는 ImageView를 addSubView하는 함수
    private func addSelectedIndexImageView(senderTag: Int, selectedIndex: Int) {
        let selectIndexImageView = UIImageView(frame: CGRect(x: 9, y: 13, width: 14, height:15))
        selectIndexImageView.tag = senderTag + 1
        selectIndexImageView.image = UIImage(named: "themeNumber\(selectedIndex + 1)")
        selectIndexImageView.clipsToBounds = true
        themeBtnItems[senderTag].addSubview(selectIndexImageView)
    }
    
    /// Theme 선택시 선택 순서 나타내는 ImageView를 removeFromSuperView하는 함수
    private func removeSelectedIndexImageView(senderTag: Int, removeCase: ThemeRemoveCase) {
        
        switch removeCase {
        case .removeLast:
            for subview in themeBtnItems[senderTag].subviews {
                if subview.tag == senderTag + 1 {
                    subview.removeFromSuperview()
                }
            }
        case .removeFront:
            for i in senderIndexList {
                for subview in themeBtnItems[i].subviews {
                    if subview.tag == i + 1 {
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
}
