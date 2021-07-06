//
//  ThemeTVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/03.
//

import UIKit

class HomeThemeTVC: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    
    //MARK:- Variable
    static let identifier = "HomeThemeTVC"
    
    
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
        collectionView.registerCustomXib(xibName: "HomeThemeCVC")
    
        
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func setLabelUI() {
        
        TitleLabel.text = "테마"
        TitleLabel.textColor = UIColor.mainBlack
        TitleLabel.font = UIFont.notoSansBoldFont(ofSize: 17)
        
    }
    
    //MARK:- Function
    
}

//MARK:- extension
extension HomeThemeTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeThemeCVC", for: indexPath) as? HomeThemeCVC else { return UICollectionViewCell() }
    
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //일단 고정
        return CGSize(width: 64, height: 90)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    
    
    
}

