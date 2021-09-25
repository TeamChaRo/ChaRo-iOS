//
//  JoinVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/09/13.
//

import UIKit
import SnapKit
import Then

//컬렉션 뷰 안에 뷰 만들기 컬렉션 뷰 위에 차 만들어서 인덱스 ?? 해서 움직이게 하면 될듯
class JoinVC: UIViewController {

    static let identifier = "JoinVC"
    
    //MARK: - UI Variables
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        return cv
    }()

    var blueCar = UIButton().then {
        $0.setImage(UIImage(named: "blueCar"), for: .normal)
    }
    
    var blueLine = UIImageView().then {
        $0.image = UIImage(named: "blueCarLine")
    }
    
    var upperLabel = UILabel().then {
        $0.text = "이메일 아이디"
        $0.font = .notoSansBoldFont(ofSize: 17)
        $0.textColor = .mainBlack
    }

    var upperSubLabel = UILabel().then {
        $0.text = "사용할 이메일을 입력해주세요"
        $0.font = .notoSansRegularFont(ofSize: 11)
        $0.textColor = .gray40
    }

    var upperTextField = UITextField().then {
        $0.placeholder = "ex)charorong@gmail.com"
        $0.backgroundColor = .gray10
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray20.cgColor
        $0.addLeftPadding(14)
        $0.clearButtonMode = .whileEditing
    }
    
    var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .gray30
        $0.setTitleColor(.white, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    lazy var navBar = UINavigationBar().then {
        $0.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 102)
        $0.backgroundColor = UIColor.white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray20.cgColor
    }
    
    var EmailView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var verifyEmailView = UIView().then {
        $0.backgroundColor = .white
    }
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationController()
    }
    
    
    //MARK: - private func
    private func configureNavigationController() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //네비게이션 바 숨기기
    }
    
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(JoinViewCVC.self, forCellWithReuseIdentifier: JoinViewCVC.identifier)
        
    }
    
    //왜 안될까..?
    private func setupNavigationBar() {
        
        self.view.addSubview(navBar)
//
//        var navItem = UINavigationItem(title: "회원가입")
        
//        let titleLabel = UILabel().then {
//            $0.text = "회원가입"
//            $0.font = .notoSansRegularFont(ofSize: 17)
//        }

//        navItem.titleView = titleLabel
//        navBar.items = [navItem]
    }
    
    private func configureUI() {
        
        view.addSubview(collectionView)
        
        view.addSubview(blueCar)
        view.addSubview(blueLine)
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        blueCar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(124)
            $0.leading.equalTo(15)
            $0.width.equalTo(36)
            $0.height.equalTo(21)
        }
        
        blueLine.snp.makeConstraints {
            $0.top.equalToSuperview().offset(131)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-23)
        }
        
        configureVerifyEmailView()
        
    }
    
    private func configureEmailView() {
        
        EmailView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        EmailView.addSubview(upperLabel)
        EmailView.addSubview(upperSubLabel)
        EmailView.addSubview(upperTextField)
        EmailView.addSubview(nextButton)
        
        
        upperLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        upperSubLabel.snp.makeConstraints {
            $0.top.equalTo(upperLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalTo(upperLabel)
        }
        
        upperTextField.snp.makeConstraints {
            $0.top.equalTo(upperSubLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(upperLabel)
            $0.height.equalTo(48)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-75)
            $0.leading.trailing.equalTo(upperLabel)
            $0.height.equalTo(48)
        }
        
        EmailView.dismissKeyboardWhenTappedAround()
    }
    
    private func configureVerifyEmailView() {
        
    }
    

    

}


//MARK: - Extension
extension JoinVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JoinViewCVC.identifier, for: indexPath) as? JoinViewCVC else { return UICollectionViewCell() }
        cell.backgroundColor = .white
        cell.addSubview(EmailView)
        configureEmailView()
        return cell
    }
    
    
}

extension JoinVC: UICollectionViewDelegate {
    
}


extension JoinVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 250)
    }
}
