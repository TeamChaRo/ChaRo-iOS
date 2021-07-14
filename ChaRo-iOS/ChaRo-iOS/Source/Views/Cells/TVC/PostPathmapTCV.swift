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
    
    let multiplier: CGFloat = 395/335
    let mapWidth: CGFloat = UIScreen.main.bounds.width - 40

    let postMap: TMapView = TMapView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configureLayout()
        setMapView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//MARK: - AutoLayout and functions
extension PostPathmapTCV {
    
    func configureLayout(){
        addSubview(postMap)
        
        postMap.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(23)
            $0.centerX.equalTo(self.snp.centerX)
            $0.bottom.equalTo(self.snp.bottom).inset(33)
            $0.width.equalTo(mapWidth)
            $0.height.equalTo(self.postMap.snp.width).multipliedBy(multiplier)
        }
    }
    
    func setMapView(){
        postMap.setApiKey(MapService.mapkey)
        postMap.isPanningEnable = false // 드래그 불가
        postMap.isZoomEnable = false // 확대축소 불가
    }
    
}

