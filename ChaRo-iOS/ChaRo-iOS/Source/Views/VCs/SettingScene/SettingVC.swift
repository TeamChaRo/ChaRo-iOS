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
import MessageUI
import PhotosUI

class SettingVC: UIViewController {
    
    // MARK: Variable
    private let userWidth = UIScreen.main.bounds.width
    private let userheight = UIScreen.main.bounds.height
    
    private var permissionModel = [settingDataModel(titleString: "사진", isToggle: true, toggleData: true)]
    
    private var accountModel = [settingDataModel(titleString: "프로필 수정", titleLabelColor: UIColor.black),
                                settingDataModel(titleString: "비밀번호 수정", titleLabelColor: UIColor.black),
                                settingDataModel(titleString: "이메일", titleLabelColor: UIColor.black, isSubLabel: true, subLabelString: Constants.userEmail, subLabelColor: UIColor.black)]
    
    private var infoInquiryModel = [settingDataModel(titleString: "공지사항", titleLabelColor: UIColor.black),
                                    settingDataModel(titleString: "1:1 문의", titleLabelColor: UIColor.black),
                                    settingDataModel(titleString: "신고하기", titleLabelColor: UIColor.black)]
    private var termsModel = [settingDataModel(titleString: "개인정보 처리방침", titleLabelColor: UIColor.black),
                              settingDataModel(titleString: "서비스 이용약관", titleLabelColor: UIColor.black),
                              settingDataModel(titleString: "오픈소스 라이선스", titleLabelColor: UIColor.black),
                              settingDataModel(titleString: "버전 정보", titleLabelColor: UIColor.gray30, isSubLabel: true, subLabelString: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "", subLabelColor: UIColor.gray30),
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
        $0.addTarget(self, action: #selector(backButtonClicked(_:)), for: .touchUpInside)
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
        addNotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
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
        guard let url = URL(string: urlString) else { return }
        let safariView: SFSafariViewController = SFSafariViewController(url: url)
        self.present(safariView, animated: true, completion: nil)
    }
    
    @objc
    private func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 1:1 문의 메일을 보내는 메서드
    private func sendInquiryMail() {
        if MFMailComposeViewController.canSendMail() {
            let compseVC = MFMailComposeViewController().then {
                $0.mailComposeDelegate = self
                $0.setToRecipients(["charo.drive13@gmail.com"])
                $0.setSubject("차로 1:1 문의")
                $0.setMessageBody("1. 문의 유형(문의, 버그 제보, 기타) : \n 2. 회원 닉네임(필요시 기입) : \n 3. 문의 내용 : \n \n \n 문의하신 사항은 차로팀이 신속하게 처리하겠습니다. 감사합니다 :)", isHTML: false)
            }
            self.present(compseVC, animated: true, completion: nil)
        }
        else {
            self.makeAlert(title: "메일 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.")
        }
    }
    
    /// Notification Observer를 추가하는 메서드
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    /// 앱 foreground로 진입했을 때 tableView의 section을 reload하는 메서드(토글 관련)
    @objc func willEnterForeground() {
        settingTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    /// 사진 접근 설정 상태를 토글에 반영하는 메서드
    private func setPhotoSwitchStatus(_ toggle: UISwitch) {
        DispatchQueue.main.async {
            switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
            case .authorized:
                toggle.isOn = true
            case .limited, .restricted, .denied, .notDetermined:
                toggle.isOn = false
            default:
                break
            }
        }
    }
    
    /// LoginSB의 루트 네비게이션 컨트롤러로 화면전환하는 메서드
    private func presentToSignNC() {
        guard let signNC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: SignNC.className)
                as? SignNC else {return}
        signNC.modalPresentationStyle = .overFullScreen
        self.present(signNC, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension SettingVC: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
            titleLabel.text = "계정"
        case 2:
            titleLabel.text = "정보"
        case 3:
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
        case 1:
            return 3
        case 3:
            return 2
        case 4:
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
            setPhotoSwitchStatus(cell.toggle)
            settingData = permissionModel[0]
            //1 계정
        case 1:
            settingData = accountModel[indexPath.row]
            //2 정보
        case 2:
            settingData = infoInquiryModel[0]
            //3 고객센터
        case 3:
            settingData = infoInquiryModel[indexPath.row + 1]
            //4 약관
        case 4:
            settingData = termsModel[indexPath.row]
        default:
            return UITableViewCell()
            
        }
        
        cell.settingDelegate = self
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
        case 1:
            switch indexPath.row {
            case 0:
                print("프로필 수정")
                // TODO: ChangeImageVC 연결
            case 1:
                print("비번 수정")
                // TODO: ChangePasswordVC 연결
            default:
                break
            }
        case 2:
            let noticeVC = NoticeVC()
            self.navigationController?.pushViewController(noticeVC, animated: true)
        case 3:
            switch indexPath.row {
            case 0:
                /// 1:1 문의
                sendInquiryMail()
            case 1:
                /// 신고하기
                presentToSafariVC(urlString: "https://docs.google.com/forms/d/1A1I8b2xQLgKVGsx112udNrHRp51n1p0m2ymot-kofy4/viewform?edit_requested=true")
            default:
                break
            }
        case 4:
            switch indexPath.row {
            case 0, 1, 2:
                /// 개인정보 처리방침, 서비스 이용약관, 오픈소스 라이선스
                let urlData = [
                    "https://nosy-catmint-6ad.notion.site/257d36140ab74dcab89c447171f85c76",
                    "https://nosy-catmint-6ad.notion.site/c930b0349abf41e08061d669863bde95",
                    "https://nosy-catmint-6ad.notion.site/f9a49abdcf91479987faaa83a35eb7a8"]
                presentToSafariVC(urlString: urlData[indexPath.row])
            case 4:
                makeRequestAlert(title: "로그아웃 하시겠습니까?", message: "") { _ in
                    self.presentToSignNC()
                }
            case 5:
                makeRequestAlert(title: "계정을 삭제하시겠습니까?", message: "회원 탈퇴시 계정이 모두 삭제됩니다.\n(단, 작성하신 글은 익명의 형태로 남아 사용자에게 보여집니다.)") { _ in
                    // TODO: 회원탈퇴 서버 연결
                    print("회원탈퇴")
                }
            default:
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension SettingVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - SettingSwitchDelegate
extension SettingVC: SettingSwitchDelegate {
    func switchAction(sender: UISwitch, section: Int) {
        switch section {
        case 0:
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        default:
            break
        }
    }
}
