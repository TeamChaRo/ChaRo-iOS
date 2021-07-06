//
//  HomeTodayDriveTVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/04.
//

import UIKit

class HomeTodayDriveTVC: UITableViewCell {

    
    //MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var charoPickLabel: UILabel!
    @IBOutlet weak var TodayDriveLabel: UILabel!
    
    //MARK:- Variable
    static let identifier = "HomeTodayDriveTVC"
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollctionView()
        setLabelUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    //MARK:- default Setting Function Part
    func setCollctionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCustomXib(xibName: "CommonCVC")
        
        collectionView.showsHorizontalScrollIndicator = false
    
    }

    func setLabelUI() {
        
        charoPickLabel.text = "이번주 차로'S PICK"
        TodayDriveLabel.text = "차로의 '오늘 드라이브'"
        
        charoPickLabel.textColor = UIColor.mainBlue
        TodayDriveLabel.textColor = UIColor.mainBlack
        
        
        //charoPickLabel.font = UIFont.notoSansRegularFont(ofSize: 13)
        //TodayDriveLabel.font = UIFont.notoSansBoldFont(ofSize: 17)
        
    }
    
    //MARK:- Function
    
}


//MARK:- extension

extension HomeTodayDriveTVC: UICollectionViewDelegate ,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCVC", for: indexPath) as? CommonCVC else { return UICollectionViewCell() }
    
        cell.imageView.image = UIImage(named: "tempImageBig")
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //나중에 바꿀예정 ..
        return CGSize(width: 260, height: 256)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
    }
    
    
}
