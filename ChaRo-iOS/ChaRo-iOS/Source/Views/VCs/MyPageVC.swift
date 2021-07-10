//
//  MyPageVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/10.
//

import UIKit

class MyPageVC: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var customTabbar: UICollectionView!
    @IBOutlet weak var tableCollectionView: UICollectionView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderView()
        setCircleLayout()

        // Do any additional setup after loading the view.
    }
    
    func setHeaderView(){
        headerView.backgroundColor = .mainBlue
        
    }
    func setCircleLayout(){
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        profileImageButton.setBackgroundImage(UIImage(named: "camera_mypage_wth_circle.png"), for: .normal)
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageButton.clipsToBounds = true
        profileImageButton.layer.borderWidth = 0
        profileImageButton.layer.borderColor = .none
        profileImageButton.layer.masksToBounds = false
        profileImageButton.layer.cornerRadius = profileImageButton.frame.height/2
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
