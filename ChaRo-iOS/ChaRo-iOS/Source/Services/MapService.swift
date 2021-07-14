//
//  MapService.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/05.
//

import Foundation
import TMapSDK

class MapService {
    static let mapkey = "l7xx5198cd793c144a218cedb62cb8d653f7" //인정key
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
    
    static public func authorizeMapView(map: TMapView) ->TMapView{
        map.setApiKey(mapkey)
        return map
    }
}
