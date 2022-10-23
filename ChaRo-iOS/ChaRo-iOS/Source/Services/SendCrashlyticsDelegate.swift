//
//  SendCrashlyticsDelegate.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/10/22.
//

import UIKit
import FirebaseCrashlytics

protocol SendCrashlyticsDelegate {
    func presentCrashAlert(at viewController: UIViewController)
}

extension SendCrashlyticsDelegate {
    func presentCrashAlert(at viewController: UIViewController) {
        let error = NSError(domain: "serverError", code: 500)
        viewController.makeAlert(title: "서버 연결 오류",
                                 message: "서버 연결에 오류가 발생했습니다.\n 다시 시도해주시길 바랍니다.",
                                 okAction: { _ in
            Crashlytics.crashlytics().record(error: error)
        })
    }
}
