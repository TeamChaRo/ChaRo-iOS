//
//  CreatePostVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/11.
//

import Photos
import PhotosUI
import UIKit

import SnapKit
import Then

final class CreatePostVC: UIViewController {

    private enum Metric {
        static let maxCount: Int = 6
    }

    // 데이터 전달
    var postTitle: String = ""
    var province: String = ""
    var region: String = ""
    var theme: [String] = [] {
        didSet {
            tableView.reloadRows(at: [[0, 3]], with: .automatic)
        }
    }
    var warning: [String] = []
    var isParking: Bool?
    var parkingDesc: String = ""
    var courseDesc: String = ""
    
    var lastThemeList: [String] = []
    var lastSenderList: [Int] = []
    
    private var selectImages: [UIImage] = []
    private var itemProviders: [NSItemProvider] = []
    private var iterator: IndexingIterator<[NSItemProvider]>?
    private var titleSelectFlag: Bool = false // 제목 textfield 선택했는지 여부
    private var isLogin: Bool = UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.isLogin)
    private var shownPhotoAuth: Bool = UserDefaults.standard.bool(
        forKey: Constants.UserDefaultsKey.shownPhotoAuth
    )

    // MARK: UI

    private let tableView = UITableView()
    private var cellHeights: [CGFloat] = []
    
    private let titleView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let xButton = UIButton().then {
        $0.setBackgroundImage(ImageLiterals.icClose, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(xButtonDidTap), for: .touchUpInside)
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .notoSansMediumFont(ofSize: 17)
        $0.setTitleColor(UIColor.mainBlue, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "작성하기"
        $0.textAlignment = .center
        $0.font = .notoSansMediumFont(ofSize: 17)
        $0.textColor = .subBlack
    }

    private let separatorView = UIView().then {
        $0.backgroundColor = UIColor.gray20
    }


    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
        self.registerNotificationCenter()
        self.configureCreatePostLayout()
        self.configureConponentLayout()
        self.configureTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.removeObservers() // 옵저버 해제
    }

  // MARK: Configure

  private func configureTableView() {
      self.registerXibs()
      self.tableView.delegate = self
      self.tableView.dataSource = self
      self.tableView.separatorStyle = .none
      self.tableView.dismissKeyboardWhenTappedAround()
      self.initCellHeight()
      self.makeAlertWhenLookAround()
  }
}


// MARK: - private

extension CreatePostVC {

    private func registerXibs() {
      self.tableView.registerCustomXib(xibName: CreatePostTitleTVC.className)
      self.tableView.registerCustomXib(xibName: CreatePostPhotoTVC.className)
      self.tableView.register(cell: CreatePostCourseTVC.self)
      self.tableView.registerCustomXib(xibName: CreatePostThemeTVC.className)
      self.tableView.registerCustomXib(xibName: CreatePostParkingWarningTVC.className)
      self.tableView.registerCustomXib(xibName: CreatePostDriveCourseTVC.className)
    }
    
    private func hideNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func initCellHeight() {
        self.cellHeights.append(contentsOf: [89, 255, 125, 135, 334, 408, 210])
    }
    
    private func registerNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldMoveUp),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldMoveDown),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addPhotoButtonDidTap),
            name: .callPhotoPicker,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(touchTitleView),
            name: .touchTitleTextView,
            object: nil
        )
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }

    private func writePostData() -> WritePostData {

        self.theme = self.theme.filter { $0 != "" }
        return WritePostData(
            title: self.postTitle,
            userEmail: Constants.userEmail,
            province: self.province,
            region: self.region,
            theme: self.theme,
            warning: self.warning,
            isParking: self.isParking ?? false,
            parkingDesc: self.parkingDesc,
            courseDesc: self.courseDesc,
            course: []
        )
    }
    
    private func makeAlertWhenLookAround() {
        if !isLogin {
            makeRequestAlert(title: "로그인이 필요해요", message: "", okTitle: "로그인하기", okAction: { [weak self] _ in
                self?.presentToSignNC()
            }, cancelTitle: "취소", cancelAction: { [weak self] _ in
                self?.dismiss(animated: true)
            }, completion: nil)
        }
    }
}


// MARK: - Actions

extension CreatePostVC {

    @objc private func touchTitleView() {
        self.titleSelectFlag = true
    }
    
