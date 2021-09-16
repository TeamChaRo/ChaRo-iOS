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
    //private var collectionView: UICollectionView!
    
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init()).then {
        $0.backgroundColor = .red
    }
//    var upperLabel = UILabel().then {
//        $0.text = "이메일 아이디"
//        $0.font = .notoSansBoldFont(ofSize: 17)
//        $0.textColor = .mainBlack
//    }
//
//    var upperSubLabel = UILabel().then {
//        $0.text = "사용할 이메일을 입력해주세요"
//        $0.font = .notoSansRegularFont(ofSize: 11)
//        $0.textColor = .gray40
//    }
//
//    var upperTextField = UITextField().then {
//        $0.placeholder = "Ex"
//        $0.backgroundColor = .gray10
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationConrtroller()
    }
    
    private func configureNavigationConrtroller() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //네비게이션 바 나타나게 하기
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(JoinViewCVC.self, forCellWithReuseIdentifier: JoinViewCVC.identifier)
    }
    
    private func configureUI() {
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    

    

}

extension JoinVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JoinViewCVC.identifier, for: indexPath) as? JoinViewCVC else { return UICollectionViewCell() }
        cell.backgroundColor = .red
        
        return cell
    }
    
    
}
