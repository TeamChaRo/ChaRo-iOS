//
//  ExpendedImageViewModel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/06/24.
//

import Foundation
import RxSwift

class ExpendedImageViewModel {
    
    private let dismissibleHeight: CGFloat = 300
    private let newHeightSubject = PublishSubject<CGFloat?>()
    
    struct Input {
        let scrolledOffsetSubject: PublishSubject<CGFloat>
    }
    
    struct Output {
        let newHeightSubject: PublishSubject<CGFloat?>
    }
    
    func transform(to input: Input, disposeBag: DisposeBag) -> Output {
        input.scrolledOffsetSubject.bind(onNext: { [weak self] yOffset in
            let newHeight = self?.calculateNewHeight(with: yOffset)
            self?.newHeightSubject.onNext(newHeight)
        }).disposed(by: disposeBag)
        return Output(newHeightSubject: newHeightSubject)
    }
    
    private func calculateNewHeight(with yOffset: CGFloat) -> CGFloat? {
        if yOffset > 0 {
            return yOffset > dismissibleHeight ? -1 : yOffset
        }
        return nil
    }
    
}
