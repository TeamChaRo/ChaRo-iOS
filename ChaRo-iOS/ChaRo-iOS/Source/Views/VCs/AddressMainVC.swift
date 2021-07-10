//
//  AddressSearchVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/06.
//

import UIKit
import SnapKit
import TMapSDK

class AddressMainVC: UIViewController {

    static let identifier = "AddressMainVC"
    public var addressList: [AddressDataModel] = []
    public var addressCellList: [AddressButtonCell] = []
    private var tableView = UITableView()
    //private let tMapView = MapService.getTmapView()
    private let tMapView = TMapView()
    private var isFirstFinded = true
    
    private var oneCellHeight = 48
    private var tableViewHeight = 96
    private var tableViewBottomOffset = 19
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icGrayBackButton"), for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setConstraints()
        configureCells()
        initTMapView()
        initMapViewStyle()
        tMapView.delegate = self
        navigationController?.isNavigationBarHidden = true
        
        print("view did load = \(tMapView.frame)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayAddress()
        
        tMapView.frame = CGRect(x: 0, y: tableViewHeight,
                                width: UIScreen.getDeviceWidth(),
                                height: UIScreen.getDeviceHeight() - tableViewHeight)
        print("view will apprear = \(tMapView.frame)")
    }
    
    

    private func configureTableView(){
        tableView.registerCustomXib(xibName: AddressButtonCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        oneCellHeight = 48
        tableViewBottomOffset = 19
        tableViewHeight = (oneCellHeight * 2) + tableViewBottomOffset
        print("tableViewHeight = \(tableViewHeight)")
    }
    
    
    private func configureCells(){
        if isFirstFinded{
            initAddressList()
        }else{
            setRecivedAddressCell()
        }
    }
    

    private func setConstraints(){
        view.addSubviews([backButton,
                          tableView,
                          tMapView])
        
        
        backButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-29)
            $0.height.equalTo(tableViewHeight)
        }
        
        tMapView.frame = CGRect(x: 0, y: 0,
                                width: UIScreen.getDeviceWidth(),
                                height: UIScreen.getDeviceHeight() - tableViewHeight)
        
        tMapView.snp.makeConstraints{
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        print("tMapView.getZoom() = \(tMapView.getZoom())")
    }
    
  
    
    private func initAddressList(){
        addressList.append(contentsOf: [AddressDataModel(),AddressDataModel()])
        addressCellList.append(contentsOf: [initAddressCell(text: "출발지"),
                                            initAddressCell(text: "도착지")])
    }
    
    private func setRecivedAddressCell(){
        addressCellList = []
        for item in addressList {
            let addressCell = setRecivedAddressCellStyle(address: item)
            addressCellList.append(addressCell)
        }
    }
    
    private func initAddressCell(text: String) -> AddressButtonCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressButtonCell.identifier) as? AddressButtonCell else {return AddressButtonCell()}
        cell.delegate = self
        cell.setInitContentText(text: text)
        return cell
    }
    
    private func setRecivedAddressCellStyle(address: AddressDataModel) -> AddressButtonCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressButtonCell.identifier) as? AddressButtonCell else { return AddressButtonCell()}
        cell.delegate = self
        cell.setAddressText(address: address)
        return cell
    }
    
    
    public func setAddressListData(list: [AddressDataModel]){
        isFirstFinded = list.count == 0 ? true : false
        addressList = list
    }
    
    @objc func dismissView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    public func replaceAddressData(address: AddressDataModel, index: Int){
        addressList[index] = address
        addressCellList[index].setAddressText(address: address)
    }
}


//MARK: - Address 관련
extension AddressMainVC {
    
    private func displayAddress(){
        print("addressList 개수 = \(addressList.count)")
        for item in addressList{
            item.displayContent()
        }
    }
}


//MARK:- TableView Delegate
extension AddressMainVC : UITableViewDelegate{
    
    private func calculateTableViewHeight() -> Int{
        return addressList.count * oneCellHeight + tableViewBottomOffset
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(oneCellHeight)
    }
    
}

extension AddressMainVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressCellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("\(addressCellList[indexPath.row].address)")
        print("\(addressCellList[indexPath.row].cellType)")
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
        
        tMapView.frame = CGRect(x: 0, y: tableViewHeight,
                                width: UIScreen.getDeviceWidth(),
                                height: UIScreen.getDeviceHeight() - tableViewHeight)
        
        tMapView.snp.updateConstraints{
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func addressButtonCellForAdding(cell: AddressButtonCell) {
        let index = addressList.endIndex - 1
        addressList.insert(cell.address, at: index)
        addressCellList.insert(initAddressCell(text: "경유지"), at: index)
        tableView.reloadData()
        
        tableViewHeight = calculateTableViewHeight()
        tableView.snp.updateConstraints{
            $0.height.equalTo(tableViewHeight)
        }
        
        tMapView.frame = CGRect(x: 0, y: tableViewHeight,
                                width: UIScreen.getDeviceWidth(),
                                height: UIScreen.getDeviceHeight() - tableViewHeight)
        
        
        tMapView.snp.updateConstraints{
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}


//MARK:- TMap
extension AddressMainVC : TMapViewDelegate{
    func mapViewDidFinishLoadingMap(){
        print("mapViewDidFinishLoadingMap")
        print("tMapView.getZoom() = \(tMapView.getZoom())")
        tMapView.setZoom(10)
    }
    private func initMapViewStyle(){
        print("initMapViewStyle")
        print("tMapView.getZoom() = \(tMapView.getZoom())")
        tMapView.setZoom(10)
    }
    
    private func initTMapView(){
        print("처음 인증받음")
        tMapView.setApiKey(MapService.mapkey)
    }
    
    func mapView(_ mapView: TMapView, shouldChangeFrom oldPosition: CLLocationCoordinate2D, to newPosition: CLLocationCoordinate2D) -> Bool {
        print("view update")
        return true
    }
    
}


