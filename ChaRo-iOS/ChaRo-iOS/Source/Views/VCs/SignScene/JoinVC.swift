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
    var navigationView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var navigationViewTitleLabel = UILabel().then {
        $0.text = "회원가입"
        $0.font = .notoSansMediumFont(ofSize: 17)
        $0.textColor = .mainBlack
    }
    
    var backButton = UIButton().then {
        $0.setImage(UIImage(named: "icBackButton"), for: .normal)
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
    
//    var nextButton = UIButton().then {
//        $0.setTitle("다음", for: .normal)
//        $0.backgroundColor = .gray30
//        $0.setTitleColor(.white, for: .normal)
//        $0.clipsToBounds = true
//        $0.layer.cornerRadius = 10
//    }
    
    var stickyNextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .gray30
        $0.titleLabel?.font = .notoSansBoldFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
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
//        view.addSubview(nextButton)
        
        
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
        
//        nextButton.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(690)
//            $0.leading.equalTo(20)
//            $0.trailing.equalTo(-20)
//            $0.height.equalTo(48)
//        }
                
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
    }

    
   
    private func setStickyKeyboardButton() {
        let stickyView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 48))
        
        stickyView.addSubview(stickyNextButton)
        
        stickyNextButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        //emailInputView.inputTextField!.inputAccessoryView = stickyView
        //emailVerifyInputView.inputTextField!.inputAccessoryView = stickyView
        //passwordInputView.inputTextField!.inputAccessoryView = stickyView
        //commonPasswordTextField.inputAccessoryView = stickyView
        //commonNormalTextField.inputAccessoryView = stickyView
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
            self.profileView.profileView.profileImageView.image = image
        }
        
    }
}
