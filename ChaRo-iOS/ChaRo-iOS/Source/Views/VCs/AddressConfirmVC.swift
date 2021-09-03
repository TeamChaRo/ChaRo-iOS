//
//  AddreeConfirmVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/08.
//

import UIKit
import SnapKit
import TMapSDK


class AddressConfirmVC: UIViewController {

    static let identifier = "AddressConfirmVC"
    private var addressModel : AddressDataModel?
    private var tMapView = MapService.getTmapView()
    private var deviceHeight : CGFloat?
    public var searchType = ""
    public var presentingCellIndex = -1
    private var isFirstLoaded = true
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "iconCircleBackButton"), for: .normal)
        button.addTarget(self, action: #selector(popCurrentView), for: .touchUpInside)
        return button
    }()
    
    private var centerMarkerView = UIImageView()

    
    private var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        return view
    }()
    
    private var confirmButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = .mainBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(sendDecidedAddress), for: .touchUpInside)
        return button
    }()
    
    private var titleNameLabel : UILabel = {
        let label = UILabel()
        label.font = .notoSansMediumFont(ofSize: 16)
        label.textColor = .gray50
        return label
    }()
    
    private var addressLabel : UILabel = {
        let label = UILabel()
        label.font = .notoSansRegularFont(ofSize: 14)
        label.textColor = .gray40
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContraints()
        initTMapView()
    }
    
    @objc func popCurrentView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendDecidedAddress(){
        let endIndex = Int(navigationController?.viewControllers.endIndex ?? 0)
        let addressMainVC = navigationController?.viewControllers[endIndex-3] as! AddressMainVC
        addressMainVC.replaceAddressData(address: addressModel!, index: presentingCellIndex)
        navigationController?.popToViewController(addressMainVC, animated: true)
    }
    
    func setPresentingAddress(address: AddressDataModel){
        setTMapInitAddressView(address: address)
        setAddressLabels(address: address)
    }
    
    func setSearchType(type: String, index: Int){
        confirmButton.setTitle("\(type)로 설정", for: .normal)
        presentingCellIndex = index
        setImageInCenterMarkerView(type: type)
    }
    
    func setAddressLabels(address: AddressDataModel){
        addressModel = address
        changeAddressText()
        print("first = \(address.title), \(address.address)")
    }
    
    func setImageInCenterMarkerView(type: String){
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
    
    
    func changeAddressText(){
        titleNameLabel.text = addressModel!.title
        addressLabel.text = addressModel!.address
    }
    
    func setTMapInitAddressView(address: AddressDataModel){
        let initPosition: CLLocationCoordinate2D = address.getPoint()
        print("setTMapInitAddressView - tMapView.getZoom() = \(tMapView.getZoom())")
        tMapView.setCenter(initPosition)
        tMapView.setZoom(18)
    }
    
    
    func setContraints(){
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
    
    private func changeCoodinateToAddress(point : CLLocationCoordinate2D){
        let pathData = TMapPathData()
        
        pathData.reverseGeocoding(point, addressType: "A04"){ result , error in
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
            
            let newAddress = AddressDataModel(latitude: String(point.latitude),
                                              longitude: String(point.longitude),
                                              address: addressDict["fullAddress"] as! String,
                                              title: newTitle)
            
            DispatchQueue.main.async {
                self.setAddressLabels(address: newAddress)
            }
        }
        
    }

    private func getCenterCoordinateInCurrentMap(){
        let lat: Double = (tMapView.getCenter()?.latitude)!
        let lon: Double = (tMapView.getCenter()?.longitude)!
        
        print("----------------------------")
        print("lat:\(lat) \n lon:\(lon)")
        print("----------------------------")
    }
    
    private func clickedToAddMarker(){
        let position = tMapView.getCenter()
        let marker = TMapMarker(position: position!)
        marker.map = tMapView
    }
  
    
}

extension AddressConfirmVC: TMapViewDelegate{
    func initTMapView(){
        tMapView.setApiKey(MapService.mapkey)
        tMapView.delegate = self
    }
    func mapViewDidChangeBounds(){
        if !isFirstLoaded {
            changeCoodinateToAddress(point: tMapView.getCenter()!)
        }
        isFirstLoaded  = isFirstLoaded ? false : isFirstLoaded
        getCenterCoordinateInCurrentMap()
        //clickedToAddMarker()
        
    }
}

