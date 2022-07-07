//
//  SettingVC.swift
//  ChaRo-iOS
//
//  Created by hwangJi on 2022/06/25.
//

import UIKit
import SnapKit
import Then
import SafariServices
import MessageUI
import PhotosUI

final class SettingVC: UIViewController {
    
    // MARK: Properties
    private let naviBarView = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    
    private let naviTitleLabel = UILabel().then {
        $0.text = "설정"
        $0.textColor = UIColor.black
        $0.font = UIFont.notoSansRegularFont(ofSize: 17)
    }
    
    private let backButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "backIcon"), for: .normal)
    }
    
    private let naviBottomView = UIView().then {
        $0.backgroundColor = UIColor.gray20
    }
    
    private let settingTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureButtonAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Configure

extension SettingVC {
    
    // MARK: UI
    private func configureUI() {
        view.addSubviews([naviBarView, settingTableView])
        naviBarView.addSubviews([naviTitleLabel, backButton, naviBottomView])

        naviBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.hasNotch ? UIScreen.getNotchHeight() + 58: 93)
        }
        
        naviTitleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(25)
            $0.centerX.equalTo(naviBarView)
        }
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(naviTitleLabel)
        }
        
        naviBottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        settingTableView.snp.makeConstraints {
            $0.top.equalTo(naviBarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: Button
    private func configureButtonAddTarget() {
        backButton.addTarget(self, action: #selector(backButtonClicked(_:)), for: .touchUpInside)
    }
    
    // MARK: TableView
    private func configureTableView() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.registerCustomXib(xibName: SettingTVC.identifier)
        settingTableView.separatorStyle = .none
    }
    
    // MARK: TableView Header
    private func configureHeaderView(section: Int) -> UIView {
        let headerView = UIView().then {
            $0.backgroundColor = UIColor.white
        }
        
        let bottomView = UIView().then {
            $0.backgroundColor = UIColor.gray20
        }
        
        let titleLabel = UILabel().then {
            $0.font = UIFont.notoSansRegularFont(ofSize: 12)
            $0.textColor = UIColor.gray50
            $0.textAlignment = .left
        }
        
        headerView.addSubviews([titleLabel, bottomView])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(19)
            $0.width.equalTo(150)
        }
        
        bottomView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        switch SettingSection.allCases[section] {
        case .accessAllow:
            titleLabel.text = "접근허용"
            bottomView.backgroundColor = UIColor.white
        case .account:
            titleLabel.text = "계정"
        case .info:
            titleLabel.text = "정보"
        case .serviceCenter:
            titleLabel.text = "고객센터"
        case .terms:
            titleLabel.text = "약관"
        }
        
        return headerView
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
                as? SignNC else { return }
        signNC.modalPresentationStyle = .overFullScreen
        self.present(signNC, animated: true, completion: nil)
    }
    
    @objc
    private func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SettingVC: UITableViewDataSource {
    
    // MARK: numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSection.allCases.count
    }
    
    // MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch SettingSection.allCases[section] {

        case .accessAllow, .info:
            return 1
        case .account:
            return 3
        case .serviceCenter:
            return 2
        case .terms:
            return 6
        }
    }
    
    // MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTVC.identifier) as? SettingTVC else { return UITableViewCell() }
        
        switch SettingSection.allCases[indexPath.section] {
            
        case .accessAllow:
            cell.setData(model: SettingSection.accessAllow.settingData[indexPath.row])
        case .account:
            cell.setData(model: SettingSection.account.settingData[indexPath.row])
        case .info:
            cell.setData(model: SettingSection.info.settingData[indexPath.row])
        case .serviceCenter:
            cell.setData(model: SettingSection.serviceCenter.settingData[indexPath.row])
        case .terms:
            cell.setData(model: SettingSection.terms.settingData[indexPath.row])
        }
        
        cell.settingDelegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingVC: UITableViewDelegate {
    
    // MARK: heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: viewForHeaderInSection
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return configureHeaderView(section: section)
    }
    
    // MARK: heightForHeaderInSection
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // MARK: heightForFooterInSection
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    // MARK: viewForFooterInSection
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView().then {
            $0.backgroundColor = UIColor.white
        }
        return view
    }
    
    // MARK: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                let changeImageVC = ChangeImageVC()
                self.navigationController?.pushViewController(changeImageVC, animated: true)
            case 1:
                let changePasswordVC = ChangePasswordVC()
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
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
                    "https://nosy-catmint-6ad.notion.site/9d02516137d74b42ba8d0b9554903ca7",
                    "https://nosy-catmint-6ad.notion.site/4f9ab2a0143d4867b107b52103043cca",
                    "https://nosy-catmint-6ad.notion.site/c38b40e1910d4ff0bb3b0d44752d678f"]
                presentToSafariVC(urlString: urlData[indexPath.row])
            case 4:
                makeRequestAlert(title: "로그아웃 하시겠습니까?", message: "") { _ in
                    self.presentToSignNC()
                }
            case 5:
                makeRequestAlert(title: "계정을 삭제하시겠습니까?", message: "회원 탈퇴시 계정이 모두 삭제됩니다.\n(단, 작성하신 글은 익명의 형태로 남아 사용자에게 보여집니다.)") { _ in
                    self.deleteAccount()
                }
            default:
                break
            }
        default:
            break
        }
    }
}

// MARK: - Network

extension SettingVC {
    
    /// 회원 탈퇴
    private func deleteAccount() {
        DeleteAccountService.shared.deleteAccount { response in
            switch(response) {
            case .success:
                self.presentToSignNC()
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                self.makeAlert(title: "회원 탈퇴 오류", message: "")
            case .networkFail:
                print("networkFail")
            }
        }
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
    func switchAction(sender: UISwitch) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
}
