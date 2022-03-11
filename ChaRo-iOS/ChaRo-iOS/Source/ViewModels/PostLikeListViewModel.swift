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
    let maximumContainerHeight: CGFloat = UIScreen.getDeviceHeight() - 64
    var currentContainerHeight: CGFloat = UIScreen.getDeviceHeight() / 2
    let maxBackgroundAlpha: CGFloat = 0.8
    let newHeightSubject = PublishSubject<(CGFloat, Bool)>()
    
    //MARK: - Input and Output
    struct Input{
        let transionYOffsetSubject: PublishSubject<(CGFloat, Bool)>
    }
    
    struct Output{
        let newHeightSubject: PublishSubject<(CGFloat, Bool)>
    }
    
    func transform(form input: Input) -> Output{
        let output = Output(newHeightSubject: newHeightSubject)
        input.transionYOffsetSubject
            .bind(onNext: { [weak self] (yOffset, isDragging) in
                guard let self = self else {return}
                output.newHeightSubject
                    .onNext((self.calculateHeight(yOffset: yOffset, isDragging: isDragging),
                                                !isDragging))
            })
            .disposed(by: self.disposeBag)
        return output
    }
    
    private func calculateHeight(yOffset: CGFloat, isDragging: Bool) -> CGFloat{
        let isDraggingDown = yOffset > 0
        let newHeight = self.currentContainerHeight - yOffset
        if isDragging {
            return newHeight
        }
        
        if newHeight < self.dismissibleHeight{
            return self.defaultHeight
        }else if newHeight < self.defaultHeight {
            return self.defaultHeight
        }else if newHeight < self.maximumContainerHeight && isDraggingDown{
            return self.defaultHeight
        }else if newHeight > self.defaultHeight && !isDraggingDown{
            return self.maximumContainerHeight
        }
        return -1
    }
}
