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
    public var addressCellList : [AddressButtonCell] = []
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
        addressCellList.append(contentsOf: [initAddressCell(text: "출발지"),
                                            initAddressCell(text: "도착지")])
        
    }
    
    private func initAddressCell(text: String) -> AddressButtonCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressButtonCell.identifier) as? AddressButtonCell else { return AddressButtonCell()}
        cell.delegate = self
        cell.setInitContentText(text: text)
        return cell
    }
}


//MARK:- TableView Delegate
extension AddressMainVC : UITableViewDelegate{
}

extension AddressMainVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressCellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressButtonCell.identifier) as? AddressButtonCell else { return UITableViewCell()}
//
//        cell.delegate = self
//
//        switch indexPath.row {
//        case 0:
//            cell.setInitContentText(text: "출발지")
//        case (addressList.count - 1):
//            cell.setInitContentText(text: "도착지")
//        default:
//            cell.setInitContentText(text: "경유지")
//        }
        
        
        
        return addressCellList[indexPath.row]
    }
}

extension AddressMainVC: AddressButtonCellDelegate{
    func addressButtonCellForRemoving(cell: AddressButtonCell) {
        let index = cell.getTableCellIndexPath()
        addressList.remove(at: index)
        addressCellList.remove(at: index)
        tableView.reloadData()
        
        tableViewHeight = calculateTableViewHeight()
        tableView.snp.updateConstraints{ make in
            make.height.equalTo(tableViewHeight)
        }
    }
    
    func addressButtonCellForAdding(cell: AddressButtonCell) {
        let index = addressList.endIndex - 1
        addressList.insert(cell.address, at: index)
        addressCellList.insert(initAddressCell(text: "경유지"), at: index)
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
        
        nextVC.setAddressModel(model: addressList[index],
                               cellType: cell.cellType,
                               index: index)
        
        let navigationView = UINavigationController(rootViewController: nextVC)
        print(navigationView)
        navigationView.modalPresentationStyle = .fullScreen
        self.present( navigationView, animated: true, completion: nil)
    }
    
}
