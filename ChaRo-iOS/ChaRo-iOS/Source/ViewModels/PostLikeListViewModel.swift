//
//  PostLikeListViewModel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/02.
//

import UIKit
import RxSwift

class PostLikeListViewModel{

    //MARK: - Properties
    private var postId: Int
    
    let maxBackgroundAlpha: CGFloat = 0.8
    let defaultHeight: CGFloat = UIScreen.getDeviceHeight() / 2
    var currentContainerHeight: CGFloat = UIScreen.getDeviceHeight() / 2
    private let dismissibleHeight: CGFloat = 200
    private let maximumContainerHeight: CGFloat = UIScreen.getDeviceHeight() - 64
    
    private let newHeightSubject = PublishSubject<(CGFloat, Bool)>()
    private let postLikeListSubject = ReplaySubject<[Follow]>.create(bufferSize: 1)
    
    init(postId: Int) {
        self.postId = postId
        self.getPostLikeList()
    }
    
    //MARK: - Input and Output
    struct Input {
        let transionYOffsetSubject: PublishSubject<(CGFloat, Bool)>
    }
    
    struct Output {
        let newHeightSubject: PublishSubject<(CGFloat, Bool)>
        let postLikeListSubject: ReplaySubject<[Follow]>
    }
    
    func transform(form input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(newHeightSubject: newHeightSubject,
                            postLikeListSubject: postLikeListSubject)
        input.transionYOffsetSubject
            .bind(onNext: { [weak self] (yOffset, isDragging) in
                guard let self = self else { return }
                let newHeight = self.calculateHeight(yOffset: yOffset, isDragging: isDragging)
                output.newHeightSubject.onNext((newHeight,!isDragging))
            })
            .disposed(by: disposeBag)
        return output
    }
    
    private func calculateHeight(yOffset: CGFloat, isDragging: Bool) -> CGFloat {
        let isDraggingDown = yOffset > 0
        let newHeight = self.currentContainerHeight - yOffset
        if isDragging {
            return newHeight
        }
        
        if newHeight < self.dismissibleHeight {
            return -1
        }else if newHeight < self.defaultHeight {
            return self.defaultHeight
        }else if newHeight < self.maximumContainerHeight && isDraggingDown{
            return self.defaultHeight
        }else if newHeight > self.defaultHeight && !isDraggingDown{
            return self.maximumContainerHeight
        }
        return -1
    }
    
    private func getPostLikeList() {
        PostResultService.shared.getPostLikeList(postId: postId) { [weak self] response in
            switch response{
            case .success(let resultData):
                if let data =  resultData as? [Follow] {
                    self?.postLikeListSubject.onNext(data)
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

