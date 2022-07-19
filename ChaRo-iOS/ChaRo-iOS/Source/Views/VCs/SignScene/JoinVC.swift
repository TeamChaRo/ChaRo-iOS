//
//  JoinVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/09/13.
//

import UIKit
import SnapKit
import Then
import GoogleSignIn

//컬렉션 뷰 안에 뷰 만들기 컬렉션 뷰 위에 차 만들어서 인덱스 ?? 해서 움직이게 하면 될듯
class JoinVC: UIViewController {
    
    static let identifier = "JoinVC"
    var pageNumber: Int = 1
    
    //MARK: - UI Variables
    var navigationView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var navigationViewTitleLabel = UILabel().then {
        $0.text = "회원가입"
        $0.font = .notoSansMediumFont(ofSize: 17)
        $0.textColor = .mainBlack
    }
    
    var backButton = UIButton().then {
        $0.setImage(ImageLiterals.icBack, for: .normal)
        $0.addTarget(self, action: #selector(moveBack), for: .touchUpInside)
    }
    
    var naviBarLine = UIView().then {
        $0.backgroundColor = .gray20
    }
    
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
    
    var emailView = JoinEmailView()
    var passwordView = JoinPasswordView()
    var profileView = JoinProfileView()
    var contractView = JoinContractView()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureUI()
        configureNotificationCenter()
        configureClosure()
        
        showView(number: pageNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            removeObservers()
    }
    
    //MARK: - configure 함수
    private func configureNavigationController() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //네비게이션 바 숨기기
    }
    
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(JoinViewCVC.self, forCellWithReuseIdentifier: JoinViewCVC.identifier)
        
    }
    
    private func configureClosure() {
        emailView.nextButton.nextPageClosure = {
                self.showView(number: 2)
                self.moveCar(toPage: 2)
        }
        
        emailView.stickyNextButton.nextPageClosure = {
                self.showView(number: 2)
                self.moveCar(toPage: 2)
        }
        
        passwordView.nextButton.nextPageClosure = {
                self.showView(number: 3)
                self.moveCar(toPage: 3)
        }
        
        passwordView.stickyNextButton.nextPageClosure = {
                self.showView(number: 3)
                self.moveCar(toPage: 3)
        }
        
        profileView.nextButton.nextPageClosure = {
            self.showView(number: 4)
            self.moveCar(toPage: 4)
        }
        
        profileView.stickyNextButton.nextPageClosure = {
                self.showView(number: 4)
                self.moveCar(toPage: 4)
        }
        
        contractView.nextButton.nextPageClosure = {
            //회원가입 요청
            let userEmail = self.emailView.emailInputView.inputTextField?.text
            let password = self.passwordView.passwordInputView.secondTextField.text
            let nickname = self.profileView.nicknameView.inputTextField?.text
            let image = self.profileView.profileView.profileImageView.image
            let marketingPush = self.contractView.agreePushButton.agreed
            let marketingEmail = self.contractView.agreeEmailButton.agreed
            
            
            self.postJoin(userEmail: userEmail!,
                          password: password!,
                          nickname: nickname!,
                          marketingPush: marketingPush,
                          marketingEmail: marketingEmail,
                          image: (image ?? UIImage(named: "icProfile"))!)
        }
        
    }
    
    //MARK: - Custom 함수
    func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textFieldMoveUp(_ notification: NSNotification) {
        if (!self.emailView.isHidden && !self.emailView.emailVerifyInputView.isHidden) || !self.profileView.isHidden {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
                })
            }
        }
    }
    
    @objc func textFieldMoveDown(_ notification: NSNotification) {
        view.transform = .identity
    }

    private func showView(number: Int) {
        
        if number == 0 {
            self.navigationController?.popViewController(animated: true)
        }
        
        pageNumber = number
        
        switch number {
        case 1:
            emailView.isHidden = false
            passwordView.isHidden = true
            profileView.isHidden = true
            contractView.isHidden = true
        case 2:
            emailView.isHidden = true
            passwordView.isHidden = false
            profileView.isHidden = true
            contractView.isHidden = true
        case 3:
            emailView.isHidden = true
            passwordView.isHidden = true
            profileView.isHidden = false
            contractView.isHidden = true
        case 4:
            emailView.isHidden = true
            passwordView.isHidden = true
            profileView.isHidden = true
            contractView.isHidden = false
        default:
            print("엥")
        }
        
    }
    
    @objc func moveBack() {
        showView(number: pageNumber - 1)
        moveCar(toPage: pageNumber)
    }
    
    private func moveCar(toPage: Int) {
        let carLocation_1 = CGFloat(15)
        let carLocation_2 = (self.view.frame.width - 30) / 4
        let carLocation_3 = carLocation_1 + carLocation_2 * 2
        let carLocation_4 = carLocation_1 + carLocation_2 * 3
        
        var destination = (self.view.frame.width - 30) / 4
        
        switch toPage {
        case 1:
            destination = carLocation_1
            break
        case 2:
            destination = carLocation_2
            break
        case 3:
            destination = carLocation_3
            break
        case 4:
            destination = carLocation_4
            break
        default:
            break
        }
        
        UIView.animate(withDuration: 1.0) {
            self.blueCar.transform = CGAffineTransform(translationX: destination, y: 0)
        }
    }

    
    
    //MARK: - UI 관련 코드
    private func setupNavigationViewUI() {
        
        navigationView.addSubviews([navigationViewTitleLabel,
                                    backButton,
                                    naviBarLine])
        
        
        navigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(102)
        }
        
        navigationViewTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(58)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(45)
            $0.width.height.equalTo(48)
            $0.leading.equalToSuperview()
        }
        
        naviBarLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
    }
    
    private func configureUI() {
        
        view.addSubview(navigationView)
        view.addSubview(collectionView)
        
        setupNavigationViewUI()
        
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
    
    
    private func configureViewsUI() {
        emailView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        passwordView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        profileView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        contractView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        profileView.profileView.imagePickerPresentClosure = { picker in
            picker.delegate = self
            self.present(picker, animated: true)
        }
        
        contractView.emailDocumentPresentClosure = { safariView in
            self.present(safariView, animated: true, completion: nil)
        }
        
        contractView.pushDocumentPresentClosure = { safariView in
            self.present(safariView, animated: true, completion: nil)
        }
    }
    
    
    private func postJoin(userEmail: String,
                          password: String,
                          nickname: String,
                          marketingPush: Bool,
                          marketingEmail: Bool,
                          image: UIImage) {
        
        EmailJoinService.shared.EmailJoin(userEmail: userEmail,
                                          password: password,
                                          nickname: nickname,
                                          marketingPush: marketingPush,
                                          marketingEmail: marketingEmail,
                                          image: image) { result in
            switch result {
            
            case .success(let msg):
                print("success", msg)
                self.navigationController?.popViewController(animated: true)
            case .requestErr(let msg):
                print("requestERR", msg)
            case .pathErr:
                print("pathERR")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                print("networkFail")
                
            }
            
        }
    }
    
    
}


//MARK: - Extension
extension JoinVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JoinViewCVC.identifier, for: indexPath) as? JoinViewCVC else { return UICollectionViewCell() }
        cell.backgroundColor = .white
        
        cell.addSubviews([emailView,
                          passwordView,
                          profileView,
                          contractView])
        configureViewsUI()
        
        passwordView.isHidden = true
        profileView.isHidden = true
        contractView.isHidden = true
        
        return cell
    }
    
    
}


extension JoinVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 250)
    }
}


//MARK: -이미지 피커 extension
extension JoinVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //이미지 선택 Cancel
        picker.dismiss(animated: true) { () in
            self.makeAlert(title: "", message: "이미지 선택이 취소되었습니다.")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        //이미지 Choose
        picker.dismiss(animated: false) { () in
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.profileView.profileView.profileImageView.image = image
        }
        
    }
}


extension JoinVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
