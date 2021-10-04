//
//  HomeAnimationTVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/02.
//

import UIKit

class HomeAnimationTVC: UITableViewCell {

    @IBOutlet weak var animationCollectionview: UICollectionView!
    static let identifier : String = "HomeAnimationTVC"
//    @IBOutlet weak var carMoveConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeAnimationView: UIView!
    
    public static var collectionIndexPath: IndexPath = [0,0]
    
    var animationCell: [HomeAnimationCVC] = []
    
    var bannerList: [Banner] = []
//    var imageNameText: [String] = []
//    var titleText: [String] = []
//    var hashTagText: [String] = []
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    
    //MARK: - 이게 몰까?
//    func cellInit() {
//        guard let cell1 = animationCollectionview.dequeueReusableCell(withReuseIdentifier: HomeAnimationCVC.identifier, for: [0,0]) as? HomeAnimationCVC else {return}
//        guard let cell2 = animationCollectionview.dequeueReusableCell(withReuseIdentifier: HomeAnimationCVC.identifier, for: [0,1]) as? HomeAnimationCVC else {return}
//        guard let cell3 = animationCollectionview.dequeueReusableCell(withReuseIdentifier: HomeAnimationCVC.identifier, for: [0,2]) as? HomeAnimationCVC else {return}
//        guard let cell4 = animationCollectionview.dequeueReusableCell(withReuseIdentifier: HomeAnimationCVC.identifier, for: [0,3]) as? HomeAnimationCVC else {return}
//        animationCell.append(cell1)
//        animationCell.append(cell2)
//        animationCell.append(cell3)
//        animationCell.append(cell4)
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        animationCollectionview.reloadData()

        // Configure the view for the selected state
    }
    
   
//    func setData(imageName: String, title: String, tag: String){
//        imageNameText.append(imageName)
//        titleText.append(title)
//        hashTagText.append(tag)
//    }
    
    func setBannerList(inputList: [Banner]) {
        self.bannerList = inputList
    }
    
//MARK: delegate
    func setDelegate(){
        animationCollectionview.delegate = self
        animationCollectionview.dataSource = self
        animationCollectionview.isPagingEnabled = true
        let flowLayout = animationCollectionview.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .horizontal
        animationCollectionview.registerCustomXib(xibName: "HomeAnimationCVC")
        //cellInit()
    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////여기부분 약간 수정해야됨,,, 기기마다 몬가 값이 다 다를거같아서 일단 보류!
//        let originalCarConstant = carMoveConstraint.constant
//        let sideMargin : CGFloat = 24
//        let pageCount : Int = 4
//
//        if scrollView.contentOffset.x > 0{
//               if scrollView.contentOffset.x < 10000 {
//                carMoveConstraint.constant = (scrollView.contentOffset.x - sideMargin)/CGFloat(pageCount)
//               } else {
//                carMoveConstraint.constant = originalCarConstant
//               }
//           }
//        else{
//            carMoveConstraint.constant = originalCarConstant
//           }
//
//       }
}


//MARK: - extension
extension HomeAnimationTVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //도저언 !
        
        HomeAnimationTVC.collectionIndexPath = indexPath
        
        guard let cell = animationCollectionview.dequeueReusableCell(withReuseIdentifier: HomeAnimationCVC.identifier, for: indexPath) as? HomeAnimationCVC else { return UICollectionViewCell() }

        let element = bannerList[indexPath.row]
        
            cell.setData(image: element.bannerImage
                         ,title: element.bannerTitle
                         ,tagText: element.bannerTag)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let deviceWidth = homeAnimationView.getDeviceWidth()
        let deviceHeigth = homeAnimationView.getDeviceHeight()
        //*0.63이더라 비율 + 50 ㅋ ㅋ
        let cellHeight = Double(deviceHeigth) * 0.7
        print(cellHeight, Int(cellHeight))
        return CGSize(width: deviceWidth, height: Int(cellHeight))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

