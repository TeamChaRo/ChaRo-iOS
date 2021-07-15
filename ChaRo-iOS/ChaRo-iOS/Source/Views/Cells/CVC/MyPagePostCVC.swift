//
//  MyPagePostCVC.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/07/11.
//

import UIKit

class MyPagePostCVC: UICollectionViewCell {
    //titleLable 30자까지
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    
    //TAG뷰~
    @IBOutlet weak var tagView1: UIView!
    @IBOutlet weak var tagLabel1: UILabel!
    @IBOutlet weak var tagView2: UIView!
    @IBOutlet weak var tagLabel2: UILabel!
    @IBOutlet weak var tagView3: UIView!
    @IBOutlet weak var tagLabel3: UILabel!
    
    //하트랑 세이브 ㅋ.ㅋ.ㅋ.ㅋ
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var heartLabel: UILabel!
    @IBOutlet weak var saveImage: UIImageView!
    @IBOutlet weak var saveLabel: UILabel!
    //데이트 ㅋ
    @IBOutlet weak var dateLabel: UILabel!
    var postid:Int = 0
    
    var heartText: String = "99"
    var saveText: String = "99"
    
    
    func setRound(){
        postImage.clipsToBounds = true
        postImage.layer.cornerRadius = 10
    }
    func setLabelUI() {
        tagLabel1.font = UIFont.notoSansRegularFont(ofSize: 10)
        tagLabel2.font = UIFont.notoSansRegularFont(ofSize: 10)
        tagLabel3.font = UIFont.notoSansRegularFont(ofSize: 10)

        tagLabel1.textColor = UIColor.mainBlue
        tagLabel2.textColor = UIColor.mainBlue
        tagLabel3.textColor = UIColor.mainBlue
    }
    
    func setLikeUI(){
        heartImage.image = UIImage(named: "icHeartActive")
        saveImage.image = UIImage(named: "icSaveActive")
        heartLabel.text = heartText
        saveLabel.text = saveText
    }
    
    func setHeartSave(heart: String, save: String){
        heartLabel.text = heart
        saveLabel.text = save
    }
    func setLikeLabel(){
        saveLabel.textColor = .gray40
        heartLabel.textColor = .gray40
        saveLabel.font = UIFont.notoSansRegularFont(ofSize: 11)
        heartLabel.font = UIFont.notoSansRegularFont(ofSize: 11)
    }
    
    func setTagUI() {
        
        let length1 = CGFloat(tagLabel1.text!.count)
        let length2 = CGFloat(tagLabel2.text!.count)
        let length3 = CGFloat(tagLabel3.text!.count)
    
        
        tagView1.translatesAutoresizingMaskIntoConstraints = false
        tagView2.translatesAutoresizingMaskIntoConstraints = false
        tagView3.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            tagView1.widthAnchor.constraint(equalToConstant: 11 * length1),
            tagView2.widthAnchor.constraint(equalToConstant: 11 * length2),
            tagView3.widthAnchor.constraint(equalToConstant: 11 * length3)
            
        ])
        
        
        tagView1.layer.cornerRadius = 10
        tagView2.layer.cornerRadius = 10
        tagView3.layer.cornerRadius = 10
        
        tagView1.layer.borderColor = UIColor.mainBlue.cgColor
        tagView2.layer.borderColor = UIColor.mainBlue.cgColor
        tagView3.layer.borderColor = UIColor.mainBlue.cgColor
        
        tagView1.layer.borderWidth = 1
        tagView2.layer.borderWidth = 1
        tagView3.layer.borderWidth = 1
    }
    
    func setTitleLabel(text: String){
        postTitle.text = text
    }
    
    func setData(image: String, title: String, tagCount: Int, tagArr: [String], heart: Int , save: Int, year: String, month: String, day: String, postID: Int) {
        
        //이미지 설정
        guard let url = URL(string: image) else { return }
        self.postImage.kf.setImage(with: url)
        
        //postID 설정
        self.postid = postID
        
        //제목 설정
        self.postTitle.text = title
        
        //태그 설정
        if tagCount == 2 {
            tagLabel1.text = ""
            tagLabel2.text = ""
            tagLabel3.text = ""
            
            tagLabel1.text = "#\(tagArr[0])"
            tagLabel2.text = "#\(tagArr[1])"
            tagLabel3.text = ""
            
        } else {
            tagLabel1.text = "#\(tagArr[0])"
            tagLabel2.text = "#\(tagArr[1])"
            tagLabel3.text = "#\(tagArr[2])"
        }
        //하트 수 및 저장 수
        self.heartLabel.text = String(heart)
        self.saveLabel.text = String(save)
        //날짜
        self.dateLabel.text = "\(year).\(month).\(day)"

        setTagUI()
        setLabelUI()
    }
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setRound()
        setLikeLabel()
        setLikeUI()
        
    }

}
