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
    
    var selectImages: [UIImage] = []
    var cellHeights: [CGFloat] = []
    
    var itemProviders: [NSItemProvider] = []
    var iterator: IndexingIterator<[NSItemProvider]>?

    //MARK:  components
    let tableView: UITableView = UITableView()
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
    
}

// MARK: - functions
extension CreatePostVC {
    
    // MARK: Setting function
    
    func configureTableView(){
        registerXibs()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func registerXibs(){
        tableView.registerCustomXib(xibName: CreatePostTitleTVC.identifier)
        tableView.registerCustomXib(xibName: CreatePostPhotoTVC.identifier)
    }
    
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func applyTitleViewShadow(){
        titleView.getShadowView(color: UIColor.black.cgColor, masksToBounds: false, shadowOffset: CGSize(width: 0, height: 10), shadowRadius: 6, shadowOpacity: 0.05)

        self.view.bringSubviewToFront(titleView)
    }
    
    func initCellHeight(){
        cellHeights.append(contentsOf: [89, 255])
    }
    
    func setNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoButtonDidTap), name: .callPhotoPicker, object: nil)
    }
    
    func postCreatePost(){
        let images: [UIImage] = [UIImage(named: "testimage")!, UIImage(named: "Mask Group")!]
        //TODO: 작성하기 맵뷰(혜령)와 연결 예정
        
        print("===서버통신 시작=====")
        CreatePostService.shared.createPost(userId: "111", theme: ["하잉","예원"], warning: [true,true,false,false], isParking: true, image: images){ result in
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
    
    // MARK: Layout
    func setMainViewLayout(){
        self.view.addSubviews([titleView,tableView])
        
        let titleRatio: CGFloat = 58/375
        
        titleView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(UIScreen.getDeviceWidth()*titleRatio)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(UIScreen.getDeviceWidth()*titleRatio)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureConponentLayout(){
        titleView.addSubviews([titleLabel, xButton, nextButton])
        
        titleLabel.snp.makeConstraints{
            let topRatio: CGFloat = 14/58
            let titleRatio: CGFloat = 58/375
            $0.top.equalTo((UIScreen.getDeviceWidth()*titleRatio)*topRatio)
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
        self.dismiss(animated: true, completion: {
            self.tabBarController?.selectedIndex = 0
            // TODO: 홈 탭으로 돌아가는 코드 추가
        })
    }
    
    @objc
    func nextButtonDidTap(sender: UIButton){
        let storyboard = UIStoryboard(name: "AddressMain", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: AddressMainVC.identifier) as? AddressMainVC else {
            return
        }
        vc.setAddressListData(list: [])
        
        self.navigationController?.pushViewController(vc, animated: false)
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
