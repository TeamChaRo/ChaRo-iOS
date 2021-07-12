//
//  CreatePostVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/11.
//

import UIKit
import SnapKit

class CreatePostVC: UIViewController {
    
    static let identifier: String = "CreatePostVC"
    
    var postImages: [String] = []

    //MARK: - components
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
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setMainViewLayout()
        configureConponentLayout()
        applyTitleViewShadow()
        
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
//            self.tabBarController?.tabBar.isHidden = false
//            let tabbar = self.navigationController?.presentingViewController as! TabbarVC
//            tabbar.selectedViewController = tabbar.viewControllers![0]
        })
    }
    
    @objc
    func nextButtonDidTap(sender: UIButton){
        //TODO: 작성하기 맵뷰와 연결 예정
    }
    
}

// MARK: - UITableView Extension
extension CreatePostVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 222+33
        default:
            return 89
        }
    }
    
}

extension CreatePostVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
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

//MARK: - import cell function
extension CreatePostVC {
    func getCreatePostTitleCell(tableView: UITableView) -> UITableViewCell{
        guard let titleCell = tableView.dequeueReusableCell(withIdentifier: CreatePostTitleTVC.identifier) as? CreatePostTitleTVC else { return UITableViewCell() }
        titleCell.delegateCell = self
        return titleCell
    }
    
    func getCreatePostPhotoCell(tableView: UITableView) -> UITableViewCell{
        guard let photoCell = tableView.dequeueReusableCell(withIdentifier: CreatePostPhotoTVC.identifier) as? CreatePostPhotoTVC else { return UITableViewCell() }
        photoCell.setCollcetionView()
      
        return photoCell
    }
}

extension CreatePostVC: PostTitlecTVCDelegate {
    func updateTextViewHeight(_ cell: CreatePostTitleTVC,_ textView: UITextView,_ height: CGFloat) {
        print("---")
        
        let size = textView.frame.size
        let newSize = tableView.sizeThatFits(CGSize(width: size.width, height: height))
        
        print(tableView.contentSize)
        
        if size.height != newSize.height {
            print(tableView.contentSize)
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            print(tableView.contentSize)
        }
        
        
    }
}
