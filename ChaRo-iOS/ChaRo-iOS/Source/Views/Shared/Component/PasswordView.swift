//
//  PasswordView.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/10/05.
//

import UIKit
import RxSwift
import RxRelay

class PasswordView: UIView, UITextFieldDelegate {
    
    var firstRelay = PublishSubject<Bool>()
    var secondRelay = PublishSubject<Bool>()
    var validateRelay: Observable<Bool> {
        return Observable.combineLatest(firstRelay, secondRelay)
            .map { first, second in
                return first && second
            }
    }
    let disposeBag = DisposeBag()
    
    var isFirstPassed = false
    var isSecondPassed = false
    
    var titleLabel = UILabel().then {
        $0.font = .notoSansBoldFont(ofSize: 17)
        $0.textColor = .mainBlack
    }
    var subTitleLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 11)
        $0.textColor = .gray40
    }
    var firstTextField = InputTextField(type: .password, placeholder: "5이상 15자 이내의 영문과 숫자")
    var secondTextField = InputTextField(type: .password, placeholder: "비밀번호를 한번 더 작성해주세요")
    var statusLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.textColor = .mainOrange
    }
    
    var enableNextButtonClosure: (() -> Void)?
    var unableNextButtonClosure: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, subTitle: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        subTitleLabel.text = subTitle
        configureTextField()
        setConstraints()
        bind()
    }
    
    
    private func configureTextField() {
        firstTextField.delegate = self
        secondTextField.delegate = self
    }
    
    private func setConstraints() {
        
        addSubviews([titleLabel,
                     subTitleLabel,
                     firstTextField,
                     secondTextField,
                     statusLabel])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        firstTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(48)
        }
        
        secondTextField.snp.makeConstraints {
            $0.top.equalTo(self.firstTextField.snp.bottom).offset(10)
            $0.leading.trailing.height.equalTo(firstTextField)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(self.secondTextField.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(6)
            $0.height.equalTo(14)
        }
        
        
    }
    
    func bind() {
        self.firstTextField.rx.text.orEmpty
            .subscribe(onNext: { text in
                if text == "" {
                    self.setLabelOrangeWithText(text: "비밀번호를 입력해주세요.")
                    self.firstRelay.onNext(false)
                } else if !(self.validCountPassword(password: text)) {
                    self.setLabelOrangeWithText(text: "5자 이상 15자 이내로 작성해 주세요.")
                    self.firstRelay.onNext(false)
                } else {
                    self.setLabelBlueWithText(text: "사용가능한 비밀번호 입니다.")
                    self.firstRelay.onNext(true)
                }
            }).disposed(by: disposeBag)
        
        self.secondTextField.rx.text.orEmpty
            .subscribe(onNext: { text in
                if text == "" {
                    self.setLabelOrangeWithText(text: "비밀번호를 입력해주세요.")
                    self.secondRelay.onNext(false)
                    return
                }
                if self.firstTextField.text != text {
                    self.setLabelOrangeWithText(text: "비밀번호가 일치하지 않습니다.")
                    self.secondRelay.onNext(false)
                } else {
                    self.setLabelBlueWithText(text: "비밀번호가 일치합니다.")
                    self.secondRelay.onNext(true)
                }
            }).disposed(by: disposeBag)
        
        self.firstRelay.subscribe(onNext: { result in
            if result {
                self.firstTextField.setBlueBorderWithText()
            } else {
                self.firstTextField.setOrangeBorderWithText()
            }
        }).disposed(by: disposeBag)
        
        self.secondRelay.subscribe(onNext: { result in
            if result {
                self.secondTextField.setBlueBorderWithText()
            } else {
                self.secondTextField.setOrangeBorderWithText()
            }
        }).disposed(by: disposeBag)
        
        validateRelay.subscribe(onNext: { result in
            guard self.firstTextField.text == self.secondTextField.text else {
                self.setLabelBlueWithText(text: "비밀번호가 일치하지 않습니다.")
                self.secondTextField.setOrangeBorderWithText()
                return
            }
            if result {
                self.enableNextButtonClosure!()
            } else {
                self.unableNextButtonClosure!()
            }
        }).disposed(by: disposeBag)
    }
    
    func validCountPassword(password: String) -> Bool {
        if password.count >= 5 && password.count < 15 {
            return true
        } else {
            return false
        }
    }
    
    func validExPassword(password: String) -> Bool {
        let pwRegEx = "[A-Za-z0-9]"
        let pred = NSPredicate(format: "SELF MATCHES %@", pwRegEx)
        return pred.evaluate(with: password)
    }
    
    func setLabelBlueWithText(text: String) {
        statusLabel.text = text
        statusLabel.textColor = .mainBlue
    }
    
    func setLabelOrangeWithText(text: String) {
        statusLabel.text = text
        statusLabel.textColor = .mainOrange
    }
    
}
