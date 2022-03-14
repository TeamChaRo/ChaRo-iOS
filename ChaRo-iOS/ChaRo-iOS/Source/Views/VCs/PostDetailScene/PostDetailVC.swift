//
//  PostDetailVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/02.
//

import UIKit
import SnapKit
import Then
import RxSwift

class PostDetailVC: UIViewController {
    private let disposeBag = DisposeBag()
    
    private var isAuthor = false
    private var isEditingMode = false
    private var tableView = UITableView()
    private var postId: Int = -1
    private var postData : PostDetail?
    private var postDetailData : PostDetailData?
    private var additionalDataOfPost: DriveElement?
    private var driveCell: PostDriveCourseTVC?
    private var addressList: [Course] = []
    private var imageList: [UIImage] = []
    let cellFixedCount: Int = 3 // 0~2 cell은 무조건 존재
    
    private var isFavorite: Bool? {
        didSet {
            bottomView.likeButton.isSelected = isFavorite! ? true : false
        }
    }
    
    private var isStored: Bool? {
        didSet {
            bottomView.likeButton.isSelected = isStored! ? true : false
        }
    }
    
    //MARK: For Sending Data
    private var writedPostData: WritePostData?
    
    //MARK: UIComponent
    private let navigationView = UIView()
    private lazy var backButton = LeftBackButton(toPop: self, isModal: true)
    private var navigationTitleLabel = NavigationTitleLabel(title: "게시물 상세보기",
                                                            color: .mainBlack)
    private var bottomView = PostDetailBottomView()
    private let separateLineView = UIView()
    private var modifyButton = UIButton()
    private let saveButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkModeForSendingServer()
        setTableViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    public func setPostMode(isAuthor: Bool, isEditing: Bool){
        self.isAuthor = isAuthor
        self.isEditingMode = isEditing
    }
    
    public func setPostId(id: Int){
        print("setPost PostDetailVC - \(id)")
        postId = id
    }
    
    public func setAdditionalDataOfPost(data: DriveElement?){
        additionalDataOfPost = data
        print("넘어온 데이터 = \(additionalDataOfPost)")
    }
    
    
    private func checkModeForSendingServer(){
        if isEditingMode{
            print("editing 모드로 넘겨받음")
            print("postData = \(postData)")
            print("addressList = \(addressList)")
            print("isAuthor = \(isAuthor)")
            setNavigaitionViewConstraints()
            configureTableView()
        }else{
            print("그냥 구경하러 왔음")
            getPostDetailData()
        }
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
    
}

//MARK: Button Action
extension PostDetailVC{
    
    //등록 버튼 눌렀을 때 post 서버 통신
    @objc func clickedToSaveButton(){
        print("등록 버튼")
        makeRequestAlert(title: "", message: "게시물 작성을 완료하시겠습니까?"){ _ in
            self.postCreatePost()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func registActionSheet(){
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let modifyAction = UIAlertAction(title: "글 수정하기", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
        })

        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(modifyAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancleAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100,
                                               y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = .gray40
        toastLabel.textColor = UIColor.white
        toastLabel.font = .notoSansRegularFont(ofSize: 14)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 17;
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in toastLabel.removeFromSuperview() })
    }
}

//MARK: UI
extension PostDetailVC{
    
    func setTableViewConstraints(){
        if postDetailData != nil{
            view.addSubview(tableView)
            tableView.snp.makeConstraints{
                $0.top.equalTo(navigationView.snp.bottom).offset(5)
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.bottom.equalToSuperview().inset(88)
            }
        }
    }

    private func setNavigaitionViewConstraints(){
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(self.view)
            if UIScreen.hasNotch{
                $0.height.equalTo(UIScreen.getNotchHeight() + 58)
            }else{
                $0.height.equalTo(93)
            }
        }
        
        view.add(separateLineView){
            $0.backgroundColor = .gray20
            $0.snp.makeConstraints{
                $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                $0.top.equalTo(self.navigationView.snp.bottom)
                $0.height.equalTo(1)
            }
        }
        navigationView.bringSubviewToFront(view)
        setBasicNavigationView()
        
