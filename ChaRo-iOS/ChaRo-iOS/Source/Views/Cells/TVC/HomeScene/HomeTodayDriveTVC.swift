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
    @IBOutlet weak var todayDriveLabel: UILabel!
    
    //MARK:- Variable
    static let identifier = "HomeTodayDriveTVC"
    
    var todayDriveList: [DriveElement] = []
    var postDelegate: PostIdDelegate?
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollctionView()
        setLabelUI()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        collectionView.reloadData()
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
        todayDriveLabel.text = "차로의 '오늘 드라이브'"
        
        charoPickLabel.textColor = UIColor.mainBlue
        todayDriveLabel.textColor = UIColor.mainBlack
        
        charoPickLabel.font = UIFont.notoSansRegularFont(ofSize: 13)
        todayDriveLabel.font = UIFont.notoSansBoldFont(ofSize: 17)
    }
    //MARK:- Function
}


//MARK:- extension

extension HomeTodayDriveTVC: UICollectionViewDelegate ,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayDriveList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CommonCVC else { return }
        postDelegate?.sendPostDetail(with: cell.postID)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: indexPath) as? CommonCVC else { return UICollectionViewCell() }
    
            
            let element = todayDriveList[indexPath.row]
        var tags = [element.region, element.theme,
                    element.warning ?? ""] as [String]
                    
        
        cell.setData(image: element.image,
                     title: element.title,
                     tagCount: tags.count,
                     tagArr: tags,
                     isFavorite: element.isFavorite,
                     postID: element.postID)
    
            return cell
            
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 260, height: 256)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCVC", for: indexPath) as? CommonCVC
        cell!.imageView.kf.cancelDownloadTask()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 16
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let factor = UIScreen.main.bounds.width / 375
        
        if section == 0 {
            return UIEdgeInsets(top: -5 * factor, left: 20, bottom: 0, right: 20)
               }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
    }



    
}

