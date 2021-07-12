//
//  AddressDateModel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/06.
//

import UIKit
import TMapSDK

struct AddressDataModel: Codable {
//    var latitude = 0.0
//    var longtitude = 0.0
    
    var latitude: String = ""
    var longitude: String = ""
    var address: String = ""
    var title: String = ""
    
    
    func displayContent(){
        print("title = \(title)")
        print("address = \(address)")
        print("latitude = \(latitude)")
        print("longtitude = \(longitude)")
    }
    
    func getPoint() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
    }
    
}
