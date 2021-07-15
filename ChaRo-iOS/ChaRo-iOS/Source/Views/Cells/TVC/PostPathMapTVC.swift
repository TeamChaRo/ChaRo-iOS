//
//  PostPathmapTCV.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/09.
//

import UIKit
import SnapKit
import TMapSDK

class PostPathmapTCV: UITableViewCell {

    static let identifier: String = "PostPathmapTCV"
    
   // let multiplier: CGFloat = 395/335
   // let mapWidth: CGFloat = UIScreen.main.bounds.width - 40
   
    //MARK: TMapView
    private let tMapView = TMapView()
    private var markerList : [TMapMarker] = []
    private var addressList : [AddressDataModel] = []
    private var polyLineList: [TMapPolyline] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setMapView()
        addPathInMapView()
        addMarkerInMapView()
        configureLayout()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
                        //print("befor = \(self.tMapView.getCenter())")
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
            markerList.append(marker)
            marker.map = tMapView
        }
    }
    
}

//MARK: - AutoLayout and functions
extension PostPathmapTCV {
    
    func configureLayout(){
        addSubview(tMapView)
        
        tMapView.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(20)
            $0.trailing.bottom.equalToSuperview().offset(-20)
//            $0.top.equalTo(self.snp.top).offset(23)
//            $0.centerX.equalTo(self.snp.centerX)
//            $0.bottom.equalTo(self.snp.bottom).inset(33)
           // $0.width.equalTo(mapWidth)
          //  $0.height.equalTo(self.postMap.snp.width).multipliedBy(multiplier)
        }
    }
    
    func setMapView(){
        tMapView.setApiKey(MapService.mapkey)
        //tMapView.isPanningEnable = false // 드래그 불가
        //tMapView.isZoomEnable = false // 확대축소 불가
    }
    
}

