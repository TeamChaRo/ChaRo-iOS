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
    @IBOutlet var tagButtonList: [UIButton]!
    
    //하트랑 세이브 ㅋ.ㅋ.ㅋ.ㅋ
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var heartLabel: UILabel!
    @IBOutlet weak var saveImage: UIImageView!
    @IBOutlet weak var saveLabel: UILabel!
    //데이트 ㅋ
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var seperatorBar: UIView!
    
    var postid:Int = 0
    
    var heartText: String = "99"
    var saveText: String = "99"
    var clickedPostCell : ((Int) -> ())?
    
    func setRound(){
        postImage.clipsToBounds = true
        postImage.layer.cornerRadius = 10
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
        
        //태그설정
        for index in 0..<3{
            if index > tagArr.count - 1 {
                print("\(index)에서 안그려짐")
                tagButtonList[index].setTitleColor(.clear, for: .normal)
                tagButtonList[index].layer.borderColor = UIColor.clear.cgColor
                continue
            }
            tagButtonList[index].setTitle(" #\(tagArr[index]) ", for: .normal)
            tagButtonList[index].titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 10)
            tagButtonList[index].setTitleColor(.mainBlue, for: .normal)
            tagButtonList[index].layer.cornerRadius = 9
            tagButtonList[index].layer.borderWidth = 1
            tagButtonList[index].layer.borderColor = UIColor.mainBlue.cgColor
            tagButtonList[index].contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        //하트 수 및 저장 수
        self.heartLabel.text = String(heart)
        self.saveLabel.text = String(save)
        //날짜
        self.dateLabel.text = "\(year).\(month).\(day)"

      
    }
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setRound()
        setLikeLabel()
        setLikeUI()
        
    }
    
    override var isSelected: Bool{
        didSet {
            if isSelected {
                print(postid)
                clickedPostCell?(postid)
            }
          }
    }
    
    func setLastCell() {
        seperatorBar.isHidden = true
    }

}
