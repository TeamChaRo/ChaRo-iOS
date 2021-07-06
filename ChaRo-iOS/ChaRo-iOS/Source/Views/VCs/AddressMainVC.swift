//
//  AddressSearchVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/06.
//

import UIKit
import SnapKit

class AddressMainVC: UIViewController {

    static let identifier = "AddressMainVC"
    public var addressList : [AddressDataModel] = []
    private var tableView = UITableView()
    private let viewForMap = UIView()
    private var oneCellHeight = 46
    private var tableViewHeight = 92
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        configureTableView()
        initAddressList()
    }

    private func configureTableView(){
        tableView.registerCustomXib(xibName: AddressButtonCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setConstraints(){
        view.addSubviews([tableView,viewForMap])
        
        tableView.snp.makeConstraints{make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(48)
            make.height.equalTo(tableViewHeight)
        }
        
        viewForMap.snp.makeConstraints{make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        viewForMap.backgroundColor = .yellow
    }
    
    
    private func calculateTableViewHeight() -> Int{
        return addressList.count * oneCellHeight
    }
    
    private func initAddressList(){
        addressList.append(contentsOf: [AddressDataModel(),AddressDataModel()])
    }
}


//MARK:- TableView Delegate
extension AddressMainVC : UITableViewDelegate{
}

extension AddressMainVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addressList.count < 2{
            return 2
        }
        return addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressButtonCell.identifier) as? AddressButtonCell else { return UITableViewCell()}
        
        cell.delegate = self

        switch indexPath.row {
        case 0:
            cell.setInitContentText(text: "출발지", isAddress: false)
        case (addressList.count - 1):
            cell.setInitContentText(text: "도착지", isAddress: false)
        default:
            cell.setInitContentText(text: "경유지", isAddress: false)
        }
        
        return cell
    }
}

extension AddressMainVC: AddressButtonCellDelegate{
    func addressButtonCellForRemoving(cell: AddressButtonCell) {
        let index = cell.getTableCellIndexPath()
        print("\(index)")
        addressList.remove(at: index)
        tableView.reloadData()
        
        tableViewHeight = calculateTableViewHeight()
        tableView.snp.updateConstraints{ make in
            make.height.equalTo(tableViewHeight)
        }
    }
    
    func addressButtonCellForAdding(cell: AddressButtonCell) {
        let index = addressList.endIndex - 2
        addressList.insert(cell.address, at: index)
        tableView.reloadData()
        
        tableViewHeight = calculateTableViewHeight()
        tableView.snp.updateConstraints{ make in
            make.height.equalTo(tableViewHeight)
        }
    }
    
    func addressButtonCellForPreseting(cell: AddressButtonCell) {
        
        let storyboard = UIStoryboard(name: "SearchKeyword", bundle: nil)
        guard let nextVC =  storyboard.instantiateViewController(identifier: SearchKeywordVC.identifier) as? SearchKeywordVC else {
            return
        }
        let index = cell.getTableCellIndexPath()
        
        nextVC.setAddressModel(model: addressList[index], text: "\(cell.cellType)를 입력해주세요")
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
}
