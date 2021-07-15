//
//  PostDetailVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/02.
//

import UIKit

class PostDetailVC: UIViewController {

    static let identifier = "PostDetailVC"
    
    private var isAuthor = true
    private var isEditingMode = false
    
    private var tableView = UITableView()
    private var postId: Int = 1
    private var postData : PostDetail?
    private var driveCell: PostDriveCourseTVC?
    private var addressList: [AddressDataModel] = []
    
    
    //MARK: UIComponent
    private let navigationView = UIView()
    private lazy var backButton = LeftBackButton(toPop: self)
    private var navigationTitleLabel = NavigationTitleLabel(title: "게시물 상세보기",
                                                            color: .mainBlack)
    
    
    private var modifyButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icMypageMore"), for: .normal)
        button.addTarget(self, action: #selector(registActionSheet), for: .touchUpInside)
        return button
    }()
    
    private var heartButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icHeartInactive"), for: .normal)
        return button
    }()
    
    private var scrapButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icSaveInactive"), for: .normal)
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 17)
        button.setTitleColor(.mainBlue, for: .normal)
        //button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return button
    }()
    
    
    var location: [String] = ["출발지", "경유지", "경유지", "도착지"]
    let cellFixedCount: Int = 3 // 0~2 cell은 무조건 존재
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PostDetailVC viewDidLoad")
        setTableViewConstraints()
        setNavigaitionViewConstraints()
        //self.tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    public func setPostId(id: Int){
        print("setPost PostDetailVC - \(id)")
        postId = id
        getPostDetailData()
    }
    
    private func configureTableView(){
        registerXibs()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    private func registerXibs(){
        tableView.registerCustomXib(xibName: PostTitleTVC.identifier)
        tableView.registerCustomXib(xibName: PostImagesTVC.identifier)
        tableView.registerCustomXib(xibName: PostParkingTVC.identifier)
        tableView.registerCustomXib(xibName: PostAttentionTVC.identifier)
        tableView.registerCustomXib(xibName: PostDriveCourseTVC.identifier)
        tableView.registerCustomXib(xibName: PostCourseThemeTVC.identifier)
        tableView.registerCustomXib(xibName: PostLocationTVC.identifier)
        tableView.registerCustomXib(xibName: PostPathMapTVC.identifier)
    }
    
    func refineAddressData(){
        let startAddreaa = AddressDataModel(latitude: postData!.latitude[0],
                                            longitude: postData!.longtitude[0],
                                            address: postData!.source,
                                            title: "출발지")
        
        addressList.append(startAddreaa)
        
        
        if postData!.wayPoint[0] != ""{
           let wayAddress = AddressDataModel(latitude: postData!.latitude[1],
                                             longitude: postData!.longtitude[1],
                                             address: postData!.wayPoint[0],
                                             title: "경유지1")
            addressList.append(wayAddress)
        }
        
        if postData!.wayPoint[1] != ""{
           let wayAddress = AddressDataModel(latitude: postData!.latitude[2],
                                             longitude: postData!.longtitude[2],
                                             address: postData!.wayPoint[1],
                                             title: "경유지2")
            addressList.append(wayAddress)
        }
        
        
        let destinationAddress = AddressDataModel(latitude: postData!.latitude[3],
                                                  longitude: postData!.longtitude[3],
                                                  address: postData!.destination,
                                                  title: "도착지")
        addressList.append(destinationAddress)
        
    }
    
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75,
                                               y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = .gray30
        toastLabel.textColor = UIColor.white
        toastLabel.font = .notoSansRegularFont(ofSize: 14)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in toastLabel.removeFromSuperview() })
    }
    
    
    @objc
    func registActionSheet(){

        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "글 수정하기", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        let saveAction = UIAlertAction(title: "삭제하기", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
        })

        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        
        self.present(optionMenu, animated: true, completion: nil)

    }
    
}

extension PostDetailVC{
    
