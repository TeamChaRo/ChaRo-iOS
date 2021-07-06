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
    private var tableViewHeight = 88
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        initAddressList()
    }
    

    private func configureTableView(){
        setTableViewConstraints()
        tableView.registerCustomXib(xibName: AddressButtonCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setTableViewConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints{make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(tableViewHeight)
        }
    }
    
    private func calculateTableViewHeight() -> Int{
        return addressList.count * 44
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
        print("addressButtonCellForRemoving")
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
        print("addressButtonCellForAdding")
        let index = addressList.endIndex - 2
        addressList.insert(cell.address, at: index)
        tableView.reloadData()
        
        tableViewHeight = calculateTableViewHeight()
        tableView.snp.updateConstraints{ make in
            make.height.equalTo(tableViewHeight)
        }
    }
    
    
}
