//
//  HomeSquareTVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/04.
//

import UIKit

protocol IsSelectedCVCDelegate{
    func isSelectedCVC(indexPath : IndexPath)
}

protocol SeeMorePushDelegate{
    func seeMorePushDelegate(data : Int)
}

class HomeSquareTVC: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    var delegate: IsSelectedCVCDelegate?
    var ButtonDelegate: SeeMorePushDelegate?
    var postDelegate: PostIdDelegate?
    let cellTag : Int = 3
//
//    var imageNameText: [String] = []
//    var titleText: [String] = []
//    var hashTagText1: [String] = []
//    var hashTagText2: [String] = []
//    var hashTagText3: [String] = []
//    var hashTagText4: [String] = []
//    var heart: [Bool] = []
//
//    var cellList: [CommonCVC] = []
    var trendyDriveList: [DriveElement] = []
    
    //MARK:- Variable
    static let identifier = "HomeSquareTVC"
    
   
//    func cellInit(){
//            guard let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: [0,0]) as? CommonCVC else {return}
//            guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: [0,1]) as? CommonCVC else {return}
//            guard let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: [0,2]) as? CommonCVC else {return}
//            guard let cell4 = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: [0,3]) as? CommonCVC else {return}
//
//
//        cellList.append(cell1)
//        cellList.append(cell2)
//        cellList.append(cell3)
//        cellList.append(cell4)
//    }
//
    
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollctionView()
        setLabelUI()
    //    cellInit()
    }
    
    //MARK:- default Setting Function Part
    func setCollctionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCustomXib(xibName: "CommonCVC")
        
    }
    
    func setLabelUI() {
        
        TitleLabel.text = "요즘 뜨는 드라이브 코스"
        moreLabel.text = "더보기"
        
        TitleLabel.font = UIFont.notoSansBoldFont(ofSize: 17)
        moreLabel.font = UIFont.notoSansRegularFont(ofSize: 12)
        
        
        TitleLabel.textColor = UIColor.mainBlack
        moreLabel.textColor = UIColor.gray40
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        collectionView.reloadData()
    }
    
    @IBAction func seeMoreButtonClicked(_ sender: Any) {
        ButtonDelegate?.seeMorePushDelegate(data: cellTag)
    }
    //MARK:- Function
    
}

//MARK:- extension

extension HomeSquareTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.isSelectedCVC(indexPath: indexPath)
        
        let cell = collectionView.cellForItem(at: indexPath) as? CommonCVC
        let postid = cell!.postID
        postDelegate?.sendPostID(data: postid)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendyDriveList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: indexPath) as? CommonCVC else { return UICollectionViewCell() }
        
        
        if trendyDriveList.count == 0 {
            return cell
        }
        else {
            
            let element = trendyDriveList[indexPath.row]
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

        return cell
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let factor = UIScreen.main.bounds.width / 375
        
        let size = CGSize(width: 160 * factor, height: 230 * factor)
        
        return size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
