//
//  PostPathmapTCV.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/09.
//

import UIKit
import SnapKit
import TMapSDK

class PostPathMapTVC: UITableViewCell {

    static let identifier: String = "PostPathMapTVC"
    
   // let multiplier: CGFloat = 395/335
   // let mapWidth: CGFloat = UIScreen.main.bounds.width - 40
   
    //MARK: TMapView
    private let tMapView = TMapView()
    private var markerList : [TMapMarker] = []
    private var addressList : [AddressDataModel] = []
    private var polyLineList: [TMapPolyline] = []
    private var viewHeight : CGFloat = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configureLayout()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    public func setAddressList(list: [AddressDataModel], height: CGFloat){
        addressList = list
        tMapView.delegate = self
        tMapView.setApiKey(MapService.mapkey)
        viewHeight = height
        
    }
    
    private func addPathInMapView(){
        let pathData = TMapPathData()
        print("count = \(addressList.count)")
        for index in 0..<addressList.count-1{
            print("index = \(index)")
            pathData.findPathData(startPoint: addressList[index].getPoint(),
                                  endPoint: addressList[index+1].getPoint()) { result, error in
                guard let polyLine = result else {return}
                
                print(" start = \(self.addressList[index])")
                print(" end = \(self.addressList[index+1])")
                
                print("경로 들어감")
                self.polyLineList.append(polyLine)
                polyLine.strokeColor = .mainBlue
                polyLine.map = self.tMapView
                
                if index == self.addressList.count-2{
                    print("경로 그려져야함!!!!! = \(index)")
                    DispatchQueue.main.async {
                        polyLine.strokeColor = .mainBlue
                        //polyLine.map = self.tMapView
                        self.tMapView.fitMapBoundsWithPolylines(self.polyLineList)
                        print("befor = \(self.tMapView.getCenter())")
                        //self.tMapView.setCenter(self.getOptimizationCenter())
                        //self.tMapView.setZoom(self.tMapView.getZoom()! - 1)
                    }
                }
            }
        }
    }
    
    private func addMarkerInMapView(){
        for index in 0..<addressList.count {
            let marker = TMapMarker(position: addressList[index].getPoint())
            
            if index == 0 {
                marker.icon = UIImage(named: "icRouteStart")
            }else if index == addressList.count - 1{
                marker.icon = UIImage(named: "icRouteEnd")
            }else{
                marker.icon = UIImage(named: "icRouteWaypoint")
            }
            
            marker.map = self.tMapView
            markerList.append(marker)
        }
    }
}

//MARK: - AutoLayout and functions
extension PostPathMapTVC {
    
    func configureLayout(){
        
        
        print(tMapView.frame)
        addSubview(tMapView)
        tMapView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(20)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).offset(-20)
            $0.bottom.equalTo(self.snp.bottom).offset(-20)
        }
    }
    
    func setMapView(){
        tMapView.setApiKey(MapService.mapkey)
        //tMapView.isPanningEnable = false // 드래그 불가
        //tMapView.isZoomEnable = false // 확대축소 불가
    }
    
}

extension PostPathMapTVC: TMapViewDelegate{
    func mapViewDidFinishLoadingMap() {
        print("befor = \(self.tMapView.getCenter())")
        print("mapViewDidFinishLoadingMap")
        dump(addressList)
        let mapWidth: CGFloat = UIScreen.getDeviceWidth() - 40
        let mapHeight: CGFloat = viewHeight - 40
        tMapView.frame = CGRect(x: 0, y: 0, width: mapWidth, height: mapHeight)
        addPathInMapView()
        addMarkerInMapView()
    }
}

