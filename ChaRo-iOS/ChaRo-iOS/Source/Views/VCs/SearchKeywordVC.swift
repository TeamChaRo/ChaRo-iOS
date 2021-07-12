//
//  SearchKeywordVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/07.
//

import UIKit
import SnapKit
import TMapSDK

class SearchKeywordVC: UIViewController {

    static let identifier = "SearchKeywordVC"
    public var keyword = "안녕하세요"
    private let mapView = MapService.getTmapView()
    private var addressIndex = -1
    private var addressType = ""
    private var resultAddress : AddressDataModel?
    private var keywordTableView = UITableView()
    private var autoCompletedKeywordList : [AddressDataModel] = []
    
    private var autoList : [String] = []
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "backIcon"), for: .normal)
        button.tintColor = .gray40
        return button
    }()
    private var searchTextField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.font = .notoSansRegularFont(ofSize: 17)
        textField.textColor = .gray50
        textField.clearsOnBeginEditing = true
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let separateLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray20
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setActionToComponent()
        configureTableView()
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setConstraints(){
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
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-26)
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
        
        keywordTableView.backgroundColor = .red
        
    }
    
    public func setAddressModel(model: AddressDataModel, cellType: String, index: Int){
        resultAddress = model
        searchTextField.placeholder = "\(cellType)를 입력해주세요"
        addressType = cellType
        addressIndex = index
    }
    
    public func setActionToComponent(){
        backButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func getAddressConfirmVC() -> AddressConfirmVC{
        let storyboard = UIStoryboard(name: "AddressConfirm", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(identifier: AddressConfirmVC.identifier) as? AddressConfirmVC else {
            return AddressConfirmVC()
        }
        return nextVC
    }
    
    private func reloadTableViewData(){
        print("reloadTableViewData")
        DispatchQueue.main.sync {
            print("count = \(self.autoCompletedKeywordList.count) ")
            self.keywordTableView.reloadData()
        }
    }
    
    @objc func dismissAction(){
        self.navigationController?.popViewController(animated: true)
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
                        let poiItem = AddressDataModel(latitude: String(poi.coordinate?.latitude ?? 0),
                                                       longitude: String(poi.coordinate?.longitude ?? 0) ,
                                                       address: poi.address ?? "주소안뜸",
                                                       title: poi.name ?? "이름없음")
                        self.autoCompletedKeywordList.append(poiItem)
                        results += 1
                        print(results)
                        
                    }
                }
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let pathData = TMapPathData()
        
        print("search Keyword = \(textField.text)")
        let searchKeyword = textField.text!
        DispatchQueue.global().sync {
            pathData.autoComplete(searchKeyword){results , error in
                self.searchKeywordPOI(keywordList: results, pathData: pathData)
            }
        }
    }
}


//MARK:- TableView
extension SearchKeywordVC {
    
    func configureTableView(){
        keywordTableView.registerCustomXib(xibName: SearchKeywordCell.identifier)
        keywordTableView.delegate = self
        keywordTableView.dataSource = self
    }
    
    func setTableViewStyle(){
    }

}

extension SearchKeywordVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

extension SearchKeywordVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompletedKeywordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchKeywordCell.identifier) as? SearchKeywordCell else {return UITableViewCell()}
        
        if autoCompletedKeywordList.count == 0 {
            return UITableViewCell()
        }
        
        let address = autoCompletedKeywordList[indexPath.row]
        cell.setContents(addressMadel: address)
        cell.presentingMapViewClosure = { address in
            let nextVC = self.getAddressConfirmVC()
            nextVC.setPresentingAddress(address: address)
            nextVC.setSearchType(type: self.addressType, index: self.addressIndex)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        return cell
    }
}