    func setTableViewConstraints(){
        print(postData)
        if postData != nil{
            view.addSubview(tableView)
            
            tableView.snp.makeConstraints{
                $0.top.equalTo(navigationView.snp.bottom).offset(5)
                $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }

    private func setNavigaitionViewConstraints(){
        view.addSubview(navigationView)
    
        navigationView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view)
            $0.height.equalTo(UIScreen.getNotchHeight() + 58)
        }
        //navigationView.bringSubviewToFront(tableView)
        setBasicNavigationView()
        setShadowInNavigationView()
        
        if isAuthor{
            navigationTitleLabel.text = "내가 작성한 글"
            if isEditingMode{
                setNavigationViewInSaveMode()
            }else{
                setNavigationViewInConfirmMode()
            }
        }else{
            navigationTitleLabel.text = "구경하기"
            setNavigationViewInWatchMode()
        }
    }
    
    func setBasicNavigationView(){
        navigationView.addSubviews([backButton,
                                    navigationTitleLabel])
        
        backButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(UIScreen.getNotchHeight() + 1)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-9)
        }
        
        navigationTitleLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
    }
    
    func setNavigationViewInSaveMode(){
        navigationView.addSubview(saveButton)
        saveButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(backButton.snp.centerY)
        }
    }
    
    func setNavigationViewInConfirmMode(){
        navigationView.addSubview(modifyButton)
        modifyButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-11)
            $0.centerY.equalTo(backButton.snp.centerY)
        }
    }
    
    func setNavigationViewInWatchMode(){
        navigationView.addSubviews([heartButton, scrapButton])
        heartButton.snp.makeConstraints{
            $0.trailing.equalTo(scrapButton.snp.leading)
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        scrapButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-11)
            $0.centerY.equalTo(backButton.snp.centerY)
        }
    }
    
    func setShadowInNavigationView(){
        navigationView.backgroundColor = .white
        navigationView.layer.shadowOpacity = 0.05
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 0)
        navigationView.layer.shadowRadius = 6
        navigationView.layer.masksToBounds = false
        navigationView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0,
                                                                           width: UIScreen.getDeviceWidth(),
                                                                           height: UIScreen.getNotchHeight()+58),
                                                       cornerRadius: navigationView.layer.cornerRadius).cgPath
    }
    
    
 
}


//MARK: TableView Delegate
extension PostDetailVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let rowAdjustment: Int = cellFixedCount + addressList.count - 1
        
        switch indexPath.row {
        case 0:
            return 146
        case 1:
            return 222
        case 2:
            return 259
        case 3:
            return 50
        case rowAdjustment:
            return 50
        case rowAdjustment+1:
            return 451
        case rowAdjustment+2:
            return 159
        case rowAdjustment+3:
            return 159
        case rowAdjustment+4:
            return 408
        default:
            return 50
        }
    }
}


//MARK: - UITableView extension
extension PostDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("address count = \(addressList.count)")
        return 7 + addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowAdjustment: Int = cellFixedCount + addressList.count - 1
        
        switch indexPath.row {
        case 0:
            return getPostTitleCell(tableView: tableView)
        case 1:
            return getPostImagesCell(tableView: tableView)
        case 2:
            return getPostCourseThemeCell(tableView: tableView)
        case 3:
            return getPostLocationCell(tableView: tableView, row: indexPath.row) // 출발지
        case rowAdjustment:
            return getPostLocationCell(tableView: tableView, row: indexPath.row) // 도착지
        case rowAdjustment+1:
            return getPostPathMapCell(tableView: tableView)
        case rowAdjustment+2:
            return getPostParkingCell(tableView: tableView)
        case rowAdjustment+3:
            return getPostAttensionCell(tableView: tableView)
        case rowAdjustment+4:
            driveCell = getPostDriveCourceCell(tableView: tableView) as? PostDriveCourseTVC
            //return getPostDriveCourceCell(tableView: tableView)
            return driveCell!
        default: // 경유지 일로 들어왕
            return getPostLocationCell(tableView: tableView, row: indexPath.row)
        }
    }
}

