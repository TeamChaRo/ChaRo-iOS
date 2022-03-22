//
//  NotificationVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/15.
//

import UIKit

class NotificationVC: UIViewController {

    // MARK: @IBOutlet
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var notificationListTV: UITableView! {
        didSet {
            notificationListTV.register(cell: NotificationTVC.self)
            notificationListTV.delegate = self
            notificationListTV.dataSource = self
        }
    }
    
    // MARK: Variable
    private var notificationList: [NotificationListModel] = []
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setShadow()
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
    private func setShadow(){
        headerView.getShadowView(color: UIColor.black.cgColor, masksToBounds: false, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8, shadowOpacity: 0.3)
    }
}

// MARK: - UITableViewDataSource
extension NotificationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTVC.className, for: indexPath) as? NotificationTVC else { return UITableViewCell() }
        cell.bindData(model: notificationList[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
}

// MARK: - Network
extension NotificationVC {
    private func getNotificationListData() {
        NotificationService.shared.getNotificationList { response in
            switch(response) {
            case .success(let resultData):
                if let data =  resultData as? [NotificationListModel]{
                    self.notificationList = data
                    self.notificationListTV.reloadData()
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
}
