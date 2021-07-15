//
//  Notification.Name.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/13.
//

import Foundation

extension Notification.Name {
 
    static let createPostAddPhotoClicked = Notification.Name("createPostAddPhotoClicked")
    static let createPostDeletePhotoClicked = Notification.Name("createPostDeletePhotoClicked")
    static let callPhotoPicker = Notification.Name("callPhotoPicker")
    static let createPostPickerFieldClicked = Notification.Name("createPostPickerFieldClicked")
    
    static let sendNewPostTitle = Notification.Name("sendNewPostTitle")
    static let sendNewCity = Notification.Name("sendNewCity")
    static let sendNewRegion = Notification.Name("sendNewRegion")
    static let sendNewTheme = Notification.Name("sendNewTheme")
}

