//
//  SearchKeywordViewModel.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/09/03.
//

import Foundation
import TMapSDK
import RxSwift

class SearchKeywordViewModel {
    
    let tmapView = MapService.getTmapView()
    let pathData = TMapPathData()
    var addressSubject = ReplaySubject<[AddressDataModel]>.create(bufferSize: 1)
    
    init(searchHistory: [KeywordResult]) {
        addressSubject.onNext(refineSearchHistory(of: searchHistory))
    }
    
    struct Input {
        
    }
    
    struct Output {
        let addressSubject: ReplaySubject<[AddressDataModel]>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output{
        return Output(addressSubject: addressSubject)
    }
    
    private func refineSearchHistory(of list: [KeywordResult]) -> [AddressDataModel] {
        var addressModelList: [AddressDataModel] = []
        list.forEach { addressModelList.append($0.getAddressModel()) }
        return addressModelList
    }
    
    public func findAutoCompleteAddressList(keyword: String) {
        pathData.autoComplete(keyword) { autoAddressList, error in
            let newIndex = autoAddressList.count < 7 ? autoAddressList.count : 7
            self.searchKeywordList(keywordList: Array(autoAddressList[0..<newIndex]))
            if let error = error { print("autoComplete \(error)") }
        }
    }
    
    private func searchKeywordList(keywordList: [String]) {
        var poiItemList: [TMapPoiItem] = []
        for index in 0..<keywordList.count {
            searchKeywordPoi(keyword: keywordList[index]) { poiItems in
                poiItemList.append(contentsOf: poiItems)
                if index == keywordList.count - 1 {
                    self.refinePoiItemsToAddressData(poiList: poiItemList)
                    return
                }
            }
        }
    }
    
    private func searchKeywordPoi(keyword: String, completion: @escaping (([TMapPoiItem]) -> ())) {
        pathData.requestFindAllPOI(keyword, count: 2) { poiItems, error in
            if let poiList = poiItems { completion(poiList) }
            if let error = error { print("searchKeywordPoi \(error)") }
        }
    }
    
    private func refinePoiItemsToAddressData(poiList: [TMapPoiItem]) {
        var addressList: [AddressDataModel] = []
        poiList.forEach{
            let address = AddressDataModel(title: $0.name ?? "명칭이 없습니다.",
                                      address: $0.address ?? "정확한 주소를 확인할 수 없습니다.",
                                      latitude: $0.coordinate?.latitude.description ?? "0.0",
                                      longitude: $0.coordinate?.longitude.description ?? "0.0")
            addressList.append(address)
        }
        addressSubject.onNext(addressList)
    }
    
    func getCurrentDate() -> String {
        return Date.getCurrentMonth() + "." + Date.getCurrentDay()
    }
}
