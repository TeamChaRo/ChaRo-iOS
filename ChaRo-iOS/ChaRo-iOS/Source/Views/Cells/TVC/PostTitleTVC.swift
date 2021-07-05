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
        setFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setFont(){
        postTitleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        userNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        postDateLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    func setTitle(title: String, userName: String, date: String, imageName: String, likedCount: String) {
        postTitleLabel.text = title
        userNameLabel.text = userName
        postDateLabel.text = date
        likedCountLabel.text = likedCount
        if let image = UIImage(named: imageName) {
            profileImageView.layer.masksToBounds = true
            profileImageView.image = image
            profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.0
        }
    }
    
}
