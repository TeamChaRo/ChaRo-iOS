//
//  NotificationVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/15.
//

import UIKit
import SnapKit
import Then

class NotificationVC: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerBottomLineView: UIView! {
        didSet {
            headerBottomLineView.backgroundColor = .gray20
        }
    }
    
    @IBOutlet var notificationListTV: UITableView! {
        didSet {
            notificationListTV.register(cell: NotificationTVC.self)
            notificationListTV.delegate = self
            notificationListTV.dataSource = self
            notificationListTV.separatorInset = .zero
            notificationListTV.separatorColor = .gray20
        }
    }
    
    private let emptyImageView = UIImageView().then {
        $0.image = ImageLiterals.icAlarmEmpty
    }
    
    private let emptyLabel = UILabel().then {
        $0.text = "아직 알림이 없어요."
        $0.font = UIFont.notoSansRegularFont(ofSize: 13.0)
        $0.textColor = .semiBlack
    }
    
    // MARK: Variable
    private var notificationList: [NotificationListModel] = []
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNotificationListData()
    }
    
    // MARK: @IBAction
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UI
extension NotificationVC {
    private func setUIWhenAlarmIsEmpty() {
        notificationListTV.removeFromSuperview()
        view.addSubviews([emptyImageView, emptyLabel])
        
        emptyImageView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(223)
            $0.height.equalTo(calculateHeightbyScreenHeight(originalHeight: 132))
            $0.width.equalTo(calculateHeightbyScreenHeight(originalHeight: 132) * 238 / 132)
            $0.centerX.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(17)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func calculateHeightbyScreenHeight(originalHeight: CGFloat) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return originalHeight * (screenHeight / 812)
    }
}

// MARK: - Custom Methods
extension NotificationVC {
    
    /// 알림 타입에 따라 화면전환을 하는 메서드
    private func navigateByNotificationType(indexPath: IndexPath) {
        if notificationList[indexPath.row].type ?? "" == NotificationType.following.rawValue {
            guard let otherVC = UIStoryboard(name: "OtherMyPage", bundle: nil).instantiateViewController(withIdentifier: "OtherMyPageVC") as? OtherMyPageVC else {return}
            otherVC.setOtherUserID(userID: notificationList[indexPath.row].followed ?? "")
            self.navigationController?.pushViewController(otherVC, animated: true)
        } else {
            let detailVC = PostDetailVC()
            detailVC.setPostId(id: notificationList[indexPath.row].postID ?? -1)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    /// 알림을 읽음처리하는 메서드
    private func readNotification(indexPath: IndexPath) {
        // isRead: 0 - 읽지 않음 // isRead: 1 - 읽음
        if notificationList[indexPath.row].isRead == 0 {
            readNotificationData(pushId: notificationList[indexPath.row].pushID ?? -1)
        }
    }
}

// MARK: - UITableViewDataSource
extension NotificationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTVC.className, for: indexPath) as? NotificationTVC else { return UITableViewCell() }
        cell.setContent(model: notificationList[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationVC: UITableViewDelegate {
    
    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
    
    /// didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        readNotification(indexPath: indexPath)
        navigateByNotificationType(indexPath: indexPath)
    }
}

// MARK: - Network
extension NotificationVC {
    
    /// 알림 목록 조회를 요청하는 메서드
    private func getNotificationListData() {
        NotificationService.shared.getNotificationList { response in
            switch(response) {
            case .success(let resultData):
                if let data =  resultData as? [NotificationListModel]{
                    self.notificationList = data
                    
                    if self.notificationList.count == 0 {
                        self.setUIWhenAlarmIsEmpty()
                    } else {
                        self.notificationListTV.reloadData()
                    }
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    /// 새로 온 알림을 클릭했을 때 '읽음' 요청을 보내는 메서드
    private func readNotificationData(pushId: Int) {
        NotificationService.shared.postNotificationIsRead(pushId: pushId) { response in
            switch(response) {
            case .success(_):
                print("success!")
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}
