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
    
    @IBOutlet var tagButtonList: [UIButton]!
    
    @IBOutlet weak var lengthBtwImgLabel: NSLayoutConstraint!
  
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var heartButton: UIButton!
    
    var taglist :[String] = []

    //MARK: Variable
    var callback : (() -> Void)?
    var postID: Int = 1
    var isFavorite = false
//    var isFavorite: Bool? {
//        didSet {
//            if isFavorite! {
//                heartButton.setImage(UIImage(named: "heart_active"), for: .normal)
//            } else {
//                heartButton.setImage(UIImage(named: "icHeartWhiteLine"), for: .normal)
//            }
//        }
//    }
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    //setData 지원이꺼
    func setData(image: String,
                 title: String,
                 tagCount: Int,
                 tagArr: [String],
                 isFavorite: Bool,
                 postID: Int) {
        
        //이미지 설정
        guard let url = URL(string: image) else { return }
        self.imageView.kf.setImage(with: url)
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        //postID 설정
        self.postID = postID
        
        //제목 설정
        self.titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.font = .notoSansRegularFont(ofSize: 14)
    
//        if titleLabel.numberOfLines == 2{
//            titleHeight.constant == 25
//        }
//        else{
//            titleHeight.constant = 50
//        }
        
        //하트 설정
        self.isFavorite = isFavorite
       
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
            tagButtonList[index].layer.cornerRadius = 13
            tagButtonList[index].layer.borderWidth = 1
            tagButtonList[index].layer.borderColor = UIColor.mainBlue.cgColor
            tagButtonList[index].contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
  
    }
    
    func likeAction(){
        LikeService.shared.Like(userId: "jieun1211", postId: self.postID) { [self] result in
            
            switch result{
            case .success(let success):
                if let success = success as? Bool {
                    
                    print(self.isFavorite)
                    self.isFavorite = success ? !isFavorite : isFavorite
                    
                    print(self.isFavorite)
                    prepareForReuse()
                    
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

    
    //MARK:- IBAction
    
    @IBAction func heartButtonClicked(_ sender: UIButton) {
        likeAction()
    }
    
}

//MARK:- extension
