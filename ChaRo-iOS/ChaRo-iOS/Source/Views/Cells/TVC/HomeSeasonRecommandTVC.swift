//
//  HomeSeasonRecommandTVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/06.
//

import UIKit

class HomeSeasonRecommandTVC: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    
    
    //MARK:- Variable
    static let identifier = "HomeSeasonRecommandTVC"
    
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollctionView()
        setLabelUI()
    }
    
    //MARK:- default Setting Function Part
    func setCollctionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCustomXib(xibName: "CommonCVC")
        
    }
    
    func setLabelUI() {
        
        TitleLabel.text = "여름맞이 야간 드라이브"
        moreLabel.text = "더보기"
        
        //TitleLabel.font = UIFont.notoSansBoldFont(ofSize: 17)
        //moreLabel.font = UIFont.notoSansRegularFont(ofSize: 12)
        
        TitleLabel.textColor = UIColor.mainBlack
        moreLabel.textColor = UIColor.gray40
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    //MARK:- Function
    
}

//MARK:- extension

extension HomeSeasonRecommandTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCVC", for: indexPath) as? CommonCVC else { return UICollectionViewCell() }
        
        cell.imageView.image = UIImage(named: "tempImageSmall")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 2 - 20
        let size = CGSize(width: width, height: 250)
        
        //이거 사이즈를 11pro, se2 - 250 딱맞고 se1 에서 - 230이 딱맞고
        //해상도 따라 해주기
        
        return size
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    
}