        if isAuthor{
            navigationTitleLabel.text = "내가 작성한 글"
            if isEditingMode{
                setNavigationViewInSaveMode()
            }else{
                setNavigationViewInConfirmMode()
            }
        }else{
            navigationTitleLabel.text = "구경하기"
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
        navigationView.add(saveButton){
            $0.setTitle("등록", for: .normal)
            $0.titleLabel?.font = .notoSansMediumFont(ofSize: 17)
            $0.setTitleColor(.mainBlue, for: .normal)
            $0.addTarget(self, action: #selector(self.clickedToSaveButton), for: .touchUpInside)
            $0.snp.makeConstraints{
                $0.trailing.equalToSuperview().offset(-20)
                $0.centerY.equalTo(self.backButton.snp.centerY)
            }
        }
    }
    
    func setNavigationViewInConfirmMode(){
        navigationView.add(modifyButton){
            $0.setBackgroundImage(UIImage(named: "icMypageMore"), for: .normal)
            $0.addTarget(self, action: #selector(self.registActionSheet), for: .touchUpInside)
            $0.snp.makeConstraints{
                $0.trailing.equalToSuperview().offset(-11)
                $0.centerY.equalTo(self.backButton.snp.centerY)
            }
        }
    }
    
    //    public func setDataWhenConfirmPost(data: WritePostData,
    //                                       imageList: [UIImage],
    //                                       addressList: [AddressDataModel]){
    //        isEditingMode = true
    //        isAuthor = true
    //        self.addressList = addressList
    //        self.imageList = imageList
    //        writedPostData = data
    //
    //        let sendedPostDate = PostDetail(title: data.title,
    //                                  author: Constants.userId,
    //                                  isAuthor: true,
    //                                  profileImage: UserDefaults.standard.string(forKey: "profileImage")!,
    //                                  postingYear: Date.getCurrentYear(),
    //                                  postingMonth: Date.getCurrentMonth(),
    //                                  postingDay: Date.getCurrentDay(),
    //                                  isStored: false,
    //                                  isFavorite: false,
    //                                  likesCount: 0,
    //                                  images: [""],
    //                                  province: data.province,
    //                                  city: data.region,
    //                                  themes: data.theme,
    //                                  source: "",
    //                                  wayPoint: [""],
    //                                  destination: "",
    //                                  longtitude: [""],
    //                                  latitude: [""],
    //                                  isParking: data.isParking,
    //                                  parkingDesc: data.parkingDesc,
    //                                  warnings: data.warning,
    //                                  courseDesc: data.courseDesc)
    //
    //        self.postData = sendedPostDate
    //
    //        dump(writedPostData)
    //
    //        print("넘겨져온 이미지야~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    //        print("imageList = \(imageList)")
    //        print("넘겨져온 이미지야~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    //
    //        var newAddressList :[Address] = []
    //        for address in addressList{
    //            newAddressList.append(address.getAddressDataModel())
    //        }
    //
    //        writedPostData?.course = newAddressList
    //    }

}

//MARK: - Bottom View
extension PostDetailVC {
    private func configureBottomView(){
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(88)
        }
        bottomView.likeDescriptionButton.setTitle("\(postDetailData?.likesCount ?? 0)명이 좋아해요", for: .normal)
        bindToBottomView()
    }
    
    private func bindToBottomView(){
        bottomView.likeButton.rx.tap
            .asDriver()
            .drive(onNext:{
                [weak self] _ in
                    self?.bottomView.likeButton.isSelected.toggle()
                    self?.requestPostLike()
            })
            .disposed(by: disposeBag)
        
        bottomView.scrapButton.rx.tap
            .asDriver()
            .drive(onNext:{ [weak self] _ in
                self?.bottomView.scrapButton.isSelected.toggle()
                self?.requestPostScrap()
            })
            .disposed(by: disposeBag)
        
        bottomView.shareButton.rx.tap
            .asDriver()
            .drive(onNext:{ _ in
                print("shareButton 눌림")
            })
            .disposed(by: disposeBag)
        
        bottomView.likeDescriptionButton.rx.tap
            .asDriver()
            .drive(onNext:{ [weak self] in
                let nextVC = PostLikeListVC()
                nextVC.postId = self?.postId ?? -1
                nextVC.modalPresentationStyle = .overFullScreen
                self?.present(nextVC, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
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
            return 418
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
        
        guard let additionalData = additionalDataOfPost, let postData = postDetailData else {return UITableViewCell()}
        
        titleCell.setTitle(title: additionalData.title,
                           userName: postData.author,
                           date: "\(additionalData.year)년 \(additionalData.month)월 \(additionalData.day)일",
                           imageName: postData.profileImage,
                           likedCount: String(postData.likesCount))
        return titleCell
    }
    
    func getPostImagesCell(tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostImagesTVC.identifier) as? PostImagesTVC else { return UITableViewCell() }
        
        if imageList.isEmpty {
            cell.setImage(postDetailData?.images ?? [])
        }else{
            cell.setImageAtConfirmView(imageList: [])
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func getPostCourseThemeCell(tableView: UITableView) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCourseThemeTVC.identifier) as? PostCourseThemeTVC else {return UITableViewCell()}
        cell.setCourse(city: postDetailData?.province ?? "" ,
                       region: additionalDataOfPost?.region ?? "" )
        cell.setTheme(theme: postDetailData?.themes ?? [])
        cell.configureLayout()
        cell.themeButtonConfigureLayer()
        cell.selectionStyle = .none
        return cell
    }
    
    func getPostLocationCell(tableView: UITableView, row: Int) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostLocationTVC.identifier) as? PostLocationTVC else {return UITableViewCell()}
        
        switch row {
        case 3:
            cell.titleView.titleLabel.text = "출발지"
            cell.setLocationText(address: addressList[0].address)
            
        case 3+addressList.count-1:
            cell.titleView.titleLabel.text = "도착지"
            cell.setLocationText(address: addressList[addressList.count-1].address)
           
        default:
            cell.titleView.titleLabel.text = "경유지"
            if row == 4 {
                cell.setLocationText(address: addressList[1].address)
            }
            if row == 5 {
                cell.setLocationText(address: addressList[2].address)
            }
        }
        
        cell.clickCopyButton = {
            self.showToast(message: "클립보드에 복사되었습니다.")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func getPostPathMapCell(tableView: UITableView) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPathMapTVC.identifier) as? PostPathMapTVC else {return UITableViewCell()}
        cell.setcourseList(list: addressList, height: 451)
        cell.selectionStyle = .none
        return cell
    }
    
    
    func getPostParkingCell(tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostParkingTVC.identifier) as? PostParkingTVC else {return UITableViewCell()}
        cell.setParkingStatus(status: postDetailData?.isParking ?? false)
        cell.setParkingExplanation(text: postDetailData?.parkingDesc ?? "")
        cell.idEditMode(isEditing: false)
        cell.selectionStyle = .none
        return cell
    }
    
