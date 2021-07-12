//
//  CreatePostPhotoTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/12.
//

import UIKit

class CreatePostPhotoTVC: UITableViewCell {

    static let identifier: String = "CreatePostPhotoTVC"
    
    // MARK: UI Components
    let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "writeEmptyImage")
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let collectionView: UICollectionView = UICollectionView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
}

extension CreatePostPhotoTVC {
    // MARK: Functions
    func setCollcetionView(){
        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.registerCustomXib(xibName: CreatePostPhotosCVC.identifier)
        
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: Layout
    func emptyConfigureLayout(){
        addSubview(emptyImageView)
        
        emptyImageView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.bottom.equalTo(self.snp.bottom).inset(33)
        }
    }
}

extension CreatePostPhotoTVC : UICollectionViewDelegate {
    
}

//extension CreatePostPhotoTVC : UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        <#code#>
////    }
////
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        <#code#>
////    }
//}

extension CreatePostPhotoTVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 107, height: 107)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
