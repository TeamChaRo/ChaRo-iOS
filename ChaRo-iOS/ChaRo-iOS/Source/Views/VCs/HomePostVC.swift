//
//  HomePostVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/07.
//

import UIKit

class HomePostVC: UIViewController {
    @IBOutlet weak var NavigationTitleLabel: UILabel!
    @IBOutlet weak var homePostNavigationView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellCount = 6
    
    static let identifier : String = "HomePostVC"
    
    func setTableView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCustomXib(xibName: "CommonCVC")
        collectionView.registerCustomXib(xibName: "HomePostDetailCVC")
    }
    func setShaow(){
        homePostNavigationView.getShadowView(color: UIColor.black.cgColor, masksToBounds: false, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8, shadowOpacity: 0.3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setShaow()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomePostVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCVC", for: indexPath) as? CommonCVC else { return UICollectionViewCell() }
        
        guard let topCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePostDetailCVC", for: indexPath) as? HomePostDetailCVC else {return UICollectionViewCell()}
        
        switch indexPath.row {
        case 0:
            topCell.setLabel()
            return topCell
        default:
            cell.imageView.image = UIImage(named: "tempImageBig.png")
            return cell
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let Cellwidth = UIScreen.main.bounds.width - 40
        
        switch indexPath.row {
        case 0:
            return CGSize(width: Cellwidth, height: 55)
        default:
            return CGSize(width: Cellwidth, height: 260)
        
        }
   
        //나중에 바꿀예정 ..
        
    }
    
    
}
