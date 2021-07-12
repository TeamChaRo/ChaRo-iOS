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
    var delegate : IsSelectedCVCDelegate?
    var buttonDelegate: SeeMorePushDelegate?
    let cellTag : Int = 4
    
    
    var imageNameText: [String] = []
    var titleText: [String] = []
    var hashTagText: [String] = []
    var heart: [Bool] = []
    
    var cellList: [CommonCVC] = []
    
    //MARK:- Variable
    static let identifier = "HomeSeasonRecommandTVC"
    
    
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
    
    func setLabelUI() {
        
        TitleLabel.text = "여름맞이 야간 드라이브"
        moreLabel.text = "더보기"
        
        TitleLabel.font = UIFont.notoSansBoldFont(ofSize: 17)
        moreLabel.font = UIFont.notoSansRegularFont(ofSize: 12)
        
        TitleLabel.textColor = UIColor.mainBlack
        moreLabel.textColor = UIColor.gray40
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none

        
        
    }
    @IBAction func seeMoreButtonClicked(_ sender: Any) {
        buttonDelegate?.seeMorePushDelegate(data: cellTag)
        collectionView.reloadData()
    }
    
    //MARK:- Function
    
}

//MARK:- extension

extension HomeSeasonRecommandTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellList.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.isSelectedCVC(indexPath: indexPath)
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
                default:
                    print("Error")
                }
            }

        return cellList[indexPath.row]
        
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
