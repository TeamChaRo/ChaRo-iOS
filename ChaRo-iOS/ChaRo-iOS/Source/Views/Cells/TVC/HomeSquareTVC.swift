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
    var trendyDriveList: [Drive] = []
    
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
            
            cell.setData(image: element.image
                         ,title: element.title
                         ,tagCount: element.tags.count
                         ,tagArr: element.tags
                         ,isFavorite: element.isFavorite
                         ,postID: element.postID)
          
//            switch indexPath.row {
//            case 0:
//                if hashTagText1.count == 2{
//                    hashTagText1.append("")
//                }
//                cellList[0].setData(image: imageNameText[0], title: titleText[0], tag1: hashTagText1[0] , tag2: hashTagText1[1], tag3: hashTagText1[2] , hearth: heart[0])
//            case 1:
//                if hashTagText2.count == 2{
//                    hashTagText2.append("")
//                }
//                cellList[1].setData(image: imageNameText[1], title: titleText[1], tag1: hashTagText2[0] , tag2: hashTagText2[1], tag3: hashTagText2[2] , hearth: heart[1])
//            case 2:
//                if hashTagText3.count == 2{
//                    hashTagText3.append("")
//                }
//                cellList[2].setData(image: imageNameText[2], title: titleText[2], tag1: hashTagText3[0] , tag2: hashTagText3[1], tag3: hashTagText3[2] , hearth: heart[2])
//            case 3:
//                if hashTagText4.count == 2{
//                    hashTagText4.append("")
//                }
//                cellList[3].setData(image: imageNameText[3], title: titleText[3], tag1: hashTagText4[0] , tag2: hashTagText4[1], tag3: hashTagText4[2] , hearth: heart[3])
//            default:
//                print("Error")
//            }
//            return cellList[indexPath.row]
            
            return cell
            
        }
//
//        cell.callback = {
//            print("button pressed", indexPath.row)
//            }
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
