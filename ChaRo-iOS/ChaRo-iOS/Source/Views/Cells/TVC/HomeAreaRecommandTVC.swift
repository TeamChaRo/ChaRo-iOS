//
//  HomeAreaRecommandTVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/06.
//

import UIKit

class HomeAreaRecommandTVC: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    var delegate: IsSelectedCVCDelegate?
    var buttonDelegate: SeeMorePushDelegate?
    let cellTag : Int = 5
    //MARK:- Variable
    static let identifier = "HomeAreaRecommandTVC"
    
    
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
        
        TitleLabel.text = "경기도 드라이브 코스"
        moreLabel.text = "더보기"
        
        //TitleLabel.font = UIFont.notoSansBoldFont(ofSize: 17)
        //moreLabel.font = UIFont.notoSansRegularFont(ofSize: 12)
        
        TitleLabel.textColor = UIColor.mainBlack
        moreLabel.textColor = UIColor.gray40
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none

        
        
    }
    @IBAction func seeMoreButtonClicked(_ sender: Any) {
        buttonDelegate?.seeMorePushDelegate(data: cellTag)
    }
    
    //MARK:- Function
    
}

//MARK:- extension

extension HomeAreaRecommandTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.isSelectedCVC(indexPath: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCVC", for: indexPath) as? CommonCVC else { return UICollectionViewCell() }
        
        cell.imageView.image = UIImage(named: "tempImageSmall")

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //일단요 ... 고정..
        let width = collectionView.frame.width / 2 - 20
        
        let size = CGSize(width: width, height: 250)
        
        return size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    
}
