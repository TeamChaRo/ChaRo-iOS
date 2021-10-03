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
    
    var profileLabel = JoinTitleLabel(type: .boldTitle, title: "프로필 사진")
    var nicknameLabel = JoinTitleLabel(type: .boldTitle, title: "닉네임 작성")
    var contractLabel = JoinTitleLabel(type: .boldTitle, title: "약관동의")
        
    var commonPasswordTextField = InputTextField(type: .password, placeholder: "이것은 패쓰워드")
    var commonNormalTextField = InputTextField(type: .normal, placeholder: "이것은 노멀")
    
    var agreeAllLabel = JoinTitleLabel(type: .normalTitle, title: "전체 동의")
    var agreeLine = UIView().then {
        $0.backgroundColor = .gray20
    }
    var agreePushLabel = JoinTitleLabel(type: .normalTitle, title: "(선택)  마케팅 푸시 수신 동의")
    var agreeEmailLabel = JoinTitleLabel(type: .normalTitle, title: "(선택)  마케팅 이메일 수신 동의")
    
    var agreeAllButton = JoinAgreeButton(isBig: true)
    var agreePushButton = JoinAgreeButton(isBig: false)
    var agreeEmailButton = JoinAgreeButton(isBig: false)
    
    
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
    
    var profileNicknameView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let profileView = ProfileView()
    
    var contractView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var contractInputView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let contractBackgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "rectangle243")
    }
    
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
        view.addSubview(nextButton)
        
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
        
        nextButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(690)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(48)
        }
                
    }
    
    private func configureEmailView() {
        
        emailView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        emailView.addSubview(emailInputView)
        emailView.addSubview(emailVerifyInputView)
        
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
        
        
        emailView.dismissKeyboardWhenTappedAround()
    }
    
    
    private func configurePasswordView() {
        passwordView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        passwordView.addSubview(passwordInputView)
        
        passwordInputView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(117)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        passwordInputView.addSubview(commonPasswordTextField)
        
        //기존 뷰에 TF 하나 더 추가 왜 안나오는지 알수가 없음 ... 왜?
        commonPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordInputView.inputTextField!.snp.bottom).offset(10)
            $0.height.equalTo(48)
            $0.leading.trailing.equalTo(passwordInputView)
        }
        
        
        passwordView.dismissKeyboardWhenTappedAround()
    }
    
    private func configureProfileNicknameView() {
        profileNicknameView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        profileNicknameView.addSubviews([profileView,
                                         profileLabel,
                                         nicknameLabel,
                                         commonNormalTextField])
        
        profileLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.bottom.equalToSuperview().offset(-100)
            $0.leading.trailing.equalTo(profileLabel)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileView.cameraButton.snp.bottom).offset(21)
            $0.leading.trailing.equalTo(profileLabel)
        }
        
        commonNormalTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(profileLabel)
            $0.height.equalTo(48)
        }
        
        
        profileView.imagePickerPresentClosure = { picker in
            picker.delegate = self
            self.present(picker, animated: true)
        }
    
    }
    
    private func configureContractView() {
        contractView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        contractView.addSubviews([contractLabel, contractInputView])
        
        contractLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        contractInputView.snp.makeConstraints {
            $0.top.equalTo(contractLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(contractLabel)
            $0.height.equalTo(196)
        }
        
        contractInputView.addSubviews([contractBackgroundImageView,
                                       agreeAllLabel,
                                       agreeLine,
                                       agreePushLabel,
                                       agreeEmailLabel,
                                       agreeAllButton,
                                       agreePushButton,
                                       agreeEmailButton])
        
        contractBackgroundImageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        agreeAllLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(60)
            $0.height.equalTo(22)
        }
        
        agreeAllButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalToSuperview().offset(12)
        }
        
        agreeLine.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalToSuperview().offset(76)
            $0.height.equalTo(1)
        }
        
        agreePushLabel.snp.makeConstraints {
            $0.top.equalTo(agreeLine.snp.bottom).offset(25)
            $0.leading.equalTo(agreeAllLabel.snp.leading)
            $0.height.equalTo(22)
        }
        
        agreePushButton.snp.makeConstraints {
            $0.height.width.equalTo(36)
            $0.top.equalTo(agreeLine.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(18)
        }
        
        agreeEmailLabel.snp.makeConstraints {
            $0.top.equalTo(agreePushLabel.snp.bottom).offset(20)
            $0.leading.equalTo(agreeAllLabel.snp.leading)
            $0.height.equalTo(22)
        }
        
        agreeEmailButton.snp.makeConstraints {
            $0.height.width.leading.equalTo(agreePushButton)
            $0.top.equalTo(agreeLine.snp.bottom).offset(58)
        }
    
        
        
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
        commonPasswordTextField.inputAccessoryView = stickyView
        commonNormalTextField.inputAccessoryView = stickyView
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
        //cell.addSubview(emailView)
        //configureEmailView()
        //cell.addSubview(passwordView)
        //configurePasswordView()
        //cell.addSubview(profileNicknameView)
        //configureProfileNicknameView()
        cell.addSubview(contractView)
        configureContractView()
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


//이미지 피커 extension
extension JoinVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //이미지 선택 Cancel
        picker.dismiss(animated: true) { () in
            self.makeAlert(title: "", message: "이미지 선택이 취소되었습니다.")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        //이미지 Choose
        picker.dismiss(animated: false) { () in
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.profileView.profileImageView.image = image
        }
        
    }
}
