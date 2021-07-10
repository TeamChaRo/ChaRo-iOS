//
//  PostPathmapTCV.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/09.
//

import UIKit
import SnapKit
import TMapSDK

class PostPathmapTCV: UITableViewCell {

    static let identifier: String = "PostPathmapTCV"
    
    var postMap = MapService.getTmapView()
    
    let multiplier: CGFloat = 395/335
    let mapWidth: CGFloat = UIScreen.main.bounds.width - 40
    
    let mapViewContainerView: UIView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension PostPathmapTCV {

    func configureLayout(){
        addSubview(mapViewContainerView)
        
        mapViewContainerView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(23)
//            $0.leading.equalTo(self.snp.leading).offset(20)
//            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.centerX.equalTo(self.snp.centerX)
            $0.bottom.equalTo(self.snp.bottom).inset(33)
            $0.width.equalTo(postMap)
            $0.height.equalTo(self.mapViewContainerView.snp.width).multipliedBy(multiplier)
        }
        
        setMapView()
    }
    
    func setMapView(){
        mapViewContainerView.addSubview(postMap)
        postMap.frame = mapViewContainerView.frame
    }
    
}

