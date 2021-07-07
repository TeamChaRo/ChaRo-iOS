//
//  HomePostTVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/07.
//

import UIKit

class HomePostTVC: UITableViewCell {
    static let identifier : String = "HomePostTVC"
    @IBOutlet weak var homePostCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCollctionView() {
        homePostCollectionView.delegate = self
        homePostCollectionView.dataSource = self
        homePostCollectionView.registerCustomXib(xibName: "CommonCVC")
        homePostCollectionView.showsHorizontalScrollIndicator = false
      }
}

extension HomePostTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //이거 변수로 받아서 하자 ㅎㅎ ㅎ ㅎ ㅎ ㅎ
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: indexPath) as? CommonCVC else { return UICollectionViewCell() }
            cell.imageView.image = UIImage(named: "tempImageBig")
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            //나중에 바꿀예정 ..
            return CGSize(width: 300, height: 256)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
    }
}
