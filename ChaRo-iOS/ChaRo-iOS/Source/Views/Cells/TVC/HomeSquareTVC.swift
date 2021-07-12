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
    let cellTag : Int = 3
    
    var imageNameText: [String] = []
    var titleText: [String] = []
    var hashTagText: [String] = []
    var heart: [Bool] = []
    
    var cellList: [CommonCVC] = []
    
    //MARK:- Variable
    static let identifier = "HomeSquareTVC"
    
   
    func cellInit(){
            guard let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: [0,0]) as? CommonCVC else {return}
            guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: [0,1]) as? CommonCVC else {return}
            guard let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: [0,2]) as? CommonCVC else {return}
            guard let cell4 = collectionView.dequeueReusableCell(withReuseIdentifier: CommonCVC.identifier, for: [0,3]) as? CommonCVC else {return}
        
        
        cellList.append(cell1)
        cellList.append(cell2)
        cellList.append(cell3)
        cellList.append(cell4)
    }
    
    
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollctionView()
        setLabelUI()
        cellInit()
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
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if imageNameText.count == 0{
                    return cellList[0]
                }
                else{
                    print(indexPath.row)
                switch indexPath.row {
                case indexPath.row:
                    cellList[indexPath.row].setData(image: imageNameText[indexPath.row], title: titleText[indexPath.row], tag1: hashTagText[indexPath.row], tag2: hashTagText[indexPath.row], tag3: hashTagText[indexPath.row], hearth: heart[0])
                    return cellList[indexPath.row]
//                case 1:
//                    cellList[1].setData(image: imageNameText[1], title: titleText[1], tag1: hashTagText[3], tag2: hashTagText[4], tag3: hashTagText[5], hearth: heart[1])
//                    return cellList[1]
//                case 2:
//                    cellList[2].setData(image: imageNameText[2], title: titleText[2], tag1: hashTagText[6], tag2: hashTagText[7], tag3: hashTagText[8], hearth: heart[2])
//                    return cellList[2]
//                case 3:
//                    cellList[3].setData(image: imageNameText[3], title: titleText[3], tag1: hashTagText[9], tag2: hashTagText[10], tag3: hashTagText[11], hearth: heart[3])
//                    return cellList[3]
                default:
                    print("Error")
                }
            }

        return cellList[indexPath.row]
        
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
