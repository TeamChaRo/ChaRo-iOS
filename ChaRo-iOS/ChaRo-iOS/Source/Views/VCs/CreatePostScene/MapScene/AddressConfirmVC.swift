//
//  AddreeConfirmVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/08.
//

import UIKit
import SnapKit
import Then
import TMapSDK

final class AddressConfirmVC: UIViewController {

    private var addressModel: AddressDataModel?
    private var tMapView = MapService.getTmapView()
    private var deviceHeight: CGFloat?
    public var searchType: String = ""
    public var presentingCellIndex: Int = -1
    private var isFirstLoaded: Bool = true
    
    private var backButton = UIButton().then {
        $0.setBackgroundImage(ImageLiterals.icCircleBack, for: .normal)
        $0.addTarget(self, action: #selector(popCurrentView), for: .touchUpInside)
    }
    
    private var centerMarkerView = UIImageView()
    private var bottomView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    private var confirmButton = UIButton().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .mainBlue
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(sendDecidedAddress), for: .touchUpInside)
    }
    
    private var titleNameLabel = UILabel().then {
        $0.font = .notoSansMediumFont(ofSize: 16)
        $0.textColor = .gray50
    }
    
    private var addressLabel = UILabel().then {
        $0.font = .notoSansRegularFont(ofSize: 14)
        $0.textColor = .gray40
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setContraints()
        initTMapView()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    @objc func popCurrentView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendDecidedAddress() {
        let endIndex = Int(navigationController?.viewControllers.endIndex ?? 0)
        guard let addressMainVC = navigationController?.viewControllers[endIndex-3] as? AddressMainVC else { return }
        addressMainVC.replaceAddressData(address: addressModel ?? AddressDataModel(),
                                         index: presentingCellIndex)
        navigationController?.popToViewController(addressMainVC, animated: true)
    }
    
    func setPresentingAddress(address: AddressDataModel) {
        setTMapInitAddressView(address: address)
        setAddressLabels(address: address)
    }
    
    func setSearchType(type: String, index: Int) {
        confirmButton.setTitle("\(type)로 설정", for: .normal)
        presentingCellIndex = index
        setImageInCenterMarkerView(type: type)
    }
    
    func setAddressLabels(address: AddressDataModel) {
        addressModel = address
        changeAddressText()
        print("first = \(address.title), \(address.address)")
    }
    
    func setImageInCenterMarkerView(type: String) {
        var image = UIImage()
        switch type {
        case "출발지":
            image = UIImage(named: "icMapStart")!
        case "도착지":
            image = UIImage(named: "icMapEnd")!
        default:
            image = UIImage(named: "icMapWaypoint")!
        }
        centerMarkerView = UIImageView(image: image)
    }
    
    
    func changeAddressText() {
        titleNameLabel.text = addressModel!.title
        addressLabel.text = addressModel!.address
    }
    
    func setTMapInitAddressView(address: AddressDataModel) {
        let initPosition: CLLocationCoordinate2D = address.getPoint()
        tMapView.setCenter(initPosition)
        tMapView.setZoom(18)
    }
    
    func setContraints() {
        view.addSubviews([tMapView,
                          backButton,
                          centerMarkerView,
                          bottomView])
        
        let height = UIScreen.main.bounds.height
        print("deviceHeight = \(height)")
        let viewRate = height / 812
        let bottomViewHeight = 172 * viewRate
        print("viewRate = \(viewRate)")
        
        let mapFrameHeight = height - bottomViewHeight - CGFloat(UIScreen.getIndecatorHeight()) + 30
        
        tMapView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: mapFrameHeight)
        tMapView.snp.makeConstraints{
            $0.top.equalTo(view.snp.top)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        backButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
        }
    
        centerMarkerView.snp.makeConstraints{
            $0.center.equalTo(tMapView.snp.center)
        }
        
        bottomView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(bottomViewHeight)
        }
        
        
        bottomView.addSubviews([ confirmButton,
                                 addressLabel,
                                 titleNameLabel])
       
        confirmButton.snp.makeConstraints{
            $0.leading.equalTo(bottomView.snp.leading).offset(20)
            $0.trailing.equalTo(bottomView.snp.trailing).offset(-20)
            $0.bottom.equalTo(bottomView.snp.bottom).offset(-23)
            $0.height.equalTo(48 * viewRate)
        }
        
        addressLabel.snp.makeConstraints{
            $0.leading.equalTo(bottomView.snp.leading).offset(20)
            $0.trailing.equalTo(bottomView.snp.trailing).offset(-20)
            $0.bottom.equalTo(confirmButton.snp.top).offset(-27)
        }
        
        titleNameLabel.snp.makeConstraints{
            $0.leading.equalTo(bottomView.snp.leading).offset(20)
            $0.trailing.equalTo(bottomView.snp.trailing).offset(-20)
            $0.bottom.equalTo(addressLabel.snp.top).offset(-2)
        }

    }
    
    private func changeCoodinateToAddress(point : CLLocationCoordinate2D) {
        let pathData = TMapPathData()
        
        pathData.reverseGeocoding(point, addressType: "A04") { result , error in
            let addressDict = result ?? [:]
            print(addressDict)
            print(addressDict["newRoadName"])
            
            var newTitle = ""
            
            if let tmp = addressDict["roadName"] as? String {
                newTitle = tmp != "" ? tmp : ""
            }
            
            if let tmp = addressDict["buildingName"] as? String {
                newTitle = tmp != "" ? tmp : ""
            }
            
            let newAddress = AddressDataModel(title: String(point.latitude),
                                              address: String(point.longitude),
                                              latitude: addressDict["fullAddress"] as! String,
                                              longitude: newTitle)
            
            DispatchQueue.main.async {
                self.setAddressLabels(address: newAddress)
            }
        }
        
    }

    private func getCenterCoordinateInCurrentMap() {
        let lat: Double = (tMapView.getCenter()?.latitude)!
        let lon: Double = (tMapView.getCenter()?.longitude)!
        
        print("----------------------------")
        print("lat:\(lat) \n lon:\(lon)")
        print("----------------------------")
    }
    
    private func clickedToAddMarker() {
        let position = tMapView.getCenter()
        let marker = TMapMarker(position: position!)
        marker.map = tMapView
    }
  
    
}

extension AddressConfirmVC: TMapViewDelegate {
    func initTMapView() {
        tMapView.setApiKey(MapService.mapkey)
        tMapView.delegate = self
    }
    func mapViewDidChangeBounds() {
        if !isFirstLoaded {
            changeCoodinateToAddress(point: tMapView.getCenter()!)
        }
        isFirstLoaded  = isFirstLoaded ? false : isFirstLoaded
        getCenterCoordinateInCurrentMap()
        //clickedToAddMarker()
        
    }
}

