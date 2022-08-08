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
    var postLikeClosure: ((Bool?) -> ())?
    var isLiked: Bool? {
        didSet {
            postLikeClosure?(isLiked)
        }
    }
    
    var isStored: Bool = false {
        didSet {
            likeSubject.onNext(isStored)
        }
    }
    
    let likeSubject = PublishSubject<Bool?>()
    let storeSubject = PublishSubject<Bool?>()
    var postDetailData: PostDetailDataModel?
    let postDetailSubject = ReplaySubject<PostDetailDataModel>.create(bufferSize: 1)
    
    init(postId: Int) {
        self.postId = postId
        getPostDetailData(postId: postId)
    }
    
    struct Input {}
    
    struct Output {
        let postDetailSubject: ReplaySubject<PostDetailDataModel>
        let likeSubject: PublishSubject<Bool?>
        let storeSubject: PublishSubject<Bool?>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        return Output(postDetailSubject: postDetailSubject, likeSubject: likeSubject, storeSubject: storeSubject)
    }
}

extension PostDetailViewModel {
    
    func getPostDetailData(postId: Int) {
        PostResultService.shared.getPostDetail(postId: postId) { [weak self] response in
            switch(response) {
            case .success(let resultData):
                guard let self = self else { return }
                if let data = resultData as? PostDetailDataModel {
                    self.postDetailData = data
                    self.postDetailSubject.onNext(data)
                    self.isLiked = data.isFavorite != 0
                    self.isStored = data.isStored != 0
                    dump(data)
                    print("=================")
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
                if let _ = success as? Bool {
                    self?.isLiked?.toggle()
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
                                            postId: postId) { [weak self] result in
            
            switch result {
            case .success(let success):
                if let _ = success as? Bool {
                    print("스크랩 성공해서 바뀝니다")
                    self?.isStored.toggle()
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

// TODO: - 게시물 작성하기 마지막 눌렀을 때, 구경하기와 같은 뷰로 보이도록
//    public func setDataWhenConfirmPost(data: WritePostData,
//                                       imageList: [UIImage],
//                                       addressList: [AddressDataModel]) {
//        isEditingMode = true
//        isAuthor = true
//        self.addressList = addressList
//        self.imageList = imageList
//        writedPostData = data
//
//        let sendedPostDate = PostDetail(title: data.title,
//                                  author: Constants.userId,
//                                  isAuthor: true,
//                                  profileImage: UserDefaults.standard.string(forKey: "profileImage")!,
//                                  postingYear: Date.getCurrentYear(),
//                                  postingMonth: Date.getCurrentMonth(),
//                                  postingDay: Date.getCurrentDay(),
//                                  isStored: false,
//                                  isFavorite: false,
//                                  likesCount: 0,
//                                  images: [""],
//                                  province: data.province,
//                                  city: data.region,
//                                  themes: data.theme,
//                                  source: "",
//                                  wayPoint: [""],
//                                  destination: "",
//                                  longtitude: [""],
//                                  latitude: [""],
//                                  isParking: data.isParking,
//                                  parkingDesc: data.parkingDesc,
//                                  warnings: data.warning,
//                                  courseDesc: data.courseDesc)
//
//        self.postData = sendedPostDate
//
//        dump(writedPostData)
//
//        print("넘겨져온 이미지야~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
//        print("imageList = \(imageList)")
//        print("넘겨져온 이미지야~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
//
//        var newAddressList :[Address] = []
//        for address in addressList {
//            newAddressList.append(address.getAddressDataModel())
//        }
//
//        writedPostData?.course = newAddressList
//    }
