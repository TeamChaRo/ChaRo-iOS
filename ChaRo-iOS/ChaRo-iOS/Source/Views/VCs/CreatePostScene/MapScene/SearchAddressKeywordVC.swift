//
//  SearchAddressKeywordVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/09/03.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

final class SearchAddressKeywordVC: UIViewController {

    private let viewModel: SearchKeywordViewModel
    private var disposeBag = DisposeBag()
    private var searchKeywordSubject = PublishSubject<AddressDataModel>()
    private var addressIndex: Int = -1
    private var addressType: String = ""
    private var keywordType: KeywordType = .recently
    
    enum KeywordType: String {
        case recently = "최근 검색"
        case related = "연관 검색어"
        case result = "검색 결과"
    }
    
    //MARK: UI Component
    private var backButton = UIButton().then {
        $0.setBackgroundImage(ImageLiterals.icBack, for: .normal)
        $0.tintColor = .gray40
    }
    private var searchTextField = UITextField().then {
        $0.autocorrectionType = .no
        $0.font = .notoSansRegularFont(ofSize: 17)
        $0.textColor = .gray50
        $0.clearsOnBeginEditing = true
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
    }
    
    private let textFieldSeparateLine = UIView().then {
        $0.backgroundColor = .gray20
    }
    
    private let contentTitleLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.textColor = .gray40
    }
    
    private let contentSeparateLine = UIView().then {
        $0.backgroundColor = .gray20
    }
    
    private var tableView = UITableView().then {
        $0.register(cell: SearchKeywordCell.self)
        $0.rowHeight = 72
    }
    
    init(searchHistory: [KeywordResult]) {
        self.viewModel = SearchKeywordViewModel(searchHistory: searchHistory)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupConstraints()
        bind()
    }
    
    //MARK: - public func
    
    public func setAddressModel(model: AddressDataModel, cellType: String, index: Int) {
        searchTextField.placeholder = "\(cellType)를 입력해주세요"
        addressType = cellType
        addressIndex = index
    }
   
    // MARK: - private func
    private func configureUI() {
        view.backgroundColor = .white
        contentTitleLabel.text = keywordType.rawValue
    }
    
    private func bind() {
        let output = viewModel.transform(input: SearchKeywordViewModel.Input(), disposeBag: disposeBag)
        output.addressSubject
            .bind(to: tableView.rx.items(cellIdentifier: SearchKeywordCell.className,
                                         cellType: SearchKeywordCell.self)) { [weak self] row, element, cell in
                guard let self = self else { return }
                cell.setContent(element: element,
                                keyword: self.searchTextField.text ?? "",
                                date: self.viewModel.getCurrentDate())
                cell.dateLabel.isHidden = self.keywordType != .recently
                self.contentTitleLabel.text = self.keywordType.rawValue                
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(AddressDataModel.self)
            .subscribe(onNext: { [weak self] in
                self?.pushNextVC(address: $0)
            })
            .disposed(by: disposeBag)
        
        searchTextField.rx.text
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self]  in
                if $0 == "" {
                    self?.viewModel.refreshSearchHistory()
                    self?.keywordType = .recently
                } else {
                    self?.viewModel.findAutoCompleteAddressList(keyword: $0 ?? "")
                    self?.keywordType = .related
                }
            }).disposed(by: disposeBag)

        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.keywordType = .result
                self?.viewModel.findAutoCompleteAddressList(keyword: self?.searchTextField.text ?? "")
            }).disposed(by: disposeBag)
        
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func pushNextVC(address: AddressDataModel) {
        self.addSearchedKeyword(address: address)
        let nextVC = AddressConfirmVC()
        nextVC.setPresentingAddress(address: address)
        nextVC.setSearchType(type: self.addressType, index: self.addressIndex)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func addSearchedKeyword(address: AddressDataModel) {
        viewModel.searchedHistory.append(address.getKeywordResult())
        guard let addressMainVC = self.navigationController?.previousViewController as? AddressMainVC else { return }
        addressMainVC.addSearchedKeyword(address: address)
    }
    
}

//MARK: Layout
extension SearchAddressKeywordVC {
    private func setupConstraints() {
        view.addSubviews([backButton,
                          searchTextField,
                          textFieldSeparateLine,
                          contentTitleLabel,
                          contentSeparateLine,
                          tableView])
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
            $0.width.equalTo(48)
        }
        
        searchTextField.snp.makeConstraints {
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.leading.equalTo(backButton.snp.trailing)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(26)
        }
        
        textFieldSeparateLine.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(11)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(2)
        }
        
        contentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(textFieldSeparateLine.snp.bottom).offset(13)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        contentSeparateLine.snp.makeConstraints {
            $0.top.equalTo(contentTitleLabel.snp.bottom).offset(13)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(contentSeparateLine.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.dismissKeyboardWhenTappedAround()
    }
}
