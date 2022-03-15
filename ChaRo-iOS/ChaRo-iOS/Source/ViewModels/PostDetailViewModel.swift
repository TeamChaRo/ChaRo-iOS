//
//  PostDetailViewModel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/15.
//

import Foundation
import RxSwift

class PostDetailViewModel {
    
    let postId: Int
    let postDetailSubject = ReplaySubject<PostDetailData>.create(bufferSize: 1)
    
    init(postId: Int){
        self.postId = postId
        getPostDetailData(postId: postId)
    }
    
    struct Input{
    }
    
    struct Output{
        let postDetailSubject: ReplaySubject<PostDetailData>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        return Output(postDetailSubject: postDetailSubject)
    }
    
    func getPostDetailData(postId: Int){
        PostResultService.shared.getPostDetail(postId: postId){ response in
            switch(response){
            case .success(let resultData):
                if let data =  resultData as? PostDetailData{
                    self.postDetailSubject.onNext(data)
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
