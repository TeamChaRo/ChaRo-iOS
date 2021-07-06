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
    private var resultAddress = AddressDataModel()
    private var backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "backIcon"), for: .normal)
        button.tintColor = .gray40
        return button
    }()
    private var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .notoSansRegularFont(ofSize: 17)
        textField.textColor = .gray30
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
                          separateLine])
        
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
    }
    
    public func setAddressModel(model: AddressDataModel){
        resultAddress = model
    }
    
    public func setAddressModel(model: AddressDataModel, text: String){
        resultAddress = model
        searchTextField.text = text
    }
    
    public func setActionToComponent(){
        backButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    }
    
    @objc func dismissAction(){
        let beforeVC = presentingViewController
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchKeywordVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        keyword = textField.text!
        print(keyword)
    }
    
}
