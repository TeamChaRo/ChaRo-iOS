//
//  BannerVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/05/10.
//

import UIKit

import Then
import RxSwift

class BannerVC: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewRetio: CGFloat = UIScreen.getDeviceWidth() / 375
    let scrollView = UIScrollView()
    
    let backButton = UIButton().then {
        $0.setImage(ImageLiterals.icBack, for: .normal)
    }
    private let titleLabel = UILabel().then {
        $0.font = .notoSansMediumFont(ofSize: 17)
        $0.textColor = .subBlack
    }
    
    init(title: String) {
        titleLabel.text = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureUI()
        setConstraints()
        bind()
    }
    
    func setConstraints() {
        view.addSubviews([backButton, titleLabel, scrollView])
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(9)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func bind() {
        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
}
