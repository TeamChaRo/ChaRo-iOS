//
//  PostDetailViewModel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/15.
//

import UIKit
import RxSwift

import KakaoSDKTemplate
import KakaoSDKShare
import RxKakaoSDKShare
import KakaoSDKCommon

import FirebaseDynamicLinks

final class PostDetailViewModel {
    private let disposeBag = DisposeBag()
    let postId: Int
    var postLikeClosure: ((Bool?) -> ())?
    var writedImageList: [UIImage]?
    var writePostData: WritePostData?
    var postCreateResultClosure: ((Bool) -> ())?
    var isEditingMode = false
    
    var isLiked: Bool? {
        didSet {
            postLikeClosure?(isLiked)
        }
    }
    
    var isStored: Bool? {
        didSet {
            storeSubject.onNext(isStored)
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
    
    init(writePostData: WritePostData?, imageList: [UIImage]) {
        self.postId = -1
        self.writePostData = writePostData
        self.writedImageList = imageList
        self.isEditingMode = true
        refineWriteDataToPostData(writePostData: writePostData)
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
    
    func refineWriteDataToPostData(writePostData: WritePostData?) {
        guard let writedData = writePostData else { return }
        let detilaData = PostDetailDataModel(postId: -1,
                                             title: writedData.title,
                                             author: Constants.nickName,
                                             authorEmail: writedData.userEmail,
                                             profileImage: Constants.profileName,
                                             isAuthor: true,
                                             isStored: 0,
                                             isFavorite: 0,
                                             isParking: writedData.isParking,
                                             parkingDesc: writedData.parkingDesc,
                                             courseDesc: writedData.courseDesc,
                                             province: writedData.province,
                                             region: writedData.region,
                                             themes: writedData.changeThemeToKorean(),
                                             likesCount: 0,
                                             createdAt: "",
                                             images: [],
                                             course: writedData.course,
                                             warnings: writedData.changeWaningToBool())
        self.postDetailData = detilaData
        self.postDetailSubject.onNext(detilaData)
        self.isLiked = false
        self.isStored = false
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
    
    
    func postWritePost() {
        guard let writedData = writePostData,
              let imageList = writedImageList else { return }
        
        CreatePostService.shared.createPost(
            model: writedData,
            image: imageList
        ) { [weak self] result in
            switch result {
            case let .success(resultData):
                self?.postCreateResultClosure?(true)
                debugPrint("POST /post/write success: \(resultData)")
            case let .requestErr(message):
                self?.postCreateResultClosure?(false)
                debugPrint("POST /post/write requestErr: \(message)")
            case .serverErr:
                debugPrint("POST /post/write serverErr")
            case .networkFail:
                debugPrint("POST /post/write networkFail")
            default:
                debugPrint("POST /post/write error")
                self?.postCreateResultClosure?(true)
            }
        }
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
        SaveService.shared.requestScrapPost(postId: postId) { [weak self] result in
            switch result {
            case .success(let success):
                if let _ = success as? Bool {
                    print("스크랩 성공해서 바뀝니다")
                    self?.isStored?.toggle()
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


// MARK: Dynamic Link 공유하기
extension PostDetailViewModel {
    func makeDynamicShareLink(completion: @escaping ([Any]) -> ()) {
        guard let postDetailLink = URL(string: "https://charo.page.link" + "/" + "dtl" + "?postId=" + "\(postId)") else { return }
        let dynamicLinksDomainURIPrefix = "https://charo.page.link"
        let linkBuilder = DynamicLinkComponents(link: postDetailLink, domainURIPrefix: dynamicLinksDomainURIPrefix)
        
        // iOS
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.king.Charo")
        linkBuilder?.iOSParameters?.minimumAppVersion = "1.0.0"
        
        // android
        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.charo.android")
        linkBuilder?.androidParameters?.minimumVersion = 90
        
        // socialMetaTag
        linkBuilder?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder?.socialMetaTagParameters?.imageURL = URL(string: postDetailData?.images?.first ?? "")
        linkBuilder?.socialMetaTagParameters?.title = postDetailData?.title ?? ""
        
        guard let longDynamicLink = linkBuilder?.url else { return }
        var shareObject = [Any]()
        
        DynamicLinkComponents.shortenURL(longDynamicLink, options: .none) { url, warning, error in
            guard let url = url else { return }
            shareObject.append(url)
            completion(shareObject)
        }
    }
    
    func shareToKakaotalk() {
        guard let title = postDetailData?.title,
              let description = postDetailData?.courseDesc,
              let firstImage = postDetailData?.images?.first else { return }
        let feedTemplateJsonStringData =
            """
            {
                "object_type": "feed",
                "content": {
                    "title": "\(title)",
                    "description": "\(description)",
                    "image_url": "\(firstImage)",
                    "link": {
                        "mobile_web_url": "https://developers.kakao.com",
                        "web_url": "https://developers.kakao.com"
                    }
                },
                "buttons": [
                    {
                        "title": "자세히 보기",
                        "link": {
                            "mobile_web_url": "https://developers.kakao.com",
                            "web_url": "https://developers.kakao.com"
                        }
                    }
                ]
            }
            """.data(using: .utf8)!
        
        if let templatable = try? SdkJSONDecoder.custom.decode(FeedTemplate.self, from: feedTemplateJsonStringData) {
            ShareApi.shared.rx.shareDefault(templatable:templatable)
                .subscribe(onSuccess: { (sharingResult) in
                    print("shareDefault() success.")
                    UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                }, onFailure: {error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
    }
}
