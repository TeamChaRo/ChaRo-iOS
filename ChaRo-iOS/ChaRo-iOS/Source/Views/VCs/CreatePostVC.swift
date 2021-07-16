//
//  CreatePostVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/11.
//

import UIKit
import SnapKit
import Photos
import PhotosUI

class CreatePostVC: UIViewController {
    
    static let identifier: String = "CreatePostVC"
    
    // 데이터 전달
    public var postTitle: String = ""
    public var province: String = ""
    public var region: String = ""
    public var theme: [String] = ["","",""]
    public var warning: [Bool] = [false, false, false, false]
    public var isParking: Bool = false
    public var parkingDesc: String = ""
    public var courseDesc: String = ""
    
    var selectImages: [UIImage] = []
    
    var itemProviders: [NSItemProvider] = []
    var iterator: IndexingIterator<[NSItemProvider]>?
    
    // MARK:  components
    let tableView: UITableView = UITableView()
    var cellHeights: [CGFloat] = []
    
    let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let xButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "close"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(xButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 17)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "작성하기"
        label.textAlignment = .center
        label.font = .notoSansMediumFont(ofSize: 17)
        label.textColor = .subBlack
        return label
    }()
    
    //MARK:  viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setNotificationCenter() // Noti
        setMainViewLayout() // Layout
        configureConponentLayout() // Layout
        applyTitleViewShadow() // 상단바 그림자 적용
        initCellHeight()
        
        configureTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObservers() // 옵저버 해제
    }
    
}

// MARK: - functions
extension CreatePostVC {
    
    // MARK: function
    func configureTableView(){
        registerXibs()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dismissKeyboardWhenTappedAround()
    }
    
    func registerXibs(){
        tableView.registerCustomXib(xibName: CreatePostTitleTVC.identifier)
        tableView.registerCustomXib(xibName: CreatePostPhotoTVC.identifier)
        tableView.registerCustomXib(xibName: CreatePostCourseTVC.identifier)
        tableView.registerCustomXib(xibName: CreatePostThemeTVC.identifier)
        tableView.registerCustomXib(xibName: CreatePostParkingWarningTVC.identifier)
        tableView.registerCustomXib(xibName: PostDriveCourseTVC.identifier)
    }
    
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func applyTitleViewShadow(){
        titleView.getShadowView(color: UIColor.black.cgColor, masksToBounds: false, shadowOffset: CGSize(width: 0, height: 10), shadowRadius: 6, shadowOpacity: 0.05)

        self.view.bringSubviewToFront(titleView)
    }
    
    func initCellHeight(){
        cellHeights.append(contentsOf: [89, 255, 125, 125, 334, 408])
    }
    
