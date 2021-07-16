//
//  CommonCVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/04.
//

import UIKit

class CommonCVC: UICollectionViewCell {

    //MARK: IBOutlet
    static let identifier = "CommonCVC"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    

    @IBOutlet weak var tagView1: UIView!
    @IBOutlet weak var tagView2: UIView!
    @IBOutlet weak var tagView3: UIView!
    
    @IBOutlet weak var tagLabel1: UILabel!
    @IBOutlet weak var tagLabel2: UILabel!
    @IBOutlet weak var tagLabel3: UILabel!
    
    @IBOutlet weak var lengthBtwImgLabel: NSLayoutConstraint!
  
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var heartButton: UIButton!
    
    var taglist :[String] = []

    //MARK: Variable
    var callback : (() -> Void)?
    var postID: Int = 1
    var isFavorite: Bool? {
        didSet {
            if isFavorite == true {
                heartButton.setImage(UIImage(named: "heart_active"), for: .normal)
            } else {
                heartButton.setImage(UIImage(named: "icHeartWhiteLine"), for: .normal)
            }
        }
    }
    
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setLabelUI()
        print("awakeFromNib = \(taglist)")
    }

    
    
    //MARK:- default Setting Function Part
    func setLabelUI() {
        titleLabel.font = UIFont.notoSansRegularFont(ofSize: 14)
        tagLabel1.font = UIFont.notoSansRegularFont(ofSize: 10)
        tagLabel2.font = UIFont.notoSansRegularFont(ofSize: 10)
        tagLabel1.textColor = UIColor.mainBlue
        tagLabel2.textColor = UIColor.mainBlue
        
    }
    
    func setTagUI(taglist: [String]) {
        print("-----------------------")
        print(taglist)
        print("-----------------------")
        tagView1.layer.cornerRadius = 10
        tagView2.layer.cornerRadius = 10
       
        tagView1.layer.borderColor = UIColor.mainBlue.cgColor
        tagView2.layer.borderColor = UIColor.mainBlue.cgColor
        
        tagView1.layer.borderWidth = 1
        tagView2.layer.borderWidth = 1
    
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        
        let length1 = CGFloat(tagLabel1.text!.count)
        let length2 = CGFloat(tagLabel2.text!.count)
        let length3 = CGFloat(tagLabel3.text!.count)
    
        
        tagView1.translatesAutoresizingMaskIntoConstraints = false
        tagView2.translatesAutoresizingMaskIntoConstraints = false
        tagView3.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            tagView1.widthAnchor.constraint(equalToConstant: 13 * length1),
            tagView2.widthAnchor.constraint(equalToConstant: 13 * length2),
            tagView3.widthAnchor.constraint(equalToConstant: 13 * length3)
            
        ])
        
        if taglist.count == 3 {
            stackView.arrangedSubviews[2].isHidden = false
            tagView3.isHidden = false
            tagView3.layer.cornerRadius = 10
            tagView3.layer.borderColor = UIColor.mainBlue.cgColor
            tagView3.layer.borderWidth = 1
            tagLabel3.font = UIFont.notoSansRegularFont(ofSize: 10)
            tagLabel3.textColor = UIColor.mainBlue
            tagLabel3.isHidden = false
        }else {
            stackView.arrangedSubviews[2].isHidden = true
            tagView3.isHidden = true
            tagLabel3.isHidden = true
            tagLabel3.textColor = .clear
        }
        
        
    }
    
    

    //MARK:- Function
    
//    //setData 익범이꺼
//    func setData(image: String, title: String, tag1: String, tag2: String, tag3: String, hearth: Bool){
//
//        imageView.kf.setImage(with: URL(string: image))
//
//        titleLabel.text = title
//        tagLabel1.text = tag1
//        tagLabel2.text = tag2
//        tagLabel3.text = tag3
//
//        setTagUI()
//        setLabelUI()
//
//
        //킹피셔 받아서 이거 처리해야됨
//    }
    
    
    
    //setData 지원이꺼
    func setData(image: String, title: String, tagCount: Int, tagArr: [String], isFavorite: Bool, postID: Int) {
        
        taglist = tagArr
        
        setTagUI(taglist: tagArr)
        setLabelUI()
        
        tagLabel1.text = ""
        tagLabel2.text = ""
        tagLabel3.text = ""
        
        if tagArr.count == 3{
            tagLabel1.text = "#\(tagArr[0])"
            tagLabel2.text = "#\(tagArr[1])"
            tagLabel3.textColor = .mainBlue
            tagLabel3.text = "#\(tagArr[2])"
        }else{
            
            tagLabel1.text = "#\(tagArr[0])"
            tagLabel2.text = "#\(tagArr[1])"
            tagLabel3.textColor = .clear
        }
            
        //이미지 설정
        guard let url = URL(string: image) else { return }
        self.imageView.kf.setImage(with: url)
        
        //postID 설정
        self.postID = postID
        
        //제목 설정
        self.titleLabel.text = title
        if titleLabel.numberOfLines == 2{
            titleHeight.constant == 25
        }
        else{
            titleHeight.constant = 50
        }
        
        //하트 설정
        self.isFavorite = isFavorite
        
        //태그 설정
        
    }
    
    func likeAction()
    {
        LikeService.shared.Like(userId: "jieun1211", postId: self.postID) { [self] result in
            
            switch result
            {
            case .success(let success):
                
                if let success = success as? Bool {
                    if success {
                        isFavorite = !isFavorite!
                    }
                }
                
                
            case .requestErr(let msg):
                
                if let msg = msg as? String {
                    print(msg)
                }
                
                
            default :
                print("ERROR")
            }
        }
    }
    
//    func setHeartButton() {
//
//        let emptyHeartImage = UIImage(named: "icHeartWhiteLine")
//        let fullHeartImage = UIImage(named: "heart_active")
//
//        if self.heartButton.currentImage == emptyHeartImage {
//            self.heartButton.setImage(fullHeartImage, for: .normal)
//        } else {
//            self.heartButton.setImage(emptyHeartImage, for: .normal)
//        }
//
//    }
    
    
    //MARK:- IBAction
    
    @IBAction func heartButtonClicked(_ sender: UIButton) {
        likeAction()
    }
    
    
}

//MARK:- extension
