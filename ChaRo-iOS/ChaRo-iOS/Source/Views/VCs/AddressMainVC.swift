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
    
    private var isFirstFinded = true
    
    private var tableView = UITableView()
    private var oneCellHeight = 48
    private var tableViewHeight = 96
    private var tableViewBottomOffset = 19
    
    //MARK:- About Map
    //private let tMapView = MapService.getTmapView()
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
        isThereStartAddress()
    }
    
    private func configureCells(){
        if isFirstFinded{
            initAddressList()
        }else{
            setRecivedAddressCell()
        }
    }
    
    private func isThereStartAddress(){
        if addressList[0].title != ""{
            print("isThereStartAddress")
            addressCellList[1].searchButton.isEnabled = true
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
        
        postSearchKeywords()
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
                        polyLine.strokeColor = .mainBlue
                        polyLine.map = self.tMapView
                        self.tMapView.fitMapBoundsWithPolylines(self.polyLineList)
                        print("befor = \(self.tMapView.getCenter())")
                        self.tMapView.setCenter(self.getOptimizationCenter())
                        self.tMapView.setZoom(self.tMapView.getZoom()! - 1)
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
        for index in 0..<addressList.count{
            
            if addressList[index].title != ""{
                let point = addressList[index].getPoint()
                let marker = TMapMarker(position: point)
                marker.icon = setMarkerImage(index: index)
                marker.map = tMapView
                markerList.append(marker)
                tMapView.setCenter(point)
            }
        }
    }
    
    private func setMarkerImage(index: Int) -> UIImage{
        var image = UIImage()
        switch index {
        case 0:
            image = UIImage(named: "icRouteStart")!
        case addressList.count - 1:
        image = UIImage(named: "icRouteEnd")!
        default:
            image = UIImage(named: "icRouteWaypoint")!
        }
        return image
    }
    
    
    private func getOptimizationCenter() ->  CLLocationCoordinate2D{
        var minX, minY, maxX, maxY : Double
        print("addressList.endIndex = \(addressList.endIndex)")
        let point1 = addressList[0].getPoint()
        let point2 = addressList[addressList.endIndex-1].getPoint()
        
        if point1.latitude < point2.latitude {
            minX = point1.latitude
            maxX = point2.latitude
        }else{
            maxX = point1.latitude
            minX = point2.latitude
        }
        
        if point1.longitude < point2.longitude{
            minY = point1.longitude
            maxY = point2.longitude
        }else{
            maxY = point1.longitude
            minY = point2.longitude
        }
        
        
        for i in 1..<addressList.count{
            let point = addressList[i].getPoint()
            if point.latitude < minX{
                minX = point.latitude
            }else if point.latitude > maxX{
                maxX = point.latitude
            }
            
            if point.longitude < minY{
                minY = point.longitude
            }else if point.longitude > maxY{
                maxY = point.longitude
            }
        }
        
        
        return CLLocationCoordinate2D(latitude: (minX+maxX)/2, longitude: (minY+maxY)/2)
        
    }
    


}

extension AddressMainVC{
    private func postSearchKeywords(){
        print(addressList)
        var searchKeywordList: [SearchHistory] = []
        
        for item in addressList{
            let address = SearchHistory(title: item.title,
                                        address: item.address,
                                        latitude: item.latitude,
                                        longitude: item.longitude)
            searchKeywordList.append(address)
        }
        
        SearchKeywordService.shared.postSearchKeywords(userId: "111",
                                                       keywords: searchKeywordList){ response in
            print("받아올때 문제?")
            switch(response){
            
            case .success(let resultData):
                if let data =  resultData as? SearchPostResultDataModel{
                    dump(data)
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
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
        return true
    }
    
}



