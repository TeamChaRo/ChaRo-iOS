//
//  AddressSearchVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/06.
//

import UIKit
import SnapKit
import Then
import RxSwift
import TMapSDK

final class AddressMainVC: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel: AddressMainViewModel
    private let updateAddressSubject = PublishSubject<(AddressDataModel, Int)>()
    
    private var sendedPostData: WritePostData?
    private var imageList: [UIImage] = []
    
    private var oneCellHeight: CGFloat = 0.0
    private var tableViewHeight: CGFloat = 0.0
    private var tableViewBottomOffset: CGFloat = 0.0
    private var isFirstOpen: Bool = true
    
    // MARK: - About Map
    private let tMapView = TMapView()
    private var markerList: [TMapMarker] = []
    private var polyLineList: [TMapPolyline] = []
    
    // MARK: UI Component
    private let backButton = UIButton().then {
        $0.setBackgroundImage(ImageLiterals.icBackGray, for: .normal)
    }
    
    private lazy var tableView = UITableView().then {
        $0.register(cell: AddressButtonCell.self)
        $0.separatorStyle = .none
    }
    
    private var confirmButton = UIButton().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .mainBlue
        $0.setTitleColor(.white, for: .normal)
        $0.isHidden = true
        $0.setTitle("작성완료", for: .normal)
    }
    
    init() {
        viewModel = AddressMainViewModel(start: AddressDataModel(), end: AddressDataModel())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        bindToViewModel()
        bind()
        initMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGuideView()
    }
    
    private func setConstraints() {
        view.addSubviews([backButton, tableView, tMapView,confirmButton])
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-29)
            $0.height.equalTo(tableViewHeight)
        }
        
        tMapView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
            $0.height.equalTo(48)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        oneCellHeight = 48.0
        tableViewBottomOffset = 19
        tableViewHeight = (oneCellHeight * 2) + tableViewBottomOffset
    }
    
    private func bindToViewModel() {
        let output = viewModel.transform(of: AddressMainViewModel.Input(updateAddressSubject: updateAddressSubject), disposeBag: disposeBag)
        output.addressSubject
            .bind(to: tableView.rx.items(cellIdentifier: AddressButtonCell.className,
                                         cellType: AddressButtonCell.self)){ row, element, cell in
                switch row {
                case 0:
                    cell.setContent(of: element.0, for: .start, at: element.1)
                case (element.1 - 1):
                    cell.setContent(of: element.0, for: .end, at: element.1)
                default:
                    cell.setContent(of: element.0, for: .mid, at: element.1)
                }
                cell.delegate = self
            }.disposed(by: disposeBag)
        
        output.polylineSubject.bind(onNext: { [weak self] polyLineList in
            self?.updatePolyline(list: polyLineList)
        }).disposed(by: disposeBag)
        
        output.markerSubject.bind(onNext: { [weak self] markerList in
            self?.updateMarkers(list: markerList)
        }).disposed(by: disposeBag)
        
        output.isConfirmCheckSubject.bind(onNext: { [weak self]isConfirm in
            self?.confirmButton.isHidden = !isConfirm
        }).disposed(by: disposeBag)
    }
    
    private func bind() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.postSearchKeywords()
                guard let writedData = self.viewModel.getWritedPostdata(writePostData: self.sendedPostData) else { return }
                let nextVC = PostDetailVC(writePostData: writedData, imageList: self.imageList)
                self.navigationController?.pushViewController(nextVC, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func replaceAddressData(address: AddressDataModel, index: Int) {
        updateAddressSubject.onNext((address, index))
    }
    
    private func changeAddressData() -> [Course] {
        var castedToAddressDatalList : [Course] = []
        viewModel.addressList.forEach{
            castedToAddressDatalList.append($0.getAddressDataModel())
        }
        return castedToAddressDatalList
    }
    
    private func updateTableViewHeight() {
        tableViewHeight = CGFloat(viewModel.addressList.count) * oneCellHeight + tableViewBottomOffset
        tableView.snp.updateConstraints {
            $0.height.equalTo(tableViewHeight)
        }
    }
    
    func setWritePostDataForServer(data: WritePostData, imageList: [UIImage]) {
        sendedPostData = data
        self.imageList = imageList
        dump(imageList)
    }
    
    func setAddressListData(list: [AddressDataModel]) {
        guard !list.isEmpty else { return }
        viewModel.addressList = list
    }
    
    func addSearchedKeyword(address: AddressDataModel) {
        viewModel.newSearchHistory.append(address.getKeywordResult())
    }
}

// MARK: - Guide Animation
extension AddressMainVC {
    private func setupGuideView() {
        guard isFirstOpen else {
            removeGuideView()
            return
        }
        
        let guideView = MapGuideView().then { $0.tag = 999 }
        self.view.addSubview(guideView)
        guideView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        isFirstOpen = false
    }
    
    private func removeGuideView() {
        if let guideView = view.viewWithTag(999) {
            guideView.removeFromSuperview()
            return
        }
    }
}


extension AddressMainVC: AddressButtonCellDelegate {
    func addressButtonCellForRemoving(cell: AddressButtonCell) {
        updateAddressSubject.onNext((AddressDataModel(), -2))
        updateTableViewHeight()
    }
    
    func addressButtonCellForAdding(cell: AddressButtonCell) {
        updateAddressSubject.onNext((AddressDataModel(), -1))
        updateTableViewHeight()
    }
    
    func addressButtonCellForPreseting(cell: AddressButtonCell) {
        let nextVC = SearchAddressKeywordVC(searchHistory: viewModel.getSearchHistory())
        let index = cell.getTableCellIndexPath()
        nextVC.setAddressModel(model: viewModel.addressList[index],
                               cellType: cell.cellType.rawValue,
                               index: index)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

//MARK: - TMap
extension AddressMainVC {
    private func updatePolyline(list: [TMapPolyline]) {
        polyLineList.forEach { $0.map = nil }
        polyLineList = list
        polyLineList.forEach {
            $0.strokeColor = .mainBlue
            $0.map = tMapView
        }
        DispatchQueue.main.async { [weak self] in
            self?.tMapView.fitMapBoundsWithPolylines(self?.polyLineList ?? [])
        }
    }
    
    private func updateMarkers(list: [TMapMarker]) {
        markerList.forEach { $0.map = nil }
        markerList = list
        for index in 0..<markerList.count {
            markerList[index].icon = setMarkerImage(index: index)
            markerList[index].map = tMapView
        }
        
        if markerList.count == 1 {
            DispatchQueue.main.async { [weak self] in
                self?.tMapView.fitMapBoundsWithMarkers(self?.markerList ?? [])
            }
        }
    }
    
    private func setMarkerImage(index: Int) -> UIImage {
        switch index {
        case 0:
            return ImageLiterals.icRouteStart
        case markerList.count - 1:
            return ImageLiterals.icRouteEnd
        default:
            return ImageLiterals.icRouteWaypoint
        }
    }
}

extension AddressMainVC: TMapViewDelegate {
    
    private func initMapView() {
        tMapView.setApiKey(MapService.mapkey)
        tMapView.delegate = self
    }
 
    func mapViewDidFinishLoadingMap() {
        tMapView.setCenter(CLLocationCoordinate2D(latitude: 35.83808343685922, longitude: 127.84007638374868))
        tMapView.setZoom(6)
        tMapView.sizeToFit()
        tMapView.layoutIfNeeded()
    }
    
    func mapView(_ mapView: TMapView, shouldChangeFrom oldPosition: CLLocationCoordinate2D,
                 to newPosition: CLLocationCoordinate2D) -> Bool {
        return true
    }
}