    func setNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoButtonDidTap), name: .callPhotoPicker, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setPostTitle), name: .sendNewPostTitle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setPostCity), name: .sendNewCity, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setPostRegion), name: .sendNewRegion, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setPostTheme), name: .sendNewTheme, object: nil)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func postWriteData() -> WritePostData{ // 밖에서 호출할 때 쓰세요~
        let writeData = WritePostData(title: self.postTitle, userId: Constants.userId, province: self.province, region: self.region, theme: self.theme, warning: self.warning, isParking: self.isParking, parkingDesc: self.parkingDesc, courseDesc: self.courseDesc, course: [])
        
        return writeData
    }
    
    @objc
    func textFieldMoveUp(_ notification: NSNotification){
        
        if tableView.contentOffset.y != 0.0 {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
                })
            }
        }
        
    }
    
    @objc
    func textFieldMoveDown(_ notification: NSNotification){
        self.tableView.transform = .identity
    }
    
    // MARK: 서버통신 .post /writePost
    func postCreatePost(){
        let images: [UIImage] = [UIImage(named: "testimage")!, UIImage(named: "Mask Group")!]
        //TODO: 작성하기 맵뷰(혜령)와 연결 예정
        let model: WritePostData = WritePostData(title: "하이", userId: "injeong0418", province: "특별시", region: "서울", theme: ["여름","산"], warning: [true,true,false,false], isParking: false, parkingDesc: "예원아 새벽까지 고생이 많아", courseDesc: "코스 드립크", course: [Address(address: "123", latitude: "123", longtitude: "123"), Address(address: "123", latitude: "123", longtitude: "123")])
        
        
        
        print("===서버통신 시작=====")
        CreatePostService.shared.createPost(model: model, image: images){ result in
            switch result {
            case .success(let message):
                print(message)
            case .requestErr(let message):
                print(message)
            case .serverErr:
                print("서버에러")
            case .networkFail:
                print("네트워크에러")
            default:
                print("몰라에러")
            }
        }
    }
    
    // MARK: Cell에서 데이터 받아오기
    @objc // title 받아오기
    func setPostTitle(_ notification: Notification){
        postTitle = notification.object as! String
    }
    
    @objc // city 받아오기
    func setPostCity(_ notification: Notification){
        province = notification.object as! String
    }
    
    @objc // region 받아오기
    func setPostRegion(_ notification: Notification){
        region = notification.object as! String
    }
    
    @objc
    func setPostTheme(_ notification: Notification){
        theme = notification.object as! [String]
    }
    
    
    // MARK: Layout
    func setMainViewLayout(){
        self.view.addSubviews([titleView,tableView])
        
        let titleRatio: CGFloat = 102/375
        
        titleView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaInsets)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(UIScreen.getDeviceWidth()*titleRatio)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaInsets).offset(UIScreen.getDeviceWidth()*titleRatio)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureConponentLayout(){
        titleView.addSubviews([titleLabel, xButton, nextButton])
        
        titleLabel.snp.makeConstraints{
            $0.bottom.equalTo(titleView.snp.bottom).inset(23)
            $0.width.equalTo(150) // 크게 넣기
            $0.centerX.equalTo(titleView.snp.centerX)
            $0.height.equalTo(21)
        }
        
        xButton.snp.makeConstraints{
            $0.leading.equalTo(titleView.snp.leading).offset(7)
            $0.width.equalTo(48)
            $0.height.equalTo(xButton.snp.width)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        nextButton.snp.makeConstraints{
            $0.trailing.equalTo(titleView.snp.trailing).offset(-20)
            $0.height.equalTo(22)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        
    }
    
    //MARK: - Button Actions
    @objc
    func xButtonDidTap(sender: UIButton){
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertViewController = UIAlertController(title: "", message: "게시물 작성을 중단하시겠습니까?",
                                                    preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "작성 중단", style: .default){ _ in
            self.dismiss(animated: true, completion: nil)

        }
        alertViewController.addAction(dismissAction)
        
        let cancelAction = UIAlertAction(title: "이어서 작성", style: .default, handler: nil)
        alertViewController.addAction(cancelAction)
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @objc
    func nextButtonDidTap(sender: UIButton){
        let storyboard = UIStoryboard(name: "AddressMain", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: AddressMainVC.identifier) as? AddressMainVC else {
            return
        }
        
        let images: [UIImage] = [UIImage(named: "dummyMain")!, UIImage(named: "dummyMain")!]
        //TODO: 작성하기 맵뷰(혜령)와 연결 예정
        let model: WritePostData = WritePostData(title: "하이", userId: "injeong0418", province: "특별시", region: "서울", theme: ["여름","산"], warning: [true,true,false,false], isParking: false, parkingDesc: "예원아 새벽까지 고생이 많아", courseDesc: "코스 드립크", course: [Address(address: "123", latitude: "123", longtitude: "123"), Address(address: "123", latitude: "123", longtitude: "123")])
        
        vc.setAddressListData(list: [])
        vc.setWritePostDataForServer(data: model, imageList: images)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc
    func addPhotoButtonDidTap(){
        if #available(iOS 14, *) { // 14이상 부터 쓸 수 있음
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 6 - selectImages.count // 최대 6개 선택
            configuration.filter = .images
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            
            self.present(picker, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
}

// MARK: - UITableView Extension
extension CreatePostVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    
}

extension CreatePostVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellHeights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return getCreatePostTitleCell(tableView: tableView)
        case 1:
            return getCreatePostPhotoCell(tableView: tableView)
        case 2:
            return getCreatePostCourseCell(tableView: tableView)
        case 3:
            return getCreatePostThemeCell(tableView: tableView)
        case 4:
            return getCreatePostParkingWarningCell(tableView: tableView)
        case 5:
            return getCreatePostCourseDescCell(tableView: tableView)
        default:
            return getCreatePostTitleCell(tableView: tableView)
        }
        
    }
}

// MARK: - PHPicker Extension
extension CreatePostVC: PHPickerViewControllerDelegate {
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        itemProviders = results.map(\.itemProvider)
        iterator = itemProviders.makeIterator()
        
        if itemProviders.count + selectImages.count > 6 {
            // 선택된 사진 갯수가 6개 초과면 alert을 띄워줌
            let alert = UIAlertController(title: "사진 추가", message: "최대 6개까지 추가할 수 있습니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler : nil )
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            while true {
                // iterator가 있을 때 까지 selectImages 배열에 append
                if let itemProvider = iterator?.next(), itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        guard let self = self, let image = image as? UIImage else {return}
                        self.selectImages.append(image)
                        DispatchQueue.main.async { // 다 배열에 넣고 reload
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    break
                }
            }
        }
    }
}

//MARK: - import cell function
extension CreatePostVC {
    func getCreatePostTitleCell(tableView: UITableView) -> UITableViewCell{
        guard let titleCell = tableView.dequeueReusableCell(withIdentifier: CreatePostTitleTVC.identifier) as? CreatePostTitleTVC else { return UITableViewCell() }
        
        titleCell.delegateCell = self
        
        return titleCell
    }
    
    func getCreatePostPhotoCell(tableView: UITableView) -> UITableViewCell{
        guard let photoCell = tableView.dequeueReusableCell(withIdentifier: CreatePostPhotoTVC.identifier) as? CreatePostPhotoTVC else { return UITableViewCell() }
        
        // 여기서 VC 이미지를 Cell에 전달
        photoCell.receiveImageListfromVC(image: selectImages)
        
        if selectImages.count > 0 {
            photoCell.photoConfigureLayout()
            photoCell.setCollcetionView()
        } else {
            photoCell.emptyConfigureLayout()
        }
      
        return photoCell
    }
    
    func getCreatePostCourseCell(tableView: UITableView) -> UITableViewCell{
        guard let courseCell = tableView.dequeueReusableCell(withIdentifier: CreatePostCourseTVC.identifier) as? CreatePostCourseTVC else { return UITableViewCell() }
        
        return courseCell
    }
    
    func getCreatePostThemeCell(tableView: UITableView) -> UITableViewCell{
        guard let themeCell = tableView.dequeueReusableCell(withIdentifier: CreatePostThemeTVC.identifier) as? CreatePostThemeTVC else { return UITableViewCell() }
        
        return themeCell
    }
    
    func getCreatePostParkingWarningCell(tableView: UITableView) -> UITableViewCell{
        guard let parkingWarningCell = tableView.dequeueReusableCell(withIdentifier: CreatePostParkingWarningTVC.identifier) as? CreatePostParkingWarningTVC else { return UITableViewCell() }
        
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
        
        return parkingWarningCell
    }
    
    func getCreatePostCourseDescCell(tableView: UITableView) -> UITableViewCell{
        guard let courseDescCell = tableView.dequeueReusableCell(withIdentifier: PostDriveCourseTVC.identifier) as? PostDriveCourseTVC else { return UITableViewCell() }
        courseDescCell.setContentText(text: "")
        courseDescCell.setCourseDesc = { value in
            self.courseDesc = value
        }
        return courseDescCell
    }
}

extension CreatePostVC: PostTitlecTVCDelegate {
    func increaseTextViewHeight(_ cell: CreatePostTitleTVC,_ textView: UITextView) {
        
        let thisIndexPath = tableView.indexPath(for: cell)!
        cellHeights[thisIndexPath.row] += 22
        
        let newSize = tableView.sizeThatFits(CGSize(width: textView.bounds.width,
                                                    height: CGFloat.greatestFiniteMagnitude))
        if textView.bounds.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func decreaseTextViewHeight(_ cell: CreatePostTitleTVC,_ textView: UITextView) {
        
        let thisIndexPath = tableView.indexPath(for: cell)!
        cellHeights[thisIndexPath.row] -= 22
        
        let newSize = tableView.sizeThatFits(CGSize(width: textView.bounds.width,
                                                    height: CGFloat.greatestFiniteMagnitude))
        
        if textView.bounds.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}

