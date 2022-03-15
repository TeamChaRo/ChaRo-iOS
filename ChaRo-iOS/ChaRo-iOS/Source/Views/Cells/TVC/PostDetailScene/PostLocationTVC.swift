//
//  PostLocationTVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/15.
//

import UIKit
import SnapKit
import Then
import RxSwift
import TMapSDK

class PostLocationTVC: UITableViewCell {
    
    private let disposeBag = DisposeBag()
    
    private let backgourndView = UIView().then {
        $0.backgroundColor = .gray10
        $0.layer.cornerRadius = 8
    }
    private let startAddressView = PostDetailAddressView(title: "출발지")
    private let midAddressView = PostDetailAddressView(title: "경유지")
    private let endAddressView = PostDetailAddressView(title: "도착지")

    private let addressStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 3
        $0.distribution = .fillEqually
    }
    private lazy var tMapView = TMapView().then {
        $0.delegate = self
        $0.setApiKey(MapService.mapkey)
    }
    private var courseList: [Course] = []
    private var polyLineSubjuect = PublishSubject<TMapPolyline>()
    private var polyLineList: [TMapPolyline] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.addSubview(backgourndView)
        backgourndView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        backgourndView.addSubviews([addressStackView, tMapView])
        addressStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        addressStackView.addArrangedSubviews(views: [startAddressView, midAddressView, endAddressView ])
    }
    
    private func configureUI() {
        selectionStyle = .none
    }
    
    func setContent(courseList: [Course]) {
        self.courseList = courseList
        let lastIndex = courseList.count - 1
        startAddressView.addressTextField.text = courseList[0].address
        endAddressView.addressTextField.text = courseList[lastIndex].address
        courseList.count == 3 ? (midAddressView.addressTextField.text = courseList[1].address) : (midAddressView.isHidden = true)
    }
}

extension PostLocationTVC {
    
    private func bindToMapView(){
        polyLineSubjuect.bind(onNext: { polyLine in
            polyLine.strokeColor = .mainBlue
            self.polyLineList.append(polyLine)
            polyLine.map = self.tMapView
            self.checkDrawingPolyLine()
        }).disposed(by: disposeBag)
    }

    
    private func checkDrawingPolyLine() {
        if polyLineList.count == courseList.count - 1 {
            DispatchQueue.main.async {
                self.tMapView.fitMapBoundsWithPolylines(self.polyLineList)
            }
        }
    }
    
    private func addPathInMapView(){
        let pathData = TMapPathData()
        polyLineList = []
        print("count = \(courseList.count)")
        for index in 0..<courseList.count-1 {
            pathData.findPathData(startPoint: courseList[index].getPoint(),
                                  endPoint: courseList[index+1].getPoint()) { result, error in
                guard let polyLine = result else {return}
                self.polyLineSubjuect.onNext(polyLine)
            }
        }
    }
    
    private func addMarkerInMapView(){
        for index in 0..<courseList.count {
            let marker = TMapMarker(position: courseList[index].getPoint())
            if index == 0 {
                marker.icon = ImageLiterals.icRouteStart
            }else if index == courseList.count - 1{
                marker.icon = ImageLiterals.icRouteEnd
            }else{
                marker.icon = ImageLiterals.icRouteWaypoint
            }
            marker.map = self.tMapView
        }
    }
}

extension PostLocationTVC: TMapViewDelegate {
    func mapViewDidFinishLoadingMap() {
        bindToMapView()
        addPathInMapView()
        addMarkerInMapView()
        tMapView.snp.makeConstraints {
            $0.top.equalTo(addressStackView.snp.bottom)
            $0.leading.equalToSuperview().offset(9)
            $0.trailing.equalToSuperview().offset(-9)
            $0.bottom.equalToSuperview().inset(15)
        }
    }
}