//MARK: - import cell funcions
extension PostDetailVC {
    func getPostTitleCell(tableView: UITableView) -> UITableViewCell{
        guard let titleCell = tableView.dequeueReusableCell(withIdentifier: PostTitleTVC.identifier)
        as? PostTitleTVC else { return UITableViewCell() }
        
        titleCell.setTitle(title: postData!.title,
                           userName: postData!.author,
                           date: "\(postData!.postingYear)년 \(postData!.postingMonth)월 \(postData!.postingDay)일",
                           imageName: postData?.profileImage ?? "",
                           likedCount: String(postData?.likesCount ?? -1))
        return titleCell
    }
    
    func getPostImagesCell(tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostImagesTVC.identifier) as? PostImagesTVC else { return UITableViewCell() }
        
        cell.setImage(postData!.images)
        cell.selectionStyle = .none
        return cell
    }
    
    func getPostCourseThemeCell(tableView: UITableView) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCourseThemeTVC.identifier) as? PostCourseThemeTVC else {return UITableViewCell()}
        
        cell.setCourse(city: postData!.province, region: postData!.city)
        cell.setTheme(theme: postData!.themes)
        cell.configureLayout()
        cell.themeButtonConfigureLayer()
        //cell.bringButtonToFront()
        cell.selectionStyle = .none
        return cell
    }
    
    func getPostLocationCell(tableView: UITableView, row: Int) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostLocationTVC.identifier) as? PostLocationTVC else {return UITableViewCell()}
        
        switch row {
        case 3:
            cell.titleView.titleLabel.text = "출발지"
            cell.setLocationText(address: addressList[0].address)
            cell.clickCopyButton = {
                print("출발지 실행 안됌??")
                self.showToast(message: "출발지")
            }
            
        case 3+addressList.count-1:
            cell.titleView.titleLabel.text = "도착지"
            cell.setLocationText(address: addressList[addressList.count-1].address)
            cell.clickCopyButton = {
                print("도착지 실행 안됌??")
                self.showToast(message: "도착지")
            }
        default:
            cell.titleView.titleLabel.text = "경유지"
            if row == 4 {
                cell.setLocationText(address: addressList[1].address)
            }
            if row == 5 {
                cell.setLocationText(address: addressList[2].address)
            }
            cell.clickCopyButton = {
                print("경유지 실행 안됌??")
                self.showToast(message: "경유지")
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func getPostPathMapCell(tableView: UITableView) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPathMapTVC.identifier) as? PostPathMapTVC else {return UITableViewCell()}
        cell.setAddressList(list: addressList, height: 451)
        cell.selectionStyle = .none
        return cell
    }
    
    
    func getPostParkingCell(tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostParkingTVC.identifier) as? PostParkingTVC else {return UITableViewCell()}
        print(postData?.parkingDesc)
        cell.setParkingStatus(status: postData!.isParking)
        cell.setParkingExplanation(text: postData!.parkingDesc)
        cell.idEditMode(isEditing: false)
        cell.selectionStyle = .none
        return cell
    }
    
    func getPostAttensionCell(tableView: UITableView) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostAttentionTVC.identifier) as? PostAttentionTVC else { return UITableViewCell()}
        cell.setAttentionList(list: postData!.warnings)
        cell.selectionStyle = .none
        return cell
    }

    func getPostDriveCourceCell(tableView: UITableView) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostDriveCourseTVC.identifier) as? PostDriveCourseTVC else {return UITableViewCell()}
        print(postData!.courseDesc)
        cell.setContentText(text: postData!.courseDesc)
        cell.selectionStyle = .none
        return cell
    }
}


//MARK: Network
extension PostDetailVC {
    func setPostContentView(data: PostDetail){
        postData = data
        isAuthor = postData!.isAuthor
        refineAddressData()
        configureTableView()
        setTableViewConstraints()
    }
    
    func getPostDetailData(){
        print("getPostDetailData 넘겨진 postId = \(self.postId)")
        PostResultService.shared.getPostDetail(postId: postId){ response in
            print("getPostDetailData postId = \(self.postId)")
            switch(response){
            case .success(let resultData):
                if let data =  resultData as? PostDatailDataModel{
                    self.setPostContentView(data: data.data[0])
                    dump(self.postData)
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
