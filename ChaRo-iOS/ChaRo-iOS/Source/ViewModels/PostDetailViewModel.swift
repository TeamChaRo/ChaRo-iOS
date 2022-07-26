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
    var isFavorite: Bool = false
    var isStored: Bool = false
    let postDetailSubject = ReplaySubject<PostDetailData>.create(bufferSize: 1)
    
    init(postId: Int) {
        self.postId = postId
        getPostDetailData(postId: postId)
    }
    
    struct Input {
    }
    
    struct Output {
        let postDetailSubject: ReplaySubject<PostDetailData>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        return Output(postDetailSubject: postDetailSubject)
    }
    
    
}

extension PostDetailViewModel {
    
    func getPostDetailData(postId: Int) {
        PostResultService.shared.getPostDetail(postId: postId) { response in
            switch(response) {
            case .success(let resultData):
                if let data = resultData as? PostDetailData{
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
    
    func postCreatePost() {
        
        print("===서버통신 시작=====")
//        CreatePostService.shared.createPost(model: writedPostData!, image: imageList) { result in
//            switch result {
//            case .success(let message):
//                print(message)
//            case .requestErr(let message):
//                print(message)
//            case .serverErr:
//                print("서버에러")
//            case .networkFail:
//                print("네트워크에러")
//            default:
//                print("몰라에러")
//            }
//        }
    }
    
    func requestPostLike() {
        LikeService.shared.Like(userEmail: Constants.userEmail,
                                postId: postId) { [weak self] result in
            switch result {
            case .success(let success):
                if let success = success as? Bool {
                    self?.isFavorite.toggle()
                }
            case .requestErr(let msg):
                if let msg = msg as? String {
                    print(msg)
                }
            default :
                print("ERROR")
            }
        }
    }
    
    func requestPostScrap() {
        SaveService.shared.requestScrapPost(userId: Constants.userEmail,
                                            postId: postId) { [self] result in
            
            switch result {
            case .success(let success):
                if let success = success as? Bool {
                    print("스크랩 성공해서 바뀝니다")
                    self.isStored.toggle()
                }
            case .requestErr(let msg):
                if let msg = msg as? String {
                    print(msg)
                }
            default :
                print("ERROR")
            }
        }
    }
}
