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
    
    var imageNameText: [String] = []
    var titleText: [String] = []
    var hashTagText: [String] = []
    var heart: [Bool] = []
    
    var cellList: [CommonCVC] = []
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollctionView()
        setLabelUI()
        cellInit()
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
        return cellList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(hashTagText)
        print("타이틀",titleText)
        if imageNameText.count == 0{
            return cellList[0]
        }
        else{
        switch indexPath.row {
        case indexPath.row:
            cellList[indexPath.row].setData(image: imageNameText[indexPath.row], title: titleText[indexPath.row], tag1: hashTagText[indexPath.row], tag2: hashTagText[2], tag3: hashTagText[indexPath.row], hearth: heart[indexPath.row])
            return cellList[indexPath.row]
        default:
            print("Error")
        }
    }
        return cellList[0]
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
