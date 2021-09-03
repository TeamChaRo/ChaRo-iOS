//
//  SearchKeywordVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/07.
//

import UIKit
import SnapKit
import TMapSDK
import Then
import RxCocoa
import RxSwift

class SearchKeywordVC: UIViewController {

    static let identifier = "SearchKeywordVC"
    private let viewModel = SearchKeywordViewModel()
    private var disposeBag = DisposeBag()
    
    private let mapView = MapService.getTmapView()
    private var addressIndex = -1
    private var addressType = ""
    private var resultAddress : AddressDataModel?
    
    private var searchHistory : [KeywordResult] = []
    private var newSearchHistory : [KeywordResult] = []
    private var autoCompletedKeywordList : [AddressDataModel] = [AddressDataModel()]
    
    private var autoList : [String] = []
    
    private var backButton = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "backIcon"), for: .normal)
        $0.tintColor = .gray40
    }
    
    private var searchTextField = UITextField().then{
        $0.autocorrectionType = .no
        $0.font = .notoSansRegularFont(ofSize: 17)
        $0.textColor = .gray50
        $0.clearsOnBeginEditing = true
        $0.clearButtonMode = .whileEditing
    }
    
    private let separateLine = UIView().then{
        $0.backgroundColor = .gray20
    }
    
    private var keywordTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setActionToComponent()
        configureTableView()
        navigationController?.isNavigationBarHidden = true
        searchTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let searchMain = navigationController?.viewControllers[1] as! AddressMainVC
        searchMain.newSearchHistory = self.newSearchHistory + searchMain.newSearchHistory
    }
   
    public func setAddressModel(model: AddressDataModel, cellType: String, index: Int){
        resultAddress = model
        searchTextField.placeholder = "\(cellType)를 입력해주세요"
        addressType = cellType
        addressIndex = index
    }
    
    public func setSearchKeyword(list: [KeywordResult]){
        searchHistory = list
        print(searchHistory)
    }
    
    public func setActionToComponent(){
        backButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func dismissAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getAddressConfirmVC() -> AddressConfirmVC{
        let storyboard = UIStoryboard(name: "AddressConfirm", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(identifier: AddressConfirmVC.identifier) as? AddressConfirmVC else {
            return AddressConfirmVC()
        }
        return nextVC
    }
    
   
    
    private func bindToViewModel(){
        viewModel
            .addressSubject
            .bind(to: keywordTableView.rx.items(cellIdentifier: SearchKeywordCell.identifier,
                                                cellType: SearchKeywordCell.self)){ row, element, cell in
                cell.titleLabel.text = element.title
                cell.addressLabel.text = element.address
                cell.dateLabel.text = self.viewModel.getCurrentDate()
            }.disposed(by: disposeBag)
        
        keywordTableView.rx.modelSelected(AddressDataModel.self)
            .subscribe(onNext: {
                print("선택된 주소 - \($0.address)")
                print("---------------------------")
//                let nextVC = self.getAddressConfirmVC()
//                nextVC.setPresentingAddress(address: $0)
//                nextVC.setSearchType(type: self.addressType, index: self.addressIndex)
//                self.navigationController?.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func reloadTableViewData(){
        print("reloadTableViewData")
        DispatchQueue.main.sync {
            print("count = \(self.autoCompletedKeywordList.count) ")
            self.keywordTableView.reloadData()
        }
    }
    
   
    private func searchKeywordPOI(keywordList: [String], pathData: TMapPathData){
        var results = 0
        var isLoaded = false
        print("keywordList = \(keywordList.count)")
        autoCompletedKeywordList.removeAll()
        DispatchQueue.global().sync {
            for keyword in keywordList{
                print(keyword)
                pathData.requestFindAllPOI(keyword, count: 5){ poiResults, error in
                    guard let poiItemList = poiResults else{ return }
                    for poi in poiItemList{
                        if results >= 10 {
                            if !isLoaded{
                                print("results is 12")
                                isLoaded = true
                                self.reloadTableViewData()
                            }
                            break
                        }
                        
                        let poiItem = AddressDataModel(title: poi.name ?? "이름없음",
                                                       address: poi.address ?? "주소안뜸",
                                                       latitude: String(poi.coordinate?.longitude ?? 0),
                                                       longitude: String(poi.coordinate?.latitude ?? 0))

                        self.autoCompletedKeywordList.append(poiItem)
                        results += 1
                        print(results)
                        
                    }
                }
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            viewModel.findAutoCompleteAddressList(keyword: text)
        }
        
//        if textField.text == ""{
//            keywordTableView.reloadData()
//        }else{
//            let pathData = TMapPathData()
//            print("search Keyword = \(textField.text)")
//            let searchKeyword = textField.text!
//            DispatchQueue.global().sync {
//                pathData.autoComplete(searchKeyword){results , error in
//                    self.searchKeywordPOI(keywordList: results, pathData: pathData)
//                }
//            }
//        }
    }
}


//MARK:- TableView
extension SearchKeywordVC {
    
    func configureTableView(){
        keywordTableView.registerCustomXib(xibName: SearchKeywordCell.identifier)
        keywordTableView.delegate = self
        keywordTableView.dataSource = self
    }
    
    func setTableViewHeader(){
        var title = ""
        if autoCompletedKeywordList.count == 0{
        }
    }
    
}

extension SearchKeywordVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

extension SearchKeywordVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if autoCompletedKeywordList.count == 0{
            return searchHistory.count
        }
        return autoCompletedKeywordList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchKeywordCell.identifier) as? SearchKeywordCell else {return UITableViewCell()}
        
        if autoCompletedKeywordList.count == 0 {
            if searchHistory.count != 0 {
                let address = searchHistory[indexPath.row]
                cell.setContents(addressMadel: address)
                let addressModel = address.getAddressModel()
                cell.presentingMapViewClosure = { addressModel in
                    let nextVC = self.getAddressConfirmVC()
                    nextVC.setPresentingAddress(address: addressModel)
                    nextVC.setSearchType(type: self.addressType, index: self.addressIndex)
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        }else{
            let address = autoCompletedKeywordList[indexPath.row]
            cell.setContents(addressMadel: address)
            cell.presentingMapViewClosure = { address in
                self.newSearchHistory.insert(address.getKeywordResult(), at: 0)
                self.searchHistory.insert(address.getKeywordResult(), at: 0)
                let nextVC = self.getAddressConfirmVC()
                nextVC.setPresentingAddress(address: address)
                nextVC.setSearchType(type: self.addressType, index: self.addressIndex)
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        return cell
    }
    
}

extension SearchKeywordVC: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        autoCompletedKeywordList = []
        keywordTableView.reloadData()
        return true
    }
}


//MARK: Layout
extension SearchKeywordVC {
    private func setupConstraints(){
        view.addSubviews([backButton,
                          searchTextField,
                          separateLine,
                          keywordTableView])
        
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
        
        keywordTableView.snp.makeConstraints{
            $0.top.equalTo(separateLine.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        keywordTableView.dismissKeyboardWhenTappedAround()
    }
}


