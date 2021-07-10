//
//  AddressDateModel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/06.
//

import UIKit
import TMapSDK

struct AddressDataModel {
    var latitude = 0.0
    var longtitude = 0.0
    var address = ""
    var title = ""
    
    
    func displayContent(){
        print("title = \(title)")
        print("address = \(address)")
        print("latitude = \(latitude)")
        print("longtitude = \(longtitude)")
    }
    
    func getPoint() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
    
}
