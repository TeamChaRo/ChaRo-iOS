//
//  CommonCVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/04.
//

import UIKit

class ImageCacheManager {
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}

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
    var clickedPostCell : ((Int) -> ())?
    var titleLabelHeight = -1
    
    var image : UIImage?
    

    //MARK: Variable
    var callback : (() -> Void)?
    var postID: Int = 1
    var isFavorite: Bool? {
        didSet {
            if isFavorite! {
                heartButton.setImage(ImageLiterals.icHeartActive, for: .normal)
            } else {
                heartButton.setImage(UIImage(named: "icHeartWhiteLine"), for: .normal)
            }
        }
    }
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.sizeToFit()
         print("titleLabelHeight = \(titleLabelHeight)")
        if titleLabelHeight != -1 {
            titleHeight.constant = CGFloat(titleLabelHeight)
            print("titleLabelHeight \(titleLabelHeight)")
        }
        
    }
    //setData 지원이꺼
    func setData(image: String,
                 title: String,
                 tagCount: Int,
                 tagArr: [String],
                 isFavorite: Bool,
                 postID: Int,
                 height: Int) {
        
        setData(image: image, title: title, tagCount: tagCount, tagArr: tagArr, isFavorite: isFavorite, postID: postID)
        
        titleLabelHeight = height
        print("setData -> \(titleLabelHeight)")
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
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: url, options: [.forceTransition, .keepCurrentImageWhileLoading])
                                
     

        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        //postID 설정
        self.postID = postID
        
        //제목 설정
        self.titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.font = .notoSansRegularFont(ofSize: 14)
    
        let attrString = NSMutableAttributedString(string: titleLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0.1
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        titleLabel.attributedText = attrString
        
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
            
            if tagArr[index] != "" {
                tagButtonList[index].setTitle(" #\(tagArr[index]) ", for: .normal)
                tagButtonList[index].titleLabel?.font = UIFont.notoSansRegularFont(ofSize: 10)
                tagButtonList[index].setTitleColor(.mainBlue, for: .normal)
                tagButtonList[index].layer.cornerRadius = 9
                tagButtonList[index].layer.borderWidth = 1
                tagButtonList[index].layer.borderColor = UIColor.mainBlue.cgColor
                tagButtonList[index].contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            else{
                tagButtonList[index].setTitle("", for: .normal)
                tagButtonList[index].layer.borderColor = UIColor.clear.cgColor
            }
        }
  
    }
    
    func setLabel(){
        titleLabel.font = UIFont.notoSansBoldFont(ofSize: 17)
    }
    
    func likeAction(){
        LikeService.shared.Like(userId: "jieun1211", postId: self.postID) { [self] result in
            
            switch result{
            case .success(let success):
                if let success = success as? Bool {
                    
                    self.isFavorite = success ? !isFavorite! : isFavorite
                    
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
    
    override var isSelected: Bool{
        didSet {
            if isSelected {
                print(postID)
                clickedPostCell?(postID)
            }
          }
    }
    
}

//MARK:- extension

extension UIImageView {
    
//    func setImageUrl(_ url: String) {
//        
//        DispatchQueue.global(qos: .background).async {
//            if let url = URL(string: url) {
//                URLSession.shared.dataTask(with: url) { (data, res, err) in
//                    if let _ = err {
//                        DispatchQueue.main.async {
//                            self.image = UIImage()
//                        }
//                        return
//                    }
//                    DispatchQueue.main.async {
//                        if let data = data, let image = UIImage(data: data) {
//                            self.image = image
//                        }
//                    }
//                }.resume()
//            }
//        }
//        print(image)
//    }
 }
