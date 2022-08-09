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
    private let viewModel: PostDetailViewModel
    
    private var isAuthor = false
    private var isEditingMode = false
    private var driveCell: PostDriveCourseTVC?
    private var addressList: [Course] = []
    private var imageList: [UIImage] = []
    let cellFixedCount: Int = 3 // 0~2 cell은 무조건 존재
    
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
    private var navigationTitleLabel = NavigationTitleLabel(title: "구경하기",
                                                            color: .mainBlack)
    private var bottomView = PostDetailBottomView()
    private let separateLineView = UIView().then {
        $0.backgroundColor = .gray20
    }
    private lazy var modifyButton = UIButton().then {
        $0.setBackgroundImage(ImageLiterals.icMypageMore, for: .normal)
        $0.addTarget(self, action: #selector(registActionSheet), for: .touchUpInside)
    }
    private lazy var saveButton = UIButton().then {
        $0.setTitle("등록", for: .normal)
        $0.titleLabel?.font = .notoSansMediumFont(ofSize: 17)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.addTarget(self, action: #selector(clickedToSaveButton), for: .touchUpInside)
    }
    
    init(postId: Int) {
        viewModel = PostDetailViewModel(postId: postId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func checkModeForSendingServer() {
        if isEditingMode {
            print("editing 모드로 넘겨받음")
            //print("postData = \(postData)")
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
            self.viewModel.postCreatePost()
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
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.hasNotch ? UIScreen.getNotchHeight() + 58: 93)
        }
        separateLineView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom)
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
            $0.top.equalTo(separateLineView.snp.bottom)
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
    
}

//MARK: - Bottom View
extension PostDetailVC {
    private func configureBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(88)
        }
        bottomView.changeLikeDescription(to: viewModel.postDetailData?.likesCount ?? 0)
        bindToBottomView()
    }
    
    private func bindToBottomView() {
        
        
        bottomView.likeButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.viewModel.requestPostLike()
            })
            .disposed(by: disposeBag)
        
        bottomView.scrapButton.rx.tap.asDriver()
            .drive(onNext:{ [weak self] _ in
                self?.viewModel.requestPostScrap()
            })
            .disposed(by: disposeBag)
        
        bottomView.shareButton.rx.tap.asDriver()
            .drive(onNext:{ [weak self] _ in
                self?.viewModel.shareToKakaotalk()
            })
            .disposed(by: disposeBag)
        
        bottomView.likeDescriptionButton.rx.tap.asDriver()
            .drive(onNext:{ [weak self] in
                let nextVC = PostLikeListVC(postId: self?.viewModel.postId ?? -1)
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
        guard let postData = viewModel.postDetailData else {
                  return UITableViewCell()
              }
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withType: PostTitleTVC.self, for: indexPath) else { return UITableViewCell() }
            cell.setContent(title: postData.title ?? "" ,
                                 userName: postData.author ?? "",
                                 date: postData.getCreatedTimeText(),
                                 imageName: postData.profileImage ?? "")
            //TODO: -  user 이미지 + 텍스트 눌렀을 때 해당 유저 마이페이지로 이동
    //            let otherVC = OtherMyPageVC()
    //            otherVC.setOtherUserID(userID: follow.userEmail)
    //            otherVC.modalPresentationStyle = .overFullScreen
    //            self?.present(otherVC, animated: true)
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withType: PostPhotoTVC.self, for: indexPath) else { return UITableViewCell() }
            let imageList = postData.images ?? []
            cell.setContent(imageList: imageList)
            cell.presentingClosure = { [weak self] index in
                let nextVC = ExpendedImageVC(imageList: imageList, currentIndex: index)
                nextVC.modalPresentationStyle = .fullScreen
                self?.present(nextVC, animated: true)
            }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withType: PostCourseThemeTVC.self, for: indexPath) else { return UITableViewCell() }
            cell.setContent(city: postData.province ?? "",
                            region: postData.region ?? "",
                            theme: postData.themes ?? [])
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withType: PostLocationTVC.self, for: indexPath) else { return UITableViewCell() }
            cell.setContent(courseList: postData.course ?? [])
            cell.copyAddressClouser = { locationTitle in
                self.view.showToast(message: "\(locationTitle) 주소를 복사했습니다")
            }
            cell.setCopyClosure()
            cell.presentExpendedMapView = { [weak self] courses in
                let nextVC = ExpendedMapVC(courseList: courses)
                nextVC.modalPresentationStyle = .fullScreen
                self?.present(nextVC, animated: true)
            }
            return cell
            
        case 4:
            guard let cell = tableView.dequeueReusableCell(withType: PostParkingTVC.self, for: indexPath) else { return UITableViewCell() }
            cell.setContent(isParking: postData.isParking ?? false,
                            description: postData.parkingDesc ?? "주차공간에 대한 설명이 없습니다.")
            return cell
            
        case 5:
            guard let cell = tableView.dequeueReusableCell(withType: PostAttentionTVC.self, for: indexPath) else { return UITableViewCell() }
            cell.setAttentionList(list: postData.warnings ?? [] )
            return cell
            
        case 6:
            guard let cell = tableView.dequeueReusableCell(withType: PostDriveCourseTVC.self, for: indexPath) else { return UITableViewCell() }
            cell.setContent(text: postData.courseDesc ?? "" )
            return cell
        default:
            return UITableViewCell()
        }
    }
}


//MARK: Network
extension PostDetailVC {
    
    func bindToViewModel() {
        let output = viewModel.transform(input: PostDetailViewModel.Input(), disposeBag: disposeBag)
        output.postDetailSubject.bind(onNext: { [weak self] postDetailData in
            self?.setPostContentView(postData: postDetailData)
        }).disposed(by: disposeBag)
        
        output.storeSubject.bind(onNext: { [weak self] isStored in
            guard let isStored = isStored,
                  let self = self else { return }
            self.bottomView.scrapButton.isSelected = isStored
        }).disposed(by: disposeBag)
        
        
        viewModel.postLikeClosure = { [weak self] isLiked in
            guard let isLiked = isLiked,
                  let self = self else { return }
            var likeCount = self.viewModel.postDetailData?.likesCount ?? 0
            let isOriginFavarite = self.viewModel.postDetailData?.isFavorite != 0
            
            if !isOriginFavarite && isLiked { // 처음에 좋아요 안누름
                likeCount += 1
            } else if isOriginFavarite && !isLiked { // 처음에 눌렀다가 취소했을 때
                likeCount -= 1
            }
            self.bottomView.likeButton.isSelected = isLiked
            self.bottomView.changeLikeDescription(to: likeCount)
        }
        
    }
    
    func setPostContentView(postData: PostDetailDataModel?) {
        guard let postData = postData else { return }
        isAuthor = postData.isAuthor ?? false
        addressList = postData.course ?? []
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        configureBottomView()
    }

}
