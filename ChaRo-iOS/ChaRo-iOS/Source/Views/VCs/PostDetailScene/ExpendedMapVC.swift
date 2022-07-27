//
//  ExpendedMapVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/07/19.
//

import UIKit

import SnapKit
import Then
import RxSwift
import TMapSDK


final class ExpendedMapVC: UIViewController {
    
    private let tmapView = TMapView()
    private let courseList: [Course]
    private let polyLineSubjuect = PublishSubject<TMapPolyline>()
    private var polyLineList: [TMapPolyline] = []
    
    private let disposeBag = DisposeBag()
    private let xmarkButton = UIButton().then {
        $0.setImage(ImageLiterals.icClose, for: .normal)
        $0.layer.cornerRadius = 48.0 / 2.0
        $0.backgroundColor = .white
        $0.drawShadow(color: .black.withAlphaComponent(0.3), opacity: 10, offset: .zero, radius: 10)
    }
    
    init(courseList: [Course]) {
        self.courseList = courseList
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        bind()
        render()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        xmarkButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    private func render() {
        view.addSubviews([tmapView, xmarkButton])
        
        xmarkButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(23)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(48)
        }
        
        tmapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    private func configUI() {
        tmapView.delegate = self
        tmapView.isUserInteractionEnabled = false
        tmapView.setApiKey(MapService.mapkey)
    }
    
}

extension ExpendedMapVC: TMapViewDelegate {
    func mapView(_ mapView: TMapView, shouldChangeFrom oldPosition: CLLocationCoordinate2D, to newPosition: CLLocationCoordinate2D) -> Bool {
        return false
    }
    
    func mapViewDidFinishLoadingMap() {
        bindToMapView()
        addPathInMapView()
        addMarkerInMapView()
        tmapView.sizeToFit()
        tmapView.layoutIfNeeded()
        tmapView.isUserInteractionEnabled = true
    }
}


//MARK: - map 그리는데 사용하는 함수들
extension ExpendedMapVC {
    
    private func bindToMapView() {
        polyLineSubjuect.bind(onNext: { polyLine in
            polyLine.strokeColor = .mainBlue
            self.polyLineList.append(polyLine)
            polyLine.map = self.tmapView
            self.checkDrawingPolyLine()
        }).disposed(by: disposeBag)
    }

    private func checkDrawingPolyLine() {
        if polyLineList.count == courseList.count - 1 {
            DispatchQueue.main.async {
                self.tmapView.fitMapBoundsWithPolylines(self.polyLineList)
            }
        }
    }
    
    private func addPathInMapView() {
        let pathData = TMapPathData()
        polyLineList = []
        for index in 0..<courseList.count-1 {
            pathData.findPathData(startPoint: courseList[index].getPoint(),
                                  endPoint: courseList[index+1].getPoint()) { result, error in
                guard let polyLine = result else {return}
                self.polyLineSubjuect.onNext(polyLine)
            }
        }
    }
    
    private func addMarkerInMapView() {
        for index in 0..<courseList.count {
            let marker = TMapMarker(position: courseList[index].getPoint())
            if index == 0 {
                marker.icon = ImageLiterals.icRouteStart
            } else if index == courseList.count - 1 {
                marker.icon = ImageLiterals.icRouteEnd
            } else {
                marker.icon = ImageLiterals.icRouteWaypoint
            }
            marker.map = self.tmapView
        }
    }
    
}
