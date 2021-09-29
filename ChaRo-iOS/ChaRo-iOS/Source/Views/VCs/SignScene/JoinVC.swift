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
    
    var commonTextField = InputTextField(type: .password, placeholder: "나온다 !!!!!!!!!!")
    
    var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .gray30
        $0.setTitleColor(.white, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    var stickyNextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .gray30
        $0.titleLabel?.font = .notoSansBoldFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
    }
    
    lazy var navBar = UINavigationBar().then {
        $0.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 102)
        $0.backgroundColor = UIColor.white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray20.cgColor
    }
    
    var emailView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let emailInputView = JoinInputView(title: "이메일 아이디",
                                       subTitle: "사용할 이메일을 입력해주세요.",
                                       placeholder: "ex)charorong@gmail.com",
                                       type: .normal)
    
    
    var verifyEmailView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let emailVerifyInputView = JoinInputView(title: "이메일 인증번호",
                                        subTitle: "이메일로 보내드린 인증번호를 입력해주세요.",
                                        placeholder: "ex)울랄라",
                                        type: .normal)
    
    
    var passwordView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let passwordInputView = JoinInputView(title: "비밀번호 486",
                                          subTitle: "5자 이상 15자 이내의 비밀번호를 입력해주세요.",
                                          placeholder: "5이상 15자 이내의 영문과 숫자",
                                          type: .password)
    
    
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        configureUI()
        setStickyKeyboardButton()
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
                
    }
    
    private func configureEmailView() {
        
        emailView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        emailView.addSubview(emailInputView)
        emailView.addSubview(emailVerifyInputView)
        emailView.addSubview(nextButton)
        
        emailInputView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(117)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        emailVerifyInputView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.height.equalTo(117)
            $0.leading.trailing.equalTo(emailInputView)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-75)
            $0.leading.trailing.equalTo(emailInputView)
            $0.height.equalTo(48)
        }
        
        emailView.dismissKeyboardWhenTappedAround()
    }
    
    
    private func configurePasswordView() {
        passwordView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        passwordView.addSubview(passwordInputView)
        passwordView.addSubview(nextButton)
        
        passwordInputView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(117)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        passwordInputView.addSubview(commonTextField)
        
        //기존 뷰에 TF 하나 더 추가 왜 안나오는지 알수가 없음 ... 왜?
        commonTextField.snp.makeConstraints {
            $0.top.equalTo(passwordInputView.inputTextField!.snp.bottom).offset(10)
            $0.height.equalTo(48)
            $0.leading.trailing.equalTo(passwordInputView)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-75)
            $0.leading.trailing.equalTo(passwordInputView)
            $0.height.equalTo(48)
        }
        
        passwordView.dismissKeyboardWhenTappedAround()
    }
    
    private func setStickyKeyboardButton() {
        let stickyView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 48))
        
        stickyView.addSubview(stickyNextButton)
        
        stickyNextButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        emailInputView.inputTextField!.inputAccessoryView = stickyView
        emailVerifyInputView.inputTextField!.inputAccessoryView = stickyView
        passwordInputView.inputTextField!.inputAccessoryView = stickyView
        commonTextField.inputAccessoryView = stickyView
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
        cell.addSubview(passwordView)
        //cell.addSubview(emailView)
        //configureEmailView()
        configurePasswordView()
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
