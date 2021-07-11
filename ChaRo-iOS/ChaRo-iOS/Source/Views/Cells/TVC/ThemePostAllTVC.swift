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
    
    //MARK:- Function
}

//MARK:- extension

extension ThemePostAllTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return 10

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: indexPath) as? CommonCVC else { return UICollectionViewCell() }
        
        cell.imageView.image = UIImage(named: "tempImageBig")
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.layer.cornerRadius = 10
        cell.titleLabel.font = .notoSansBoldFont(ofSize: 17)
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
