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
import SafariServices

class SettingVC: UIViewController {
    
    // MARK: Variable
    private let userWidth = UIScreen.main.bounds.width
    private let userheight = UIScreen.main.bounds.height
    
    private var permissionModel = [settingDataModel(titleString: "알림", isToggle: true, toggleData: true),
                           settingDataModel(titleString: "사진", isToggle: true, toggleData: true),
                           settingDataModel(titleString: "이메일 수신 동의", isToggle: true, toggleData: true)]
    
    private var accountModel = [settingDataModel(titleString: "프로필 수정", titleLabelColor: UIColor.black),
                        settingDataModel(titleString: "비밀번호 수정", titleLabelColor: UIColor.black),
                        settingDataModel(titleString: "이메일", titleLabelColor: UIColor.black, isSubLabel: true, subLabelString: UserDefaults.standard.string(forKey: "userId") ?? "ios@gamil.com", subLabelColor: UIColor.black)]
    
    private var infoInquiryModel = [settingDataModel(titleString: "공지사항", titleLabelColor: UIColor.black),
                            settingDataModel(titleString: "1:1 문의", titleLabelColor: UIColor.black)]
    private var termsModel = [settingDataModel(titleString: "개인정보 처리방침", titleLabelColor: UIColor.black),
                      settingDataModel(titleString: "서비스 이용약관", titleLabelColor: UIColor.black),
                      settingDataModel(titleString: "오픈소스 라이선스", titleLabelColor: UIColor.black),
                      settingDataModel(titleString: "버전 정보", titleLabelColor: UIColor.gray30, isSubLabel: true, subLabelString: "1.0", subLabelColor: UIColor.gray30),
                      settingDataModel(titleString: "로그아웃", titleLabelColor: UIColor.mainBlue),
                      settingDataModel(titleString: "회원탈퇴", titleLabelColor: UIColor.mainOrange)]
    
    // headerView
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
        $0.addTarget(SettingVC.self, action: #selector(backButtonClicked(_:)), for: .touchUpInside)
    }
    
    private let bottomView = UIView().then {
        $0.backgroundColor = UIColor.gray20
    }
    
    // tableView
    private let settingTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderLayout()
        setTableViewLayout()
        
    }
    
    // MARK: Function, ServerFunction, LayoutFunction
    private func setHeaderLayout() {
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
    
    private func setTableViewLayout() {
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

// MARK: - Custom Methods
extension SettingVC {
    
    /// SafariViewController를 불러와 화면전환을 하는 메서드 (인앱)
    private func presentToSafariVC(urlString: String) {
        let url = NSURL(string: urlString)! as URL
        let safariView: SFSafariViewController = SFSafariViewController(url: url)
        self.present(safariView, animated: true, completion: nil)
    }
    
    @objc
    private func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate
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
        view.addSubviews([titleLabel, bottomView])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(19)
            $0.width.equalTo(150)
        }
        
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

// MARK: - UITableViewDataSource
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
        case 0:
            print("접근허용")
        case 1:
            print("마케팅동의")
        case 2:
            print("계정")
        case 3:
            print("정보")
        case 4:
            print("문의")
        case 5:
            switch indexPath.row {
            case 0:
                presentToSafariVC(urlString: "https://nosy-catmint-6ad.notion.site/257d36140ab74dcab89c447171f85c76")
            case 1:
                presentToSafariVC(urlString: "https://nosy-catmint-6ad.notion.site/c930b0349abf41e08061d669863bde95")
            case 2:
                presentToSafariVC(urlString: "https://nosy-catmint-6ad.notion.site/f9a49abdcf91479987faaa83a35eb7a8")
            case 4:
                print("로그아웃")
            case 5:
                print("탈퇴")
            default:
                print("default")
            }
        default:
            print(indexPath.section)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

