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
    
    var image : UIImage?
    

    //MARK: Variable
    var callback : (() -> Void)?
    var postID: Int = 1
    var isFavorite: Bool? {
        didSet {
            if isFavorite! {
                heartButton.setImage(UIImage(named: "heart_active"), for: .normal)
            } else {
                heartButton.setImage(UIImage(named: "icHeartWhiteLine"), for: .normal)
            }
        }
    }
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setImageUrl(_ url: String) {
          
          let cacheKey = NSString(string: url) // 캐시에 사용될 Key 값
          if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) { // 해당 Key 에 캐시이미지가 저장되어 있으면 이미지를 사용
            print("캐시 이미지")
            image = cachedImage
            return
          }
          else{
          print("newImage")
        let imageurl = URL(string: url)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageurl!)
            DispatchQueue.main.async { self.image = UIImage(data: data!) }
            ImageCacheManager.shared.setObject(image, forKey: cacheKey) // 다운로드된 이미지를 캐시에 저장
        }
        imageView.image = image
          }
      }
    

    //setData 지원이꺼
    func setData(image: String,
                 title: String,
                 tagCount: Int,
                 tagArr: [String],
                 isFavorite: Bool,
                 postID: Int) {
        
        //이미지 설정
//        guard let url = URL(string: image) else { return }
//        self.imageView.kf.setImage(with: url)
        //url에 정확한 이미지 url 주소를 넣는다.
        
//        let url = URL(string: image)
//        var image : UIImage?
//        DispatchQueue.global().async {
//        let data = try? Data(contentsOf: url!)
//        DispatchQueue.main.async {
//        image = UIImage(data: data!)
//            self.imageView.image = image
//        }
//        }
        self.setImageUrl(image)
        
        

        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        //postID 설정
        self.postID = postID
        
        //제목 설정
        self.titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.font = .notoSansRegularFont(ofSize: 14)
        
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
            tagButtonList[index].layer.cornerRadius = 9
            tagButtonList[index].layer.borderWidth = 1
            tagButtonList[index].layer.borderColor = UIColor.mainBlue.cgColor
            tagButtonList[index].contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
    func setImageUrl(_ url: String) {
        
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: url) {
                URLSession.shared.dataTask(with: url) { (data, res, err) in
                    if let _ = err {
                        DispatchQueue.main.async {
                            self.image = UIImage()
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        if let data = data, let image = UIImage(data: data) {
                            self.image = image
                        }
                    }
                }.resume()
            }
        }
        print(image)
    }
 }
