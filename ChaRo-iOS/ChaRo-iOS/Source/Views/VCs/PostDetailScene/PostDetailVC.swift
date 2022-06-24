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

final class PostDetailVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var viewModel: PostDetailViewModel?
    
    private var isAuthor = false
    private var isEditingMode = false
    private var postId: Int = -1
    private var postData: PostDetail?
    private var postDetailData: PostDetailData?
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
    private lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(cell: PostTitleTVC.self)
        $0.register(cell: PostPhotoTVC.self)
        $0.register(cell: PostParkingTVC.self)
        $0.register(cell: PostAttentionTVC.self)
        $0.register(cell: PostDriveCourseTVC.self)
        $0.register(cell: PostCourseThemeTVC.self)
        $0.register(cell: PostLocationTVC.self)
    }
    private let navigationView = UIView()
    private lazy var backButton = LeftBackButton(toPop: self, isModal: false)
    private var navigationTitleLabel = NavigationTitleLabel(title: "게시물 상세보기",
                                                            color: .mainBlack)
    private var bottomView = PostDetailBottomView()
    private let separateLineView = UIView().then {
        $0.backgroundColor = .gray20
    }
    private var modifyButton = UIButton().then {
        $0.setBackgroundImage(ImageLiterals.icMypageMore, for: .normal)
        $0.addTarget(self, action: #selector(registActionSheet), for: .touchUpInside)
    }
    private let saveButton = UIButton().then {
        $0.setTitle("등록", for: .normal)
        $0.titleLabel?.font = .notoSansMediumFont(ofSize: 17)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.addTarget(self, action: #selector(clickedToSaveButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        //checkModeForSendingServer()
        setupConstraints()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    public func setPostMode(isAuthor: Bool, isEditing: Bool) {
        self.isAuthor = isAuthor
        self.isEditingMode = isEditing
    }
    
    public func setPostId(id: Int) {
        print("setPost PostDetailVC - \(id)")
        postId = id
    }
    
    public func setAdditionalDataOfPost(data: DriveElement?) {
        additionalDataOfPost = data
        print("넘어온 데이터 = \(additionalDataOfPost)")
    }
    
    private func checkModeForSendingServer() {
        if isEditingMode {
            print("editing 모드로 넘겨받음")
            print("postData = \(postData)")
            print("addressList = \(addressList)")
            print("isAuthor = \(isAuthor)")
        } else {
            print("그냥 구경하러 왔음")
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
}

//MARK: Button Action
extension PostDetailVC{
    
    //등록 버튼 눌렀을 때 post 서버 통신
    @objc func clickedToSaveButton() {
        print("등록 버튼")
        makeRequestAlert(title: "", message: "게시물 작성을 완료하시겠습니까?") { _ in
            self.postCreatePost()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func registActionSheet() {
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
}

//MARK: UI
extension PostDetailVC{
    
    func setupConstraints() {
        view.addSubviews([navigationView, separateLineView])
        navigationView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(self.view)
            $0.height.equalTo(UIScreen.hasNotch ? UIScreen.getNotchHeight() + 58: 93)
        }
        separateLineView.snp.makeConstraints{
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.top.equalTo(self.navigationView.snp.bottom)
            $0.height.equalTo(1)
        }
        
        navigationView.addSubviews([backButton,
                                    navigationTitleLabel])
        
        backButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(1)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-9)
        }
        
        navigationTitleLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview().inset(88)
        }
    }
    
    private func configureNavigaitionView() {
        if isAuthor {
            navigationTitleLabel.text = "내가 작성한 글"
            isEditingMode ? setNavigationViewInSaveMode(): setNavigationViewInConfirmMode()
        } else {
            navigationTitleLabel.text = "구경하기"
        }
    }
    
    func setNavigationViewInSaveMode() {
        navigationView.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(self.backButton.snp.centerY)
        }
    }
    
    func setNavigationViewInConfirmMode() {
        navigationView.addSubview(modifyButton)
        modifyButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-11)
            $0.centerY.equalTo(self.backButton.snp.centerY)
        }
    }
    
    //    public func setDataWhenConfirmPost(data: WritePostData,
    //                                       imageList: [UIImage],
    //                                       addressList: [AddressDataModel]) {
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
    //        for address in addressList {
    //            newAddressList.append(address.getAddressDataModel())
    //        }
    //
    //        writedPostData?.course = newAddressList
    //    }
    
}

