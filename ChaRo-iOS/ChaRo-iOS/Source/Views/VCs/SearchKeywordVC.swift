//
//  SearchKeywordVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/07.
//

import UIKit
import SnapKit

class SearchKeywordVC: UIViewController {

    static let identifier = "SearchKeywordVC"
    public var keyword = "안녕하세요"
    private var addressIndex = -1
    private var resultAddress : AddressDataModel?
    private var keywordTableView = UITableView()
    private var autoCompletedKeywordList : [AddressDataModel] = []
    
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
    
    private func setResultAddress(){
        resultAddress = AddressDataModel(latitude: 10.0, longtitude: 10.0, address: "연남동 합숙자리")
    }
    
    public func setAddressModel(model: AddressDataModel, text: String, index: Int){
        resultAddress = model
        searchTextField.placeholder = text
        addressIndex = index
        
    }
    
    public func setActionToComponent(){
        backButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    }
    
    @objc func dismissAction(){
        let beforeVC = presentingViewController as! TabbarVC
        beforeVC.addressMainVC?.addressCellList[addressIndex].setAddressText(addressText: searchTextField.text!)
        self.dismiss(animated: true, completion: nil)
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
        let address = autoCompletedKeywordList[indexPath.row]
        cell.setContents(title: address.title, address: address.address)
        return cell
    }
}

extension SearchKeywordVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        keyword = textField.text!
        print(keyword)
    }
    
}
