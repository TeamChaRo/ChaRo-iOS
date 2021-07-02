//
//  MapService.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/02.
//

import Foundation
import TMapSDK

class MapService {
    static let mapkey = "l7xx26b9b12c901741d1b952cc7d8b65c3b0"
    static let serverURL = ""
    static public var mapView: TMapView?
    static var isAuthorized = false
    
    static public func getTmapView() -> TMapView{
        if !isAuthorized{
            initTMapView()
            isAuthorized = true
        }
        return mapView!
    }
    
    static public func initTMapView(){
        mapView = TMapView(frame: .init(x: 0, y: 0, width: 100, height: 5))
        mapView?.setApiKey(MapService.mapkey)
    }
}
