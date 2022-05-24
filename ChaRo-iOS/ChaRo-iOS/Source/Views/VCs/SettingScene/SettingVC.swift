//
//  SettingVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/12/29.
//

import UIKit
import SnapKit
import Then
import CoreMIDI

class SettingVC: UIViewController {
    let userWidth = UIScreen.main.bounds.width
    let userheight = UIScreen.main.bounds.height
//MARK: Var
        var permissionModel = [settingDataModel(titleString: "알림", isToggle: true, toggleData: true),
                               settingDataModel(titleString: "사진", isToggle: true, toggleData: true),
                               settingDataModel(titleString: "이메일 수신 동의", isToggle: true, toggleData: true)]
        
        var accountModel = [settingDataModel(titleString: "프로필 수정", titleLabelColor: UIColor.black),
                            settingDataModel(titleString: "비밀번호 수정", titleLabelColor: UIColor.black),
                            settingDataModel(titleString: "이메일", titleLabelColor: UIColor.black, isSubLabel: true, subLabelString: UserDefaults.standard.string(forKey: "userId") ?? "ios@gamil.com", subLabelColor: UIColor.black)]
        
        var infoInquiryModel = [settingDataModel(titleString: "공지사항", titleLabelColor: UIColor.black),
                                settingDataModel(titleString: "1:1 문의", titleLabelColor: UIColor.black)]
        var termsModel = [settingDataModel(titleString: "개인정보 처리방침", titleLabelColor: UIColor.black),
                          settingDataModel(titleString: "서비스 이용약관", titleLabelColor: UIColor.black),
                          settingDataModel(titleString: "오픈소스 라이선스", titleLabelColor: UIColor.black),
                          settingDataModel(titleString: "버전 정보", titleLabelColor: UIColor.gray30, isSubLabel: true, subLabelString: "1.0", subLabelColor: UIColor.gray30),
                          settingDataModel(titleString: "로그아웃", titleLabelColor: UIColor.mainBlue),
                          settingDataModel(titleString: "회원탈퇴", titleLabelColor: UIColor.mainOrange)]
    
    //headerView
    private let settingBackgroundView = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    private let headerTitleLabel = UILabel().then {
        $0.text = "설정"
        $0.font = UIFont.notoSansRegularFont(ofSize: 17)
        $0.textColor = UIColor.black
        
    }
    private let backButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "backIcon"), for: .normal)
    }
    private let bottomView = UIView().then {
        $0.backgroundColor = UIColor.gray20
    }
    //tableView
    private let settingTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
//MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderLayout()
        setTableViewLayout()

    }
//MARK: Function
//MARK: ServerFunction
//MARK: LayoutFunction
    func setHeaderLayout() {
        let headerHeigth = userheight * 0.15
        self.view.addSubview(settingBackgroundView)
        settingBackgroundView.addSubviews([headerTitleLabel, backButton, bottomView])
        
        settingBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(headerHeigth)
        }
        headerTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(settingBackgroundView)
            $0.bottom.equalToSuperview().offset(-25)
            $0.width.equalTo(32)
        }
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.leading.equalToSuperview().offset(0)
            $0.centerY.equalTo(headerTitleLabel)
        }
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().offset(0)
            $0.height.equalTo(1)
        }

    }
    
    func setTableViewLayout() {
        
        settingTableView.style
        self.view.addSubview(settingTableView)
        settingTableView.separatorStyle = .none
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.registerCustomXib(xibName: "SettingTVC")
        
        
        settingTableView.snp.makeConstraints {
            $0.top.equalTo(settingBackgroundView.snp.bottom).offset(0)
            $0.leading.trailing.bottom.equalToSuperview().offset(0)
        }
        
    }
    
    

}


extension SettingVC: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bottomView = UIView().then {
            $0.backgroundColor = UIColor.gray20
        }
        let titleLabel = UILabel().then {
            $0.text = ""
            $0.font = UIFont.notoSansRegularFont(ofSize: 12)
            $0.textColor = UIColor.gray50
            $0.textAlignment = .left
        }
        let view = UIView().then {
            $0.backgroundColor = UIColor.white
        }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(19)
            $0.width.equalTo(150)
        }
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(1)
        }
        switch section {
        case 0:
            titleLabel.text = "접근허용"
            bottomView.backgroundColor = UIColor.white
        case 1:
            titleLabel.text = "마케팅 활용 및 광고 수신 동의"
        case 2:
            titleLabel.text = "계정"
        case 3:
            titleLabel.text = "정보"
        case 4:
            titleLabel.text = "고객센터"
        default:
            titleLabel.text = "약관"
    }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView().then {
            $0.backgroundColor = UIColor.white
        }
        return view
    }
}
    
    
extension SettingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 3
        case 5:
            return 6
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTVC.identifier) as? SettingTVC else {return UITableViewCell()}
        var settingData = settingDataModel()
        //각섹션 별 파트입니다.
        switch indexPath.section {
            //0 접근허용
        case 0:
            settingData = permissionModel[indexPath.row]
            //1 마케팅 활용 및 광고 수신 동의
        case 1:
            settingData = permissionModel[2]
            //2 계정
        case 2:
            settingData = accountModel[indexPath.row]
            //3 정보
        case 3:
            settingData = infoInquiryModel[0]
            //4 고객센터
        case 4:
            settingData = infoInquiryModel[1]
            //5 약관
        case 5:
            settingData = termsModel[indexPath.row]
        default:
            return UITableViewCell()

        }
        cell.setData(isToggle: settingData.isToggle,
                     toggleData: settingData.toggleData,
                     isSubLabel: settingData.isSubLabel,
                     subLabelString: settingData.subLabelString,
                     titleString: settingData.titleString,
                     titleLabelColor: settingData.titleLabelColor,
                     subLabelColor: settingData.subLabelColor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            if indexPath.row == 0 {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: ChangeImageVC.identifier) else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: ChangePasswordVC.identifier) else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        default:
            break
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

