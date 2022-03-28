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

class AddressMainVC: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel = AddressMainViewModel()
    private let updateAddressSubject = PublishSubject<(AddressDataModel, Int)>()
    
    public var addressList: [AddressDataModel] = []
    public var searchHistory: [KeywordResult] = []
    public var newSearchHistory: [KeywordResult] = []
    public var addressCellList: [AddressButtonCell] = []
    
    private var isFirstFinded: Bool = true
    private var sendedPostData: WritePostData?
    private var imageList: [UIImage] = []
    private let animator = UIViewPropertyAnimator(duration: 7, curve: .easeInOut)
    
    private lazy var tableView = UITableView().then {
        $0.register(cell: AddressButtonCell.self)
        //$0.delegate = self
        //$0.dataSource = self
        $0.separatorStyle = .none
    }
    
    private var oneCellHeight: CGFloat = 48
    private var tableViewHeight: CGFloat  = 96
    private var tableViewBottomOffset: CGFloat  = 19
    private var isFirstOpen: Bool = true
    
    //MARK: - About Map
    private let tMapView = TMapView()
    private var markerList: [TMapMarker] = []
    private var polyLineList: [TMapPolyline] = []
    
    //MARK: UI Component
    private let backButton = UIButton().then {
        $0.setBackgroundImage(ImageLiterals.icBackGray, for: .normal)
    }
    
    private var confirmButton = UIButton().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .mainBlue
        $0.setTitleColor(.white, for: .normal)
        $0.isHidden = true
        $0.setTitle("작성완료", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindToViewModel()
        setConstraints()
        bind()
        initMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inputMarkerInMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupGuideAnimationView()
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
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
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
                let newAddressList = self?.changeAddressData()
                let nextVC = PostDetailVC()
                // postSearchKeywords()
                self?.navigationController?.pushViewController(nextVC, animated: true)
            }).disposed(by: disposeBag)
    }
    
    
    private func changeAddressData() -> [Address]{
        print("현재까지 주소 - \(addressList)")
        var castedToAddressDatalList : [Address] = []
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
    
    func replaceAddressData(address: AddressDataModel, index: Int) {
        updateAddressSubject.onNext((address, index))
    }
}

// MARK: - Guide Animation
extension AddressMainVC{
    private func setupGuideAnimationView() {
        guard isFirstOpen else { return }
        let guideView = MapGuideView()
        self.view.addSubview(guideView)
        guideView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        animator.addAnimations { guideView.alpha = 0 }
        animator.addCompletion { _ in guideView.removeFromSuperview() }
        animator.startAnimation()
        isFirstOpen = false
    }
}

//MARK: - Address 관련
extension AddressMainVC {
    
    public func setWritePostDataForServer(data: WritePostData, imageList: [UIImage]) {
        sendedPostData = data
        self.imageList = imageList
        dump(imageList)
    }
}


extension AddressMainVC: AddressButtonCellDelegate {
    func addressButtonCellForRemoving(cell: AddressButtonCell) {
        updateAddressSubject.onNext((AddressDataModel(), -1))
        updateTableViewHeight()
    }
    
    func addressButtonCellForAdding(cell: AddressButtonCell) {
        updateAddressSubject.onNext((AddressDataModel(), 1))
        updateTableViewHeight()
    }
    
    func addressButtonCellForPreseting(cell: AddressButtonCell) {
        let nextVC = SearchAddressKeywordVC()
        let index = cell.getTableCellIndexPath()
        nextVC.setAddressModel(model: viewModel.addressList[index],
                               cellType: cell.cellType.rawValue,
                               index: index)
        //nextVC.setSearchKeyword(list: newSearchHistory+searchHistory)
        nextVC.setSearchKeyword(list: [])
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

//MARK: - TMap
extension AddressMainVC{
    private func initMapView() {
        tMapView.setApiKey(MapService.mapkey)
        tMapView.delegate = self
    }
    
    private func removeAllPolyLines() {
        polyLineList.forEach { $0.map = nil }
        polyLineList.removeAll()
    }
    
    private func addPathInMapView() {
        removeAllPolyLines()
        let pathData = TMapPathData()
        
        for index in 0..<addressList.count-1 {
            if addressList[index+1].title == "" {
                return
            }
            print("index = \(index)")
            pathData.findPathData(startPoint: addressList[index].getPoint(),
                                  endPoint: addressList[index+1].getPoint()) { result, error in
                guard let polyLine = result else { return }
                
                print(" start = \(self.addressList[index]), \(self.addressList[index].title)")
                print(" end = \(self.addressList[index+1]),\(self.addressList[index+1].title) ")
                
                print("경로 들어감")
                self.polyLineList.append(polyLine)
                polyLine.strokeColor = .mainBlue
                DispatchQueue.main.async {
                    polyLine.map = self.tMapView
                }
                
                if index == self.addressList.count-2{
                    
                    print("경로 그려져야함!!!!! = \(index)")
                    DispatchQueue.main.async {
                        self.tMapView.fitMapBoundsWithPolylines(self.polyLineList)
                    }
                }
            }
        }
    }
    
    private func inputMarkerInMapView() {
        print("inputMarkerInMapView")
        print("addressList = \(addressList.count)")
        for index in 0..<addressList.count {
            
            if addressList[index].title != "" {
                let point = addressList[index].getPoint()
                let marker = TMapMarker(position: point)
                marker.icon = setMarkerImage(index: index)
                marker.map = tMapView
                markerList.append(marker)
                tMapView.setCenter(point)
            }
        }
    }
    
    private func setMarkerImage(index: Int) -> UIImage {
        switch index {
        case 0:
            return ImageLiterals.icRouteStart
        case addressList.count - 1:
            return ImageLiterals.icRouteEnd
        default:
            return ImageLiterals.icRouteWaypoint
        }
    }
}

extension AddressMainVC : TMapViewDelegate {
    func mapViewDidFinishLoadingMap() {
        print("mapViewDidFinishLoadingMap")
        tMapView.setZoom(12)
        print("tMapView.getZoom() = \(tMapView.getZoom())")
    }
    
    func mapView(_ mapView: TMapView, shouldChangeFrom oldPosition: CLLocationCoordinate2D,
                 to newPosition: CLLocationCoordinate2D) -> Bool {
        return true
    }
    
}



