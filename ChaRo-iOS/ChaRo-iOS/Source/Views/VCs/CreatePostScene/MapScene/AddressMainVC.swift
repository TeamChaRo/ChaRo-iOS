//
//  AddressSearchVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/06.
//

import UIKit
import SnapKit
import Then
import TMapSDK

class AddressMainVC: UIViewController {

    public var addressList: [AddressDataModel] = []
    public var searchHistory: [KeywordResult] = []
    public var newSearchHistory: [KeywordResult] = []
    public var addressCellList: [AddressButtonCell] = []
    
    private var isFirstFinded: Bool = true
    private var sendedPostData: WritePostData?
    private var imageList: [UIImage] = []
    private let animator = UIViewPropertyAnimator(duration: 7, curve: .easeInOut)
    
    private lazy var tableView = UITableView().then {
        $0.register(cell: AddressButtonCell.self)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
    }
    private var oneCellHeight: CGFloat = 48
    private var tableViewHeight: CGFloat  = 96
    private var tableViewBottomOffset: CGFloat  = 19
    private var isFirstOpen: Bool = true
    
    //MARK: - About Map
    private let tMapView = TMapView()
    private var markerList: [TMapMarker] = []
    private var polyLineList: [TMapPolyline] = []
    
    //MARK: UI Component
    private let backButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "icGrayBackButton"), for: .normal)
        $0.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    private var confirmButton = UIButton().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .mainBlue
        $0.setTitleColor(.white, for: .normal)
        $0.isHidden = true
        $0.setTitle("작성완료", for: .normal)
        $0.addTarget(self, action: #selector(sendDecidedAddress), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getSearchKeywords()
        setConstraints()
        configureCells()
        initMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayAddress()
        setMapFrame()
        inputMarkerInMapView()
        isThereStartAddress()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupGuideAnimationView()
    }
    
    private func configureCells(){
        isFirstFinded ? initAddressList() : setRecivedAddressCell()
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
    
    private func configureUI(){
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        oneCellHeight = 48.0
        tableViewBottomOffset = 19
        tableViewHeight = (oneCellHeight * 2) + tableViewBottomOffset
    }
    
    
    @objc private func dismissView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func sendDecidedAddress(){
        let newAddressList = changeAddressData()
        let nextVC = PostDetailVC()
        postSearchKeywords()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func changeAddressData() -> [Address]{
        print("현재까지 주소 - \(addressList)")
        var castedToAddressDatalList : [Address] = []
        addressList.forEach{
            castedToAddressDatalList.append($0.getAddressDataModel())
        }
        return castedToAddressDatalList
    }
}

// MARK: - Guide Animation
extension AddressMainVC{
    private func setupGuideAnimationView(){
        guard isFirstOpen else { return }
        let guideView = MapGuideView()
        self.view.addSubview(guideView)
        guideView.snp.makeConstraints{
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        animator.addAnimations {
            guideView.alpha = 0
        }
        animator.addCompletion { _ in
            guideView.removeFromSuperview()
        }
        animator.startAnimation()
        isFirstOpen = false
    }
}


//MARK: - Address 관련
extension AddressMainVC {
    private func initAddressList(){
        addressList.append(contentsOf: [AddressDataModel(),AddressDataModel()])
        addressCellList.append(contentsOf: [initAddressCell(type: .start),
                                            initAddressCell(type: .end)])
    }
    
    private func setRecivedAddressCell(){
        addressCellList = []
        addressList.forEach{
            let addressCell = setRecivedAddressCellStyle(address: $0)
            addressCellList.append(addressCell)
        }
    }
    
    private func initAddressCell(type: AddressButtonCell.AddressCellType) -> AddressButtonCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressButtonCell.className) as? AddressButtonCell else {return AddressButtonCell()}
        cell.delegate = self
        cell.setInitContent(of: type)
        return cell
    }
    
    private func setRecivedAddressCellStyle(address: AddressDataModel) -> AddressButtonCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressButtonCell.className) as? AddressButtonCell else { return AddressButtonCell()}
        cell.delegate = self
        cell.setAddressText(address: address)
        return cell
    }
    
    public func setWritePostDataForServer(data: WritePostData, imageList: [UIImage]){
        sendedPostData = data
        self.imageList = imageList
        dump(imageList)
    }
    
    public func setAddressListData(list: [AddressDataModel]){
        isFirstFinded = list.count == 0 ? true : false
        addressList = list
    }
    
    public func replaceAddressData(address: AddressDataModel, index: Int){
        addressList[index] = address
        addressCellList[index].setAddressText(address: address)
        
        if index == 0 {
            addressCellList[1].searchButton.isEnabled = true
            addressCellList[1].searchButton.isUserInteractionEnabled = true
        }
        
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


// MARK: - TableView Delegate
extension AddressMainVC : UITableViewDelegate{
    private func calculateTableViewHeight() -> CGFloat{
        return CGFloat(addressList.count) * oneCellHeight + tableViewBottomOffset
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return oneCellHeight
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
        addressCellList.insert(initAddressCell(type: .mid), at: index)
        
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
        let nextVC = SearchAddressKeywordVC()
        let index = cell.getTableCellIndexPath()
        nextVC.setAddressModel(model: addressList[index],
                               cellType: cell.cellType.rawValue,
                               index: index)
        nextVC.setSearchKeyword(list: newSearchHistory+searchHistory)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

//MARK: - TMap
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
    
    private func removeAllPolyLines(){
        for line in polyLineList{
            line.map = nil
        }
        polyLineList.removeAll()
    }
    
    private func addPathInMapView(){
        removeAllPolyLines()
        let pathData = TMapPathData()
        print("count = \(addressList.count)")
        
        for index in 0..<addressList.count-1{
            if addressList[index+1].title == "" {
                return
            }
            print("index = \(index)")
            pathData.findPathData(startPoint: addressList[index].getPoint(),
                                  endPoint: addressList[index+1].getPoint()) { result, error in
                guard let polyLine = result else { return }
                
                print(" start = \(self.addressList[index]), \(self.addressList[index].title)")
                print(" end = \(self.addressList[index+1]),\(self.addressList[index+1].title) ")
                
                print("경로 들어감")
                self.polyLineList.append(polyLine)
                polyLine.strokeColor = .mainBlue
                DispatchQueue.main.async {
                    polyLine.map = self.tMapView
                }
                
                if index == self.addressList.count-2{
                    
                    print("경로 그려져야함!!!!! = \(index)")
                    DispatchQueue.main.async {
                        self.tMapView.fitMapBoundsWithPolylines(self.polyLineList)
                        print("befor = \(self.tMapView.getCenter())")
                        //self.tMapView.setCenter(self.getOptimizationCenter())
                        //self.tMapView.setZoom(self.tMapView.getZoom()! - 1)
                    }
                }
            }
        }
    }
    
    
//    private func addPathInMapView(){
//        polyLineList.removeAll()
//        let pathData = TMapPathData()
//        print("count = \(addressList.count)")
//        for index in 0..<addressList.count-1{
//            print("index = \(index)")
//            pathData.findPathData(startPoint: addressList[index].getPoint(),
//                                  endPoint: addressList[index+1].getPoint()) { result, error in
//                guard let polyLine = result else { return }
//                self.polyLineList.append(polyLine)
//
//                if index == self.addressList.count-2{
//                    DispatchQueue.main.async {
//                        polyLine.strokeColor = .mainBlue
//                        polyLine.map = self.tMapView
//                        self.tMapView.fitMapBoundsWithPolylines(self.polyLineList)
//                        print("befor = \(self.tMapView.getCenter())")
//                        self.tMapView.setCenter(self.getOptimizationCenter())
//                        self.tMapView.setZoom(self.tMapView.getZoom()! - 1)
//                    }
//                }
//            }
//        }
//    }
    
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

//MARK: Network
extension AddressMainVC{
    private func getSearchKeywords(){
        print("getSearchKeywords")
        SearchKeywordService.shared.getSearchKeywords(userId: Constants.userId){response in
            
            switch(response){
            case .success(let resultData):
                if let data =  resultData as? SearchResultDataModel{
                    print("내가 검색한 결과 조회~~~!!")
                    self.searchHistory = data.data!
                    dump(self.searchHistory)
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
    
    
    private func postSearchKeywords(){
        print("postSearchKeywords-----------------")
        var searchKeywordList: [SearchHistory] = []
        
        for item in newSearchHistory{
            let address = SearchHistory(title: item.title,
                                        address: item.address,
                                        latitude: item.latitude,
                                        longitude: item.longitude)
            searchKeywordList.append(address)
        }
        
        SearchKeywordService.shared.postSearchKeywords(userId: Constants.userId,
                                                       keywords: searchKeywordList){ [self] response in
            print("결과받음")
            
            switch(response){
            case .success(let resultData):
                if let data =  resultData as? SearchResultDataModel{
                    print("성공했더~!!!!")
                    dump(data)
                    print("성공했더~!!!!")
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
        tMapView.setZoom(12)
        print("tMapView.getZoom() = \(tMapView.getZoom())")
    }
    
    func mapView(_ mapView: TMapView, shouldChangeFrom oldPosition: CLLocationCoordinate2D,
                 to newPosition: CLLocationCoordinate2D) -> Bool {
        return true
    }
    
}



