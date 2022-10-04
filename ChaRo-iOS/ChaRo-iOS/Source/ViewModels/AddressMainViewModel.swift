//
//  AddressMainViewModel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/28.
//

import Foundation
import CoreMedia

import RxSwift
import TMapSDK
import Then

class AddressMainViewModel {
    
    var addressList: [AddressDataModel]
    var searchedHistory: [KeywordResult] = []
    var newSearchHistory: [KeywordResult] = []

    private enum Const {
        static let ThemeDic: Dictionary = ["봄":"spring", "여름":"summer", "가을":"fall", "겨울":"winter", "산":"mountain", "바다":"sea", "호수":"lake", "강":"river", "해안도로":"oceanRoad", "벚꽃":"blossom", "단풍":"maple", "여유":"relax", "스피드":"speed", "야경":"nightView", "도심":"cityView"]
    }

    private let addressSubject = ReplaySubject<[(AddressDataModel, Int)]>.create(bufferSize: 1)
    private let polylineSubject = PublishSubject<[TMapPolyline]>()
    private let markerSubject = PublishSubject<[TMapMarker]>()
    private let isConfirmCheckSubject = PublishSubject<Bool>()
    
    init(start: AddressDataModel, end: AddressDataModel) {
        addressList = [start, end]
        addressSubject.onNext(refineAddressData())
        getSearchKeywords()
    }
    
    struct Input {
        let updateAddressSubject: PublishSubject<(AddressDataModel, Int)>
    }
    
    struct Output {
        let addressSubject: ReplaySubject<[(AddressDataModel, Int)]>
        let polylineSubject: PublishSubject<[TMapPolyline]>
        let markerSubject: PublishSubject<[TMapMarker]>
        let isConfirmCheckSubject: PublishSubject<Bool>
    }
    
    func transform(of input: Input, disposeBag: DisposeBag) -> Output {
        input.updateAddressSubject
            .bind(onNext: { address, index in
            self.updateAddress(of: address, at: index)
            }).disposed(by: disposeBag)
        let output = Output(addressSubject: addressSubject,
                            polylineSubject: polylineSubject,
                            markerSubject: markerSubject,
                            isConfirmCheckSubject: isConfirmCheckSubject)
        return output
    }
    
    private func updateAddress(of address: AddressDataModel, at index: Int) {
        if index == -1 {
            addressList.insert(address, at: 1)
        } else if index == -2 {
            addressList.remove(atOffsets: IndexSet(1...1))
            inputMarkerInMapView()
        } else {
            addressList[index] = address
            inputMarkerInMapView()
        }
        addressSubject.onNext(refineAddressData())
        addPathInMapView()
        checkAddressCompleted()
    }
    
    private func refineAddressData() -> [(AddressDataModel, Int)] {
        var list: [(AddressDataModel, Int)] = []
        addressList.forEach { list.append(($0, addressList.count)) }
        return list
    }
    
    private func checkAddressCompleted() {
        var isConfirm = true
        for address in addressList {
            if address.title == "" {
                isConfirm = false
                break
            }
        }
        isConfirmCheckSubject.onNext(isConfirm)
    }
    
    private func inputMarkerInMapView() {
        var markerList: [TMapMarker] = []
        for index in 0..<addressList.count {
            if addressList[index].title == "" { continue }
            let marker = TMapMarker(position: addressList[index].getPoint())
            markerList.append(marker)
        }
        markerSubject.onNext(markerList)
    }
    
    private func addPathInMapView() {
        var polylineList: [TMapPolyline] = []
        let pathData = TMapPathData()
        for index in 0..<addressList.count-1 {
            if !hasAddress(of: index+1) || addressList[index+1].title == "" { return }
            pathData.findPathData(startPoint: addressList[index].getPoint(),
                                  endPoint: addressList[index+1].getPoint()) { [weak self] result, error in
                guard let polyLine = result, let self = self else { return }
                polylineList.append(polyLine)
                if polylineList.count == self.addressList.count - 1 {
                    self.polylineSubject.onNext(polylineList)
                }
            }
        }
    }
    
    private func hasAddress(of index: Int) -> Bool {
        guard index < addressList.count else { return false }
        return true
    }
    
    func getSearchHistory() -> [KeywordResult]{
        return searchedHistory + newSearchHistory
    }
}

// MARK: - Network
extension AddressMainViewModel {
    
    private func getSearchKeywords() {
        SearchKeywordService.shared.getSearchKeywords(userId: Constants.userEmail) { response in
            switch(response) {
            case .success(let resultData):
                if let data = resultData as? [KeywordResult] {
                    self.searchedHistory = data
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
    
    func postSearchKeywords() {
        var searchKeywordList: [SearchHistory] = []
        newSearchHistory.forEach { searchKeywordList.append($0.getSearchHistory()) }
        
        SearchKeywordService.shared.postSearchKeywords(keywords: searchKeywordList) { response in
            switch(response) {
            case .success(let resultData):
                if let data = resultData as? SearchResultDataModel {
                    dump(data)
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

    func postWritePost(writePostData: WritePostData?, imageList: [UIImage]) {
        guard let writedData = getWritedPostdata(writePostData: writePostData) else { return }
        
        CreatePostService.shared.createPost(
            model: writedData,
            image: imageList
        ) { result in
            switch result {
            case let .success(resultData):
                debugPrint("POST /post/write success: \(resultData)")
            case let .requestErr(message):
                debugPrint("POST /post/write requestErr: \(message)")
            case .serverErr:
                debugPrint("POST /post/write serverErr")
            case .networkFail:
                debugPrint("POST /post/write networkFail")
            default:
                debugPrint("POST /post/write error")
            }
        }
    }
    
    func getWritedPostdata(writePostData: WritePostData?) -> WritePostData? {
        guard var writePostData = writePostData else { return nil }
        
        writePostData.course = self.addressList.map { address -> Course in
            return Course(
                address: address.address,
                latitude: address.latitude,
                longitude: address.longitude
            )
        }

        writePostData.theme = writePostData.theme.compactMap { title in
            return Const.ThemeDic[title]
        }
        
        return writePostData
    }
}
