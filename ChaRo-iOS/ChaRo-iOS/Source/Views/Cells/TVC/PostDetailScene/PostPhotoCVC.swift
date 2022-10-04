//
//  PostPhotoCVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/16.
//

import UIKit
import SnapKit
import Then

final class PostPhotoCVC: UICollectionViewCell{
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContraints() {
        addSubview(imageView)
        imageView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        setupGesture()
    }
    
    func setImage(to imgString: String) {
        imageView.kf.setImage(with: URL(string: imgString))
    }
    
    func setImage(to image: UIImage) {
        imageView.image = image
    }
    
    private func setupGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(gesture:)))
        self.contentView.addGestureRecognizer(pinchGesture)
    }
    
    @objc
    private func handlePinchGesture(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .changed:
            imageView.transform = imageView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1
        case .ended:
            imageView.transform = CGAffineTransform.identity
        default: print("")
        }
    }
    
}
