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
    //private var courseList : [AddressDataModel] = []
    private var courseList : [Course] = []
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
    
    
//    public func setcourseList(list: [AddressDataModel], height: CGFloat){
//        courseList = list
//        tMapView.delegate = self
//        tMapView.setApiKey(MapService.mapkey)
//        viewHeight = height
//
//    }
    
    public func setcourseList(list: [Course], height: CGFloat){
        courseList = list
        tMapView.delegate = self
        tMapView.setApiKey(MapService.mapkey)
        viewHeight = height
    }
    
    private func addPathInMapView(){
        let pathData = TMapPathData()
        print("count = \(courseList.count)")
        for index in 0..<courseList.count-1{
            print("index = \(index)")
            pathData.findPathData(startPoint: courseList[index].getPoint(),
                                  endPoint: courseList[index+1].getPoint()) { result, error in
                guard let polyLine = result else {return}
                
                print(" start = \(self.courseList[index])")
                print(" end = \(self.courseList[index+1])")
                
                print("경로 들어감")
                self.polyLineList.append(polyLine)
                polyLine.strokeColor = .mainBlue
                DispatchQueue.main.async {
                    polyLine.map = self.tMapView
                }
                
                if index == self.courseList.count-2{
                    
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
    
    private func addMarkerInMapView(){
        for index in 0..<courseList.count {
            let marker = TMapMarker(position: courseList[index].getPoint())
            
            if index == 0 {
                marker.icon = UIImage(named: "icRouteStart")
            }else if index == courseList.count - 1{
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
        
        addSubview(tMapView)
        tMapView.layer.cornerRadius = 30
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
        dump(courseList)
        let mapWidth: CGFloat = UIScreen.getDeviceWidth() - 40
        let mapHeight: CGFloat = viewHeight - 40
        tMapView.frame = CGRect(x: 0, y: 0, width: mapWidth, height: mapHeight)
        addPathInMapView()
        addMarkerInMapView()
    }
}

