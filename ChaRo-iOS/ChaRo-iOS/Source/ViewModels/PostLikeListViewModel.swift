//
//  PostLikeListViewModel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/02.
//

import RxSwift
import UIKit

class PostLikeListViewModel{
    private let disposeBag = DisposeBag()
    
    //MARK: - Properties
    let defaultHeight: CGFloat = UIScreen.getDeviceHeight() / 2
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.getDeviceHeight() - 200
    var currentContainerHeight: CGFloat = UIScreen.getDeviceHeight() / 2
    
    //MARK: - Input and Output
    struct Input{
        let transionYOffsetSubject = PublishSubject<(CGFloat, Bool)>()
    }
    
    struct Output{
        let newHeightSubject = PublishSubject<(CGFloat, Bool)>()
    }
    
    func transform(form input: Input) -> Output{
        let output = Output()
        
        input.transionYOffsetSubject
            .bind(onNext: { [weak self] (yOffset, isDragging) in
                guard let self = self else {return}
                print("----------isDragging = \(isDragging)")
                output.newHeightSubject.onNext((self.calculateHeight(yOffset: yOffset, isDragging: !isDragging),
                                                isDragging))
            })
            .disposed(by: self.disposeBag)
        return output
    }
    
    private func calculateHeight(yOffset: CGFloat, isDragging: Bool) -> CGFloat{
        let isDraggingDown = yOffset > 0
        let newHeight = self.currentContainerHeight - yOffset
        
        print("newHeight = \(newHeight), 현재 드래그 \(isDraggingDown ? "내려가는 중" : "올라가는 중")")
        if isDragging{
            return newHeight
        }
        
        if newHeight < self.dismissibleHeight{
            return self.defaultHeight
        }else if newHeight < self.defaultHeight {
            return self.defaultHeight
        }else if newHeight < self.maximumContainerHeight && isDraggingDown{
            return self.defaultHeight
        }else if newHeight > self.defaultHeight && !isDraggingDown{
            print("여기에 걸여야 하는거 아니야?")
            return self.maximumContainerHeight
        }
        print("여기중에 안걸리는 경우가 있나?")
        return -1
    }
}
