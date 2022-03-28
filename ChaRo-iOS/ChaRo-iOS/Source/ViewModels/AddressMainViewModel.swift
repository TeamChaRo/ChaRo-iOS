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
    
    var addressList: [AddressDataModel] = []
    var searchHistory: [KeywordResult] = []
    var newSearchHistory: [KeywordResult] = []
    
    let addressSubject = ReplaySubject<[(AddressDataModel, Int)]>.create(bufferSize: 1)
    let searchHistorySubject = PublishSubject<[KeywordResult]>()
    
    init() {
        addressList = [AddressDataModel(), AddressDataModel()]
        addressSubject.onNext(refineAddressData())
    }
    
    struct Input {
        let updateAddressSubject: PublishSubject<(AddressDataModel, Int)>
    }
    
    struct Output {
        let addressSubject: ReplaySubject<[(AddressDataModel, Int)]>
    }
    
    func transform(of input: Input, disposeBag: DisposeBag) -> Output {
        input.updateAddressSubject
            .bind(onNext: { address, index in
            self.updateAddress(of: address, at: index)
            }).disposed(by: disposeBag)
        let output = Output(addressSubject: addressSubject)
        return output
    }
    
    private func updateAddress(of address: AddressDataModel, at index: Int) {
        if address.title == "" {
            index == 1 ? addressList.insert(address, at: 1) : addressList.remove(atOffsets: IndexSet(1...1))
        } else {
            addressList[index] = address
        }
        addressSubject.onNext(refineAddressData())
    }
    
    private func refineAddressData() -> [(AddressDataModel, Int)] {
        var list: [(AddressDataModel, Int)] = []
        addressList.forEach { list.append(($0, addressList.count)) }
        return list
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
