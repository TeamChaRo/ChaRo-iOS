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
    @IBOutlet weak var carMoveConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeAnimationView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//MARK: delegate
    func setDelegate(){
        animationCollectionview.delegate = self
        animationCollectionview.dataSource = self
        animationCollectionview.isPagingEnabled = true
        let flowLayout = animationCollectionview.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .horizontal
        animationCollectionview.registerCustomXib(xibName: "HomeAnimationCVC")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//여기부분 약간 수정해야됨,,, 기기마다 몬가 값이 다 다를거같아서 일단 보류!
        let userWidth = homeAnimationView.getDeviceWidth()
        let originalCarConstant = carMoveConstraint.constant

        if scrollView.contentOffset.x > 0{
               if scrollView.contentOffset.x < 10000 {
                carMoveConstraint.constant = (scrollView.contentOffset.x - 24)/4
               } else {
                carMoveConstraint.constant = originalCarConstant
               }
           }
        else{
            carMoveConstraint.constant = originalCarConstant
           }

       }
}

extension HomeAnimationTVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let homeAnimationCVC = collectionView.dequeueReusableCell(withReuseIdentifier: HomeAnimationCVC.identifier, for: indexPath) as? HomeAnimationCVC else {return UICollectionViewCell()}
        
        homeAnimationCVC.setData(imageName: "dummyMain", titleText: "차로와 함께 즐기는 드라이브 코스", hashTagText: "#날씨도좋은데 #바다와함께라면")
        return homeAnimationCVC
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
