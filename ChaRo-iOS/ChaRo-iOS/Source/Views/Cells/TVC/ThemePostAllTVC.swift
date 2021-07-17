//
//  ThemePostAllTVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/08.
//

import UIKit

protocol ThemeCollectionViewCellDelegate: class {
    func collectionView(collectionviewcell: HomePostDetailCVC?, index: Int, didTappedInTableViewCell: ThemePostAllTVC, button: UIButton!)
}

protocol PostIdDelegate {
    func sendPostID(data: Int)
}

class ThemePostAllTVC: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Variable
    static let identifier = "ThemePostAllTVC"
    var cellDelegate: ThemeCollectionViewCellDelegate?
    var postDelegate: PostIdDelegate?
    var selectedDriveList: [Drive] = []
    private var cellCount = 0
    
    //MARK:- Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        collectionView.delegate = self
        collectionView.dataSource = self
    
        collectionView.registerCustomXib(xibName: CommonCVC.identifier)
        collectionView.registerCustomXib(xibName: HomePostDetailCVC.identifier)
        collectionView.registerCustomXib(xibName: EmptyCVC.identifier)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    //MARK:- default Setting Function Part
    
    func setCellCount(num: Int) {
        cellCount = num
    }
    
    //MARK:- Function
}

//MARK:- extension

extension ThemePostAllTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return cellCount
        case 1:
            return 1
        default:
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: indexPath) as? CommonCVC else { return UICollectionViewCell() }
            
            cell.imageView.contentMode = .scaleAspectFill
            cell.imageView.layer.cornerRadius = 10
            cell.lengthBtwImgLabel.constant = 0
        
            
            //요소 변수화
            let element = selectedDriveList[indexPath.row]
            
            cell.setData(image: element.image, title: element.title, tagCount: element.tags.count, tagArr: element.tags, isFavorite: element.isFavorite, postID: element.postID)
            
            cell.titleLabel.font = .notoSansBoldFont(ofSize: 17)
            
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCVC.identifier, for: indexPath) as? EmptyCVC else { return UICollectionViewCell() }
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? CommonCVC
        let postid = cell!.postID
        postDelegate?.sendPostID(data: postid)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let factor = UIScreen.main.bounds.width / 375
        
        switch indexPath.section {
        case 0:
            return CGSize(width: 335 * factor, height: 260 * factor)
        case 1:
            return CGSize(width: self.getDeviceWidth(), height: 30)
        default:
            return CGSize(width: 0, height: 0)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 28
    }
    
    
    
    

    
    
    
}