    func getPostAttensionCell(tableView: UITableView) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostAttentionTVC.identifier) as? PostAttentionTVC else { return UITableViewCell()}
        cell.setAttentionList(list: postDetailData?.warnings ?? [])
        cell.selectionStyle = .none
        return cell
    }

    func getPostDriveCourceCell(tableView: UITableView) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostDriveCourseTVC.identifier) as? PostDriveCourseTVC else {return UITableViewCell()}
        cell.setContentText(text: postDetailData?.courseDesc ?? "")
        cell.selectionStyle = .none
        return cell
    }
}


//MARK: Network
extension PostDetailVC {
  
    func setPostContentView(postData: PostDetailData?){
        print("additionalDataOfPost = \(additionalDataOfPost)")
        postDetailData = postData
        isAuthor = postDetailData?.isAuthor ?? false
        isFavorite = postDetailData?.isFavorite == 0 ? false : true
        isStored = postDetailData?.isStored == 0 ? false : true
        addressList = postDetailData?.course ?? []
        configureTableView()
        setNavigaitionViewConstraints()
        setTableViewConstraints()
        configureBottomView()
    }
    
    func getPostDetailData(){
        PostResultService.shared.getPostDetail(postId: postId){ response in
            switch(response){
            case .success(let resultData):
                if let data =  resultData as? PostDetailData{
                    print("response = \(data)")
                    self.setPostContentView(postData: data)
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
    
    func postCreatePost(){
        dump(writedPostData!)
        print("===서버통신 시작=====")
        CreatePostService.shared.createPost(model: writedPostData!, image: imageList){ result in
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
    
    func requestPostLike(){
        LikeService.shared.Like(userId: Constants.userId,
                                postId: postId) { [self] result in
            switch result{
            case .success(let success):
                if let success = success as? Bool {
                    self.isFavorite!.toggle()
                }
            case .requestErr(let msg):
                if let msg = msg as? String {
                    print(msg)
                }
            default :
                print("ERROR")
            }
        }
    }
   
    func requestPostScrap(){
        SaveService.shared.requestScrapPost(userId: Constants.userId,
                                            postId: postId) { [self] result in
                
            switch result{
            case .success(let success):
                if let success = success as? Bool {
                    print("스크랩 성공해서 바뀝니다")
                    self.isStored!.toggle()
                }
            case .requestErr(let msg):
                if let msg = msg as? String {
                    print(msg)
                }
            default :
                print("ERROR")
            }
        }
    }
}
