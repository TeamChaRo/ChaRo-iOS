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

class SearchAddressKeywordVC: UIViewController {

    static let identifier = "SearchAddressKeywordVC"
    private let viewModel = SearchKeywordViewModel()
    private var disposeBag = DisposeBag()
    
    private var addressIndex = -1
    private var addressType = ""
    
    //MARK: UI Component
    private var backButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "backIcon"), for: .normal)
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
    private let separateLine = UIView().then {
        $0.backgroundColor = .gray20
    }
    private var tableView = UITableView().then {
        $0.register(cell: SearchKeywordCell.self)
        $0.rowHeight = 72
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupConstraints()
        setActionToComponent()
        bindToViewModel()
    }
    
    //MARK: - public func
    public func setAddressModel(model: AddressDataModel, cellType: String, index: Int){
        searchTextField.placeholder = "\(cellType)를 입력해주세요"
        addressType = cellType
        addressIndex = index
    }
    
    public func setSearchKeyword(list: [KeywordResult]){
        print(list)
    }
    
    // MARK: - private func
    
    private func configureUI(){
        view.backgroundColor = .white
    }
    
    private func bindToViewModel(){
        viewModel
            .addressSubject
            .bind(to: tableView.rx.items(cellIdentifier: SearchKeywordCell.className,
                                                cellType: SearchKeywordCell.self)){ row, element, cell in
                cell.titleLabel.text = element.title
                cell.addressLabel.text = element.address
                cell.dateLabel.text = self.viewModel.getCurrentDate()
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(AddressDataModel.self)
            .subscribe(onNext: {
                self.pushNextVC(address: $0)
            })
            .disposed(by: disposeBag)
        
        searchTextField.rx.text
            .throttle(.milliseconds(1500), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: {
                print("검색하는 text = \($0)")
                self.viewModel.findAutoCompleteAddressList(keyword: $0 ?? "")
            }).disposed(by: disposeBag)
    }
    
    private func pushNextVC(address: AddressDataModel){
        let nextVC = AddressConfirmVC()
        nextVC.setPresentingAddress(address: address)
        nextVC.setSearchType(type: self.addressType, index: self.addressIndex)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    public func setActionToComponent(){
        backButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    }
    
    @objc func dismissAction(){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: Layout
extension SearchAddressKeywordVC {
    private func setupConstraints(){
        view.addSubviews([backButton,
                          searchTextField,
                          separateLine,
                          tableView])
        
        backButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
            $0.width.equalTo(48)
        }
        
        searchTextField.snp.makeConstraints{
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.leading.equalTo(backButton.snp.trailing)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(26)
        }
        
        separateLine.snp.makeConstraints{
            $0.top.equalTo(backButton.snp.bottom).offset(11)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(separateLine.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.dismissKeyboardWhenTappedAround()
    }
}
