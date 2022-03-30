//
//  AddressMainViewModel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/28.
//

import Foundation
import RxSwift
import TMapSDK

class AddressMainViewModel {
    
    var addressList: [AddressDataModel]
    var searchHistory: [KeywordResult] = []
    var newSearchHistory: [KeywordResult] = []
    
    let addressSubject = ReplaySubject<[(AddressDataModel, Int)]>.create(bufferSize: 1)
    let searchHistorySubject = PublishSubject<[KeywordResult]>()
    let polylineSubject = PublishSubject<[TMapPolyline]>()
    let markerSubject = PublishSubject<[TMapMarker]>()
    let isConfirmCheckSubject = PublishSubject<Bool>()
    
    init(start: AddressDataModel, end: AddressDataModel) {
        addressList = [start, end]
        addressSubject.onNext(refineAddressData())
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
}

// MARK: - Network
extension AddressMainViewModel {
    private func getSearchKeywords() {
        SearchKeywordService.shared.getSearchKeywords(userId: Constants.userId) { response in
            switch(response) {
            case .success(let resultData):
                if let data = resultData as? SearchResultDataModel {
                    print("내가 검색한 결과 조회~~~!!")
                    //self.searchHistory = data.data!
                    //dump(self.searchHistory)
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
    
    
    private func postSearchKeywords() {
        print("postSearchKeywords-----------------")
        var searchKeywordList: [SearchHistory] = []
        
        for item in newSearchHistory {
            let address = SearchHistory(title: item.title,
                                        address: item.address,
                                        latitude: item.latitude,
                                        longitude: item.longitude)
            searchKeywordList.append(address)
        }
        
        SearchKeywordService.shared.postSearchKeywords(userId: Constants.userId,
                                                       keywords: searchKeywordList) {  response in
            print("결과받음")
            
            switch(response) {
            case .success(let resultData):
                print("--------------------------")
                print("\(resultData)")
                print("--------------------------")
                if let data = resultData as? SearchResultDataModel {
                    print("성공했더~!!!!")
                    dump(data)
                    print("성공했더~!!!!")
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

// MARK: - Map Logic
extension AddressMainViewModel {
    
    private func getOptimizationCenter() ->  CLLocationCoordinate2D {
        var minX, maxX: Double
        var minY, maxY: Double
        
        let point1 = addressList[0].getPoint()
        let point2 = addressList[addressList.endIndex-1].getPoint()
        
        if point1.latitude < point2.latitude {
            minX = point1.latitude
            maxX = point2.latitude
        } else {
            maxX = point1.latitude
            minX = point2.latitude
        }
        
        if point1.longitude < point2.longitude {
            minY = point1.longitude
            maxY = point2.longitude
        } else {
            maxY = point1.longitude
            minY = point2.longitude
        }
        
        
        for i in 1..<addressList.count {
            let point = addressList[i].getPoint()
            if point.latitude < minX {
                minX = point.latitude
            } else if point.latitude > maxX {
                maxX = point.latitude
            }
            
            if point.longitude < minY{
                minY = point.longitude
            } else if point.longitude > maxY {
                maxY = point.longitude
            }
        }
        return CLLocationCoordinate2D(latitude: (minX+maxX)/2, longitude: (minY+maxY)/2)
    }
}
