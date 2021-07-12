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

class ThemePostAllTVC: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Variable
    static let identifier = "ThemePostAllTVC"
    var cellDelegate: ThemeCollectionViewCellDelegate?
    var selectedDriveList: [Drive] = [Drive(postId: 1, title: "해운대 드라이브 코스. 달맞이길 추천 플러스 조개구이까지", image: "https://charo-server.s3.ap-northeast-2.amazonaws.com/post/1625761886665.jpg", isFavorite: true, tags: ["부산", "여름"])]
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellCount
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: indexPath) as? CommonCVC else { return UICollectionViewCell() }
        
        cell.imageView.image = UIImage(named: "tempImageBig")
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.layer.cornerRadius = 10
        
        cell.titleLabel.font = .notoSansBoldFont(ofSize: 17)
        
        
        let element = selectedDriveList[indexPath.row]
        
        print("PostAllTVC에서 collectionView 설정 시 cell count : \(cellCount)")
        cell.titleLabel.text = element.title
        
        if element.isFavorite == true {
            print("트루다")
            cell.heartButton.setImage(UIImage(named: "heart_active"), for: .normal) 
        }
           
        
        cell.lengthBtwImgLabel.constant = 0
        
        return cell

        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 335, height: 260)
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 28
    }
    

    
    
    
}