    @objc private func textFieldMoveUp(_ notification: NSNotification) {
        self.separatorView.isHidden = true
        if tableView.contentOffset.y != 0.0 && titleSelectFlag == false {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        self.tableView.transform = CGAffineTransform(translationX: 0, y: -100)
                    }
                )
            }
        } else {
            self.titleSelectFlag.toggle()
        }
        
    }
    
    @objc private func textFieldMoveDown(_ notification: NSNotification) {
        self.separatorView.isHidden = false
        self.tableView.transform = .identity
    }

    @objc private func xButtonDidTap(sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        let alertViewController = UIAlertController(title: "", message: "게시물 작성을 중단하시겠습니까?", preferredStyle: .alert)

        let dismissAction = UIAlertAction(title: "작성 중단", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)

        }
        alertViewController.addAction(dismissAction)

        let cancelAction = UIAlertAction(title: "이어서 작성", style: .default, handler: nil)
        alertViewController.addAction(cancelAction)

        self.present(alertViewController, animated: true, completion: nil)
    }

    @objc private func nextButtonDidTap(sender: UIButton) {

        guard self.checkValidation() else { return }

        let nextVC = AddressMainVC()
        let images: [UIImage] = self.selectImages
        let model: WritePostData = self.writePostData()
        nextVC.setAddressListData(list: [])
        nextVC.setWritePostDataForServer(data: model, imageList: images)
        self.navigationController?.pushViewController(nextVC, animated: false)
    }

    @objc private func addPhotoButtonDidTap() {
        if #available(iOS 14, *) {
            if self.PhotoAuth() {
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 6 - self.selectImages.count // 최대 6개 선택
                configuration.filter = .images

                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self

                self.present(picker, animated: true, completion: nil)
            } else {
                guard self.shownPhotoAuth == true else {
                    Constants.shownPhotoLibrary()
                    return
                }
                self.AuthSettingOpen(AuthString: "갤러리")
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

// MARK: - Layout

extension CreatePostVC {

    func configureCreatePostLayout() {
        self.view.addSubviews([self.titleView, self.tableView, self.separatorView])
        
        let titleRatio: CGFloat = 102/375
        
        self.titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(UIScreen.getDeviceWidth()*titleRatio)
        }

        self.separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(self.titleView.snp.bottom)
            $0.leading.equalTo(self.titleView.snp.leading)
            $0.trailing.equalTo(self.titleView.snp.trailing)
        }
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets).offset(UIScreen.getDeviceWidth()*titleRatio)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureConponentLayout() {
        self.titleView.addSubviews([self.titleLabel, self.xButton, self.nextButton])
        
        self.titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(titleView.snp.bottom).inset(23)
            $0.width.equalTo(150) // 크게 넣기
            $0.centerX.equalTo(titleView.snp.centerX)
            $0.height.equalTo(21)
        }
        
        self.xButton.snp.makeConstraints {
            $0.leading.equalTo(titleView.snp.leading).offset(7)
            $0.width.equalTo(48)
            $0.height.equalTo(xButton.snp.width)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        self.nextButton.snp.makeConstraints {
            $0.trailing.equalTo(titleView.snp.trailing).inset(20)
            $0.height.equalTo(22)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
}


// MARK: - UITableView Delegate

extension CreatePostVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeights[indexPath.row]
    }
}


// MARK: - UITableView DataSource

extension CreatePostVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellHeights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return self.getCreatePostTitleCell(tableView: tableView)
        case 1:
            return self.getCreatePostPhotoCell(tableView: tableView)
        case 2:
            return self.getCreatePostCourseCell(tableView: tableView)
        case 3:
            return self.getCreatePostThemeCell(tableView: tableView)
        case 4:
            return self.getCreatePostParkingWarningCell(tableView: tableView)
        case 5:
            return self.getCreatePostCourseDescCell(tableView: tableView)
        case 6:
            return UITableViewCell()
        default:
            return self.getCreatePostTitleCell(tableView: tableView)
        }
    }
}


// MARK: - PHPickerViewControllerDelegate

extension CreatePostVC: PHPickerViewControllerDelegate {
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        itemProviders = results.map(\.itemProvider)
        var count = 0
        
