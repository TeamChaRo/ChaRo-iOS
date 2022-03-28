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