//MARK: - Bottom View
extension PostDetailVC {
    private func configureBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(88)
        }
        bottomView.likeDescriptionButton.setTitle("\(postDetailData?.likesCount ?? 0)명이 좋아해요", for: .normal)
        bindToBottomView()
    }
    
    private func bindToBottomView() {
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
                let nextVC = PostLikeListVC(postId: self?.additionalDataOfPost?.postID ?? -1)
                nextVC.modalPresentationStyle = .overFullScreen
                self?.present(nextVC, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}


//MARK: TableView Delegate
extension PostDetailVC: UITableViewDelegate {
}

//MARK: - UITableView extension
extension PostDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let additionalData = additionalDataOfPost,
              let postData = postDetailData else {
                  return UITableViewCell()
              }
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withType: PostTitleTVC.self, for: indexPath) else { return UITableViewCell() }
            cell.setContent(title: additionalData.title,
                                 userName: postData.author,
                                 date: "\(additionalData.year)년 \(additionalData.month)월 \(additionalData.day)일",
                                 imageName: postData.profileImage)
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withType: PostPhotoTVC.self, for: indexPath) else { return UITableViewCell() }
            let imageList = [additionalData.image] + postData.images
            cell.setContent(imageList: imageList)
            cell.presentingClosure = { [weak self] in
                let nextVC = ExpendedImageVC(imageList: imageList)
                nextVC.modalPresentationStyle = .fullScreen
                self?.present(nextVC, animated: true)
            }
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withType: PostCourseThemeTVC.self, for: indexPath) else { return UITableViewCell() }
            cell.setContent(city: postData.province,
                            region: additionalData.region,
                            theme: postData.themes)
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withType: PostLocationTVC.self, for: indexPath) else { return UITableViewCell() }
            cell.setContent(courseList: postData.course)
            cell.copyAddressClouser = { locationTitle in
                self.view.showToast(message: "\(locationTitle) 주소를 복사했습니다")
            }
            cell.setCopyClosure()
            return cell
            
        case 4:
            guard let cell = tableView.dequeueReusableCell(withType: PostParkingTVC.self, for: indexPath) else { return UITableViewCell() }
            cell.setContent(isParking: postData.isParking,
                            description: postData.parkingDesc)
            return cell
            
        case 5:
            guard let cell = tableView.dequeueReusableCell(withType: PostAttentionTVC.self, for: indexPath) else { return UITableViewCell() }
            cell.setAttentionList(list: postData.warnings)
            return cell
            
        case 6:
            guard let cell = tableView.dequeueReusableCell(withType: PostDriveCourseTVC.self, for: indexPath) else { return UITableViewCell() }
            cell.setContent(text: postData.courseDesc)
            return cell
        default:
            return UITableViewCell()
        }
    }
}


//MARK: Network
extension PostDetailVC {
    func bindToViewModel() {
        viewModel = PostDetailViewModel(postId: additionalDataOfPost?.postID ?? -1)
        let output = viewModel?.transform(input: PostDetailViewModel.Input(), disposeBag: disposeBag)
        output?.postDetailSubject.bind(onNext: { [weak self] postDetailData in
            self?.setPostContentView(postData: postDetailData)
        }).disposed(by: disposeBag)
    }
    
    func setPostContentView(postData: PostDetailData?) {
        print("additionalDataOfPost = \(additionalDataOfPost)")
        postDetailData = postData
        isAuthor = postDetailData?.isAuthor ?? false
        isFavorite = postDetailData?.isFavorite == 0 ? false: true
        isStored = postDetailData?.isStored == 0 ? false: true
        addressList = postDetailData?.course ?? []
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        configureBottomView()
    }
  
    func postCreatePost() {
        dump(writedPostData!)
        print("===서버통신 시작=====")
        CreatePostService.shared.createPost(model: writedPostData!, image: imageList) { result in
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
    
    func requestPostLike() {
        LikeService.shared.Like(userId: Constants.userId,
                                postId: postId) { [self] result in
            switch result {
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
    
    func requestPostScrap() {
        SaveService.shared.requestScrapPost(userId: Constants.userId,
                                            postId: postId) { [self] result in
            
            switch result {
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