        if results.count + self.selectImages.count > 6 {
            // 선택된 사진 갯수가 6개 초과면 alert을 띄워줌
            self.makeAlert(title: "사진 용량 초과", message: "사진은 최대 6장까지 추가가 가능합니다.")
        } else {
            for item in itemProviders {
                // iterator가 있을 때 까지 selectImages 배열에 append
                if item.canLoadObject(ofClass: UIImage.self) {
                    item.loadObject(ofClass: UIImage.self) { (image, error) in
                        DispatchQueue.main.async { // 다 배열에 넣고 reload
                            if let image = image as? UIImage {
                                self.selectImages.append(image)
                                count += 1
                                if count == results.count {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


//MARK: - import cell function

extension CreatePostVC {

    private func getCreatePostTitleCell(tableView: UITableView) -> UITableViewCell {
        guard let titleCell = tableView.dequeueReusableCell(
            withIdentifier: CreatePostTitleTVC.className
        ) as? CreatePostTitleTVC else { return UITableViewCell() }
        
        titleCell.delegateCell = self
        titleCell.setTitleInfo = { value in
            self.postTitle = value
        }
        
        return titleCell
    }
    
    private func getCreatePostPhotoCell(tableView: UITableView) -> UITableViewCell {
        guard let photoCell = tableView.dequeueReusableCell(
            withIdentifier: CreatePostPhotoTVC.className
        ) as? CreatePostPhotoTVC else { return UITableViewCell() }

        photoCell.actionDelegate = self

        // 여기서 VC 이미지를 Cell에 전달
        photoCell.receiveImageListfromVC(image: self.selectImages)
        
        if selectImages.count > 0 {
            photoCell.configurePhotoLayout()
            photoCell.configureCollcetionView()
            photoCell.updateEmptyViewVisible(isHidden: true)
        } else {
            photoCell.emptyConfigureLayout()
            photoCell.updateEmptyViewVisible(isHidden: false)
        }

        let height: CGFloat = (UIScreen.getDeviceWidth() - 54.0) / 3
        self.cellHeights[1] = self.selectImages.isEmpty || self.selectImages.count > 2
        ? height * 2 + 41.0
        : height + 33.0

        return photoCell
    }
    
    private func getCreatePostCourseCell(tableView: UITableView) -> UITableViewCell {
        guard let courseCell = tableView.dequeueReusableCell(
            withIdentifier: CreatePostCourseTVC.className
        ) as? CreatePostCourseTVC else { return UITableViewCell() }

        self.cellHeights[2] = courseCell.setDynamicHeight()
        
        courseCell.setCityInfo = { value in
            self.province = value
        }
        courseCell.setRegionInfo = { value in
            self.region = value
        }
        
        return courseCell
    }
    
    private func getCreatePostThemeCell(tableView: UITableView) -> UITableViewCell {
        guard let themeCell = tableView.dequeueReusableCell(
            withIdentifier: CreatePostThemeTVC.className
        ) as? CreatePostThemeTVC else { return UITableViewCell() }
        
        self.cellHeights[3] = themeCell.setDynamicHeight()
        themeCell.configureThemeData(themeList: theme.isEmpty ? lastThemeList : theme)
        
        themeCell.tapSetThemeButtonAction = {
            guard let themeVC = self.storyboard?.instantiateViewController(
                withIdentifier: ThemePopupVC.className
            ) as? ThemePopupVC else { return }

            themeVC.modalPresentationStyle = .custom
            themeVC.transitioningDelegate = self
            themeVC.lastThemeList = self.lastThemeList
            themeVC.lastSenderList = self.lastSenderList
            self.present(themeVC, animated: true, completion: nil)
        }
        
        return themeCell
    }
    
    private func getCreatePostParkingWarningCell(tableView: UITableView) -> UITableViewCell {
        guard let parkingWarningCell = tableView.dequeueReusableCell(
            withIdentifier: CreatePostParkingWarningTVC.className
        ) as? CreatePostParkingWarningTVC else { return UITableViewCell() }
        
        // 데이터 전달 closure
        parkingWarningCell.setParkingInfo = { value in
            self.isParking = value
        }
        parkingWarningCell.setWraningData = { value in
            self.warning = value
        }
        parkingWarningCell.setParkingDesc = { value in
            self.parkingDesc = value
        }
        
        self.cellHeights[4] = parkingWarningCell.setDynamicHeight()
        
        return parkingWarningCell
    }
    
    private func getCreatePostCourseDescCell(tableView: UITableView) -> UITableViewCell {
        guard let courseDescCell = tableView.dequeueReusableCell(
            withIdentifier: CreatePostDriveCourseTVC.className
        ) as? CreatePostDriveCourseTVC else { return UITableViewCell() }
        
        if self.courseDesc.isEmpty {
            courseDescCell.setContentText(text: "")
        }
        
        courseDescCell.setCourseDesc = { value in
            self.courseDesc = value
        }

        return courseDescCell
    }
}


// MARK: - PostTitlecTVCDelegate

extension CreatePostVC: PostTitlecTVCDelegate {

    func increaseTextViewHeight(_ cell: CreatePostTitleTVC,_ textView: UITextView) {
        
        let thisIndexPath = self.tableView.indexPath(for: cell)!
        self.cellHeights[thisIndexPath.row] += 22

        let newSize = self.tableView.sizeThatFits(
            CGSize(
                width: textView.bounds.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        )

        if textView.bounds.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func decreaseTextViewHeight(_ cell: CreatePostTitleTVC,_ textView: UITextView) {
        
        let thisIndexPath = self.tableView.indexPath(for: cell)!
        self.cellHeights[thisIndexPath.row] -= 22
        
        let newSize = self.tableView.sizeThatFits(
            CGSize(
                width: textView.bounds.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        
        if textView.bounds.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}


// MARK: - UIViewControllerTransitioningDelegate

extension CreatePostVC: UIViewControllerTransitioningDelegate {

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}


// MARK: - CreatePostPhotoTVCActionDelegate

extension CreatePostVC: CreatePostPhotoTVCActionDelegate {
    func didTapAddImageButton() {
        self.addPhotoButtonDidTap()
    }

    func didTapDeleteImageButton(index: Int) {
        guard self.selectImages.count > index else { return }
        self.selectImages.remove(at: index)
        self.tableView.reloadData()
    }
}

extension CreatePostVC {
    private func checkValidation() -> Bool {

        if self.postTitle.count < 1 {
            self.pushAlertValidation(message: "게시글 제목을 입력하지 않았어요.")
            return false
        }

        if self.selectImages.isEmpty {
            self.pushAlertValidation(message: "코스에 대한 사진을 1장 이상 선택해주세요.")
            return false
        }

        if self.province.count < 1 || self.region.count < 1 {
            self.pushAlertValidation(message: "드라이브 코스 지역을 입력해주세요.")
            return false
        }

        if self.lastThemeList.isEmpty {
            self.pushAlertValidation(message: "테마를 선택해주세요.")
            return false
        }

        if self.isParking == nil {
            self.pushAlertValidation(message: "주차 공간을 체크해주세요.")
            return false
        }

        if self.isParking == true && self.parkingDesc == "" {
            self.pushAlertValidation(message: "주차 공간이 있다고 체크해주셨어요! 주차 공간에 대한 설명도 작성해주세요.")
            return false
        }

        if self.courseDesc.count < 1 {
            self.pushAlertValidation(message: "코스 설명을 입력해주세요.")
            return false
        }

        return true
    }

    private func pushAlertValidation(message: String) {
        let alertViewController = UIAlertController(
            title: "",
            message: message,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(
            title: "네, 작성할게요.",
            style: .default,
            handler: nil
        )

        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
}


// MARK: 포토 라이브러리 접근 권한

extension CreatePostVC {

    func PhotoAuth() -> Bool {
        // 포토 라이브러리 접근 권한
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()

        var isAuth = false

        switch authorizationStatus {
        case .authorized:
            // 사용자가 앱에 사진 라이브러리에 대한 액세스 권한을 명시 적으로 부여했습니다.
            return true
        case .denied:
            // 사용자가 사진 라이브러리에 대한 앱 액세스를 명시 적으로 거부했습니다.
            break
        case .notDetermined:
            // 사진 라이브러리 액세스에는 명시적인 사용자 권한이 필요하지만 사용자가 아직 이러한 권한을 부여하거나 거부하지 않았습니다
            PHPhotoLibrary.requestAuthorization { (state) in
                if state == .authorized {
                    isAuth = true
                }
            }
            Constants.shownPhotoLibrary()
            return isAuth
        case .restricted:
            // 앱이 사진 라이브러리에 액세스 할 수있는 권한이 없으며 사용자는 이러한 권한을 부여 할 수 없습니다.
            break
        default:
            break
        }

        return false
    }

    func AuthSettingOpen(AuthString: String) {
        if let AppName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let message = "\(AppName)이(가) \(AuthString) 접근 허용되어 있지않습니다. \r\n 설정화면으로 가시겠습니까?"
            let alert = UIAlertController(title: "설정", message: message, preferredStyle: .alert)
            let cancle = UIAlertAction(title: "취소", style: .default)
            let confirm = UIAlertAction(title: "확인", style: .default) { (UIAlertAction) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }

            alert.addAction(cancle)
            alert.addAction(confirm)

            self.present(alert, animated: true, completion: nil)
        }
    }
}
