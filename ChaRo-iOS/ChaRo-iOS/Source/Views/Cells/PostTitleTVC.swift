//
//  PostTitleTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/05.
//

import UIKit

class PostTitleTVC: UITableViewCell {

    static let identifier: String = "PostTitleTVC"
    
    // MARK: - Outlet Variables
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var likedImageView: UIImageView!
    @IBOutlet weak var likedCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setTitle(title: String, userName: String, date: String, imageName: String, likedCount: String) {
        postDateLabel.text = title
        userNameLabel.text = userName
        postDateLabel.text = date
        likedCountLabel.text = likedCount
        if let image = UIImage(named: imageName) {
            profileImageView.image = image
        }
    }
    
}
