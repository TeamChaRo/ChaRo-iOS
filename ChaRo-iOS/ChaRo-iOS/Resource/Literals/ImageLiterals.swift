//
//  ImageLiterals.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/02/22.
//

import UIKit

enum ImageLiterals {
    //MARK: - icon
    static var icHeartActive: UIImage{ .load(name: "icHeartActive")}
    static var icHeartInactive: UIImage{ .load(name: "bigheartInactive")}
    static var icHeartWhiteLine: UIImage{ .load(name: "icHeartWhiteLine")}
    
    static var icScrapActive: UIImage{ .load(name: "icSaveActive")}
    static var icScrapInactive: UIImage{ .load(name: "bigsaveInactive") }
    static var icShare: UIImage{ .load(name: "icShare") }
    static var icBack: UIImage{ .load(name: "backIcon") }
    static var icBackWhite: UIImage{ .load(name: "backIconWhite") }
    static var icBackGray: UIImage{ .load(name: "icGrayBackButton") }
    
    static var icAlarmWhite: UIImage{ .load(name: "icAlarmWhite") }
    static var icAlarmBlack: UIImage{ .load(name: "iconAlarmBlack") }
    
    static var icCamera: UIImage{ .load(name: "icCamera") }
    static var icCloseWhite: UIImage{ .load(name: "icCloseWhite") }
    static var icDown: UIImage{ .load(name: "icDown") }
    static var icEyeOff: UIImage{ .load(name: "icEyeOff") }
    static var icEyeOn: UIImage{ .load(name: "icEyeOn") }
    
    //MARK: About Address
    static var icMapEnd: UIImage{ .load(name: "icMapEnd") }
    static var icMapStart: UIImage{ .load(name: "icMapStart") }
    static var icMapWaypoint: UIImage{ .load(name: "icMapWaypoint") }
    static var icRouteEnd: UIImage{ .load(name: "icRouteEnd") }
    static var icRouteStart: UIImage{ .load(name: "icRouteStart") }
    static var icRouteWaypoint: UIImage{ .load(name: "icRouteWaypoint") }
    static var icWaypointMinusActive: UIImage{ .load(name: "icWaypointMinusActive") }
    static var icWayPointPlusActive: UIImage{ .load(name: "icWayPointPlusActive") }
    static var icWayPointPlusInactive: UIImage{ .load(name: "icWayPointPlusInactive") }
    
    static var icCircleBack: UIImage{ .load(name: "iconCircleBackButton") }
    
    static var icSearchBlack: UIImage{ .load(name: "iconSearchBlack") }
    static var icSearchWhite: UIImage{ .load(name: "icSearchWhite") }
    static var icProfile: UIImage{ .load(name: "icProfile") }
    
    static var icSaveActive: UIImage{ .load(name: "icSaveActive") }
    static var icSaveInactive: UIImage{ .load(name: "icSaveInactive") }
    
    //TODO: 위에 두개 중 안쓰는 거 한쪽은 삭제하기
    static var icSave_Active: UIImage{ .load(name: "save_active") }
    static var icSave_Inactive: UIImage{ .load(name: "save_inactive") }
    
    static var icSignupAgreeBig: UIImage{ .load(name: "icSignupAgreeBig") }
    static var icSignupAgreeSmall: UIImage{ .load(name: "icSignupAgreeSmall") }
    static var icSignupDisagreeBig: UIImage{ .load(name: "icSignupDisagreeBig") }
    static var icSignupDisagreeSmall: UIImage{ .load(name: "icSignupDisagreeSmall") }
    
    static var icLoginFieldBackground: UIImage{ .load(name: "idBackgroud") }
    
    static var icClose: UIImage{ .load(name: "close") }
    static var icCopy: UIImage{ .load(name: "copyIcon") }
    static var icFollowButtonWhite: UIImage{ .load(name: "followButtonWhite") }
    static var icFollowButtonGray: UIImage{ .load(name: "FollowButtonGray") }
    static var icfollowingButton: UIImage{ .load(name: "followingButton") }
    static var icfollowingButtonImage: UIImage{ .load(name: "followingButtonImage") }
    
    static var icHeartCountNoText: UIImage{ .load(name: "heart_count_no text") }
    
    static var icAppleLogo: UIImage{ .load(name: "appleLogo") }
    static var icGoogleLogo: UIImage{ .load(name: "googleLogo") }
    static var icKakaoLogo: UIImage{ .load(name: "kakaoLogo") }
    static var icCharoLogo: UIImage{ .load(name: "charoLogo") }
    static var icCharoLogoWhite: UIImage{ .load(name: "charoLogoWhite") }
    
    static var icDelete: UIImage{ .load(name: "imgDelete36px") }
    
    //MARK: post search
    static var icSearchBtnBlue: UIImage{ .load(name: "searchBtnBlue") }
    static var icsearchBtnSelect: UIImage{ .load(name: "searchBtnSelect") }
    static var icSearchBtnUnselect: UIImage{ .load(name: "searchBtnUnselect") }
    static var icSearchBtnWhite: UIImage{ .load(name: "searchBtnWhite") }
    
    static var icThemeSelected: UIImage{ .load(name: "select") }
    static var icselectboxShow: UIImage{ .load(name: "selectbox_show") }
    static var icSettingWhite: UIImage{ .load(name: "setting_white") }
    
    //MARK: Tabbar
    static var icTabbarHomeActive: UIImage{ .load(name: "tabbarIcHomeActive") }
    static var icTabbarHomeInactive: UIImage{ .load(name: "tabbarIcHomeInactive") }
    static var icTabbarMypageActive: UIImage{ .load(name: "tabbarIcMypageActive") }
    static var icTabbarMypageInActive: UIImage{ .load(name: "tabbarIcMypageInactive") }
    static var icTabbarPostWrite: UIImage{ .load(name: "tabbarIcPostWrite") }
    
    
    static var icViewSelectboxParkingNo: UIImage{ .load(name: "uiViewSelectboxParkingNo") }
    static var icViewSelectboxParkingYes: UIImage{ .load(name: "uiViewSelectboxParkingYes") }
    static var icViewTextfieldParkingShow: UIImage{ .load(name: "uiViewTextfieldParkingShow") }
    static var icUnselect: UIImage{ .load(name: "unselect") }
    
    static var icWriteActive: UIImage{ .load(name: "write_active") }
    static var icWriteInactive: UIImage{ .load(name: "write_inactive") }
    
    
    //MARK: - image
    static var imgBlueCar: UIImage{ .load(name: "blueCar") }
    static var imgBlueCarLine: UIImage{ .load(name: "blueCarLine") }
    static var imgPlaceholder: UIImage{ .load(name: "imagePlaceholder") }
    static var imgCharoCar: UIImage{ .load(name: "charoCar") }
    static var imgMyImage: UIImage{ .load(name: "myimage") }
    static var imgOnBoarding1: UIImage{ .load(name: "onboardingBackground1") }
    static var imgOnBoarding2: UIImage{ .load(name: "onboardingBackground2") }
    static var imgOnBoarding3: UIImage{ .load(name: "onboardingBackground3") }
    static var imgPostTextfieldLocationShow: UIImage{ .load(name: "postTextfieldLocationShow") }
    static var imgSearchBackground: UIImage{ .load(name: "searchBackground") }
    static var imgSearchBackgroundWhite: UIImage{ .load(name: "searchBackgroundWhite") }
    static var imgSearchNoImage: UIImage{ .load(name: "searchNoImage") }
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = name
        return image
    }
    
    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}