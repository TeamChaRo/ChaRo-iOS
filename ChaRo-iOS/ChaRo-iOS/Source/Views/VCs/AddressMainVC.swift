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
   
    private var isFirstFinded = true
    
    private var oneCellHeight = 48
    private var tableViewHeight = 96
    private var tableViewBottomOffset = 19
    
    //MARK:- About Map
    private let tMapView = TMapView()
    private var markerList : [TMapMarker] = []
    private var polyLineList: [TMapPolyline] = []
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icGrayBackButton"), for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    private var confirmButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = .mainBlue
        button.setTitleColor(.white, for: .normal)
        button.isHidden = true
        button.setTitle("작성완료", for: .normal)
        button.addTarget(self, action: #selector(sendDecidedAddress), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setConstraints()
        configureCells()
        initMapView()
        navigationController?.isNavigationBarHidden = true
        print("view did load = \(tMapView.frame)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayAddress()
        setMapFrame()
        inputMarkerInMapView()
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
                          tMapView,
                          confirmButton])
        
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
        
        setMapFrame()
        
        tMapView.snp.makeConstraints{
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        confirmButton.snp.makeConstraints{
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
            $0.height.equalTo(48)
        }
    }
    
    
    @objc func dismissView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendDecidedAddress(){
        print("이렇게 해서 경로가 보여질꺼임")
    }
}


//MARK: - Address 관련
extension AddressMainVC {
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
    
    public func replaceAddressData(address: AddressDataModel, index: Int){
        addressList[index] = address
        addressCellList[index].setAddressText(address: address)
        if index == 1{
            confirmButton.isHidden = false
            addPathInMapView()
        }
    }
    private func displayAddress(){
        print("addressList 개수 = \(addressList.count)")
        for item in addressList{
            item.displayContent()
        }
    }
}


//MARK:- TableView Delegate
extension AddressMainVC : UITableViewDelegate{
    
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
        
        setMapFrame()
        
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
        
        setMapFrame()
        
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
extension AddressMainVC{
    private func initMapView(){
        tMapView.setApiKey(MapService.mapkey)
        tMapView.delegate = self
        tMapView.setZoom(10)
        initMapViewStyle()
    }
    
    private func setMapFrame(){
        tMapView.frame = CGRect(x: 0, y: tableViewHeight,
                                width: UIScreen.getDeviceWidth(),
                                height: UIScreen.getDeviceHeight() - tableViewHeight)
        
    }
    
    private func addPathInMapView(){
        polyLineList.removeAll()
        let pathData = TMapPathData()
        print("count = \(addressList.count)")
        for index in 0..<addressList.count-1{
            print("index = \(index)")
            pathData.findPathData(startPoint: addressList[index].getPoint(),
                                  endPoint: addressList[index+1].getPoint()) { result, error in
                guard let polyLine = result else {return}
                self.polyLineList.append(polyLine)
                
                if index == self.addressList.count-2{
                    DispatchQueue.main.async {
                        polyLine.map = self.tMapView
                        self.tMapView.fitMapBoundsWithPolylines(self.polyLineList)
//                        let zoomLevel = self.tMapView.getZoom()!
//                        print("zoomLevel = \(zoomLevel)")
//                        self.tMapView.setZoom(zoomLevel-1)
                    }
                }
            }
        }
    }
    
    private func initMapViewStyle(){
        print("initMapViewStyle")
        print("tMapView.getZoom() = \(tMapView.getZoom())")
    }
    
    private func inputMarkerInMapView(){
        print("inputMarkerInMapView")
        print("addressList = \(addressList.count)")
        for item in addressList{
            if item.title != ""{
                let point = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longtitude)
                let marker = TMapMarker(position: point)
                marker.map = tMapView
                markerList.append(marker)
                tMapView.setCenter(point)
            }
        }
    }
    
    
  
}

extension AddressMainVC : TMapViewDelegate{
    func mapViewDidFinishLoadingMap(){
        print("mapViewDidFinishLoadingMap")
        tMapView.setZoom(10)
        print("tMapView.getZoom() = \(tMapView.getZoom())")
    }

    
    func mapView(_ mapView: TMapView, shouldChangeFrom oldPosition: CLLocationCoordinate2D, to newPosition: CLLocationCoordinate2D) -> Bool {
        print("view update")
        return true
    }
    
}


