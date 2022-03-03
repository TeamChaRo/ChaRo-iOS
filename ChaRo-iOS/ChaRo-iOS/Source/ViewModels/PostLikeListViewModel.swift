//
//  PostLikeListViewModel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/02.
//

import RxSwift
import UIKit

class PostLikeListViewModel{

    //MARK: - Properties
    let defaultHeight: CGFloat = UIScreen.getDeviceHeight() / 2
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.getDeviceHeight() - 64
    var currentContainerHeight: CGFloat = UIScreen.getDeviceHeight() / 2
    let maxBackgroundAlpha: CGFloat = 0.8
    
    //MARK: - Input and Output
    struct Input{
        let transionYOffsetSubject = PublishSubject<(CGFloat, Bool)>()
    }
    
    struct Output{
        let newHeightSubject = PublishSubject<(CGFloat, Bool)>()
    }
    
    func transform(form input: Input, disposeBag: DisposeBag) -> Output{
        let output = Output()
        input.transionYOffsetSubject
            .bind(onNext: { [weak self] (yOffset, isDragging) in
                guard let self = self else {return}
                output.newHeightSubject
                    .onNext((self.calculateHeight(yOffset: yOffset, isDragging: isDragging),
                                                !isDragging))
            })
            .disposed(by: disposeBag)
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
    
    func getPostLikeList(){
        PostResultService.shared.getPostLikeList(postId: 6){ response in
            switch response{
            case .success(let resultData):
                dump(resultData)
                if let data =  resultData as? [Follow]{
                    print("response = \(data)")
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}

