//
//  CreatePostPhotosCVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/12.
//

import UIKit

class CreatePostPhotosCVC: UICollectionViewCell {

    static let identifier: String = "CreatePostPhotosCVC"
    
    // MARK: UIComponent
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        return imageView
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(ImageLiterals.icDelete, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    let plusView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.gray20.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(ImageLiterals.icWayPointPlusActive, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteButton.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    }

}

extension CreatePostPhotosCVC {
    
    // MARK: Layout
    func plusViewConfigureLayout() {
        addSubviews([plusView, plusButton])
        plusView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.height.equalTo(plusView.snp.width).multipliedBy(1) // 1:1 ratio
        }
        
        plusButton.snp.makeConstraints{
            $0.top.equalTo(plusView.snp.top).offset(30)
            $0.leading.equalTo(plusView.snp.leading).offset(30)
            $0.trailing.equalTo(plusView.snp.trailing).inset(29)
            $0.bottom.equalTo(plusView.snp.bottom).inset(29)
            $0.width.equalTo(plusButton.snp.height).multipliedBy(1)
        }
    }
    
    func configureLayout() {
        addSubviews([imageView, deleteButton])
        imageView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.height.equalTo(imageView.snp.width).multipliedBy(1)
        }
        
        deleteButton.snp.makeConstraints{
            let heightRatio: CGFloat = 36/107
            $0.top.equalTo(imageView.snp.top)
            $0.trailing.equalTo(imageView.snp.trailing)
            $0.height.equalTo(imageView.snp.height).multipliedBy(heightRatio)
            $0.width.equalTo(deleteButton.snp.height).multipliedBy(1)
        }
    }
    
    func setImageView(image: UIImage = ImageLiterals.imgPlaceholder) {
        self.imageView.image = image
    }
    
    @objc
    func deleteButtonDidTap(_ sender: UIButton) {
        NotificationCenter.default.post(name: .createPostDeletePhotoClicked, object: sender.tag)
    }
    
    @objc
    func addButtonDidTap(_ sender: UIButton) {
        NotificationCenter.default.post(name: .createPostAddPhotoClicked, object: sender.tag)
    }
    
}
