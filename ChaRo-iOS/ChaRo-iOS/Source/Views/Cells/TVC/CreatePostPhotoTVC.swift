//
//  CreatePostPhotoTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/12.
//

import UIKit

class CreatePostPhotoTVC: UITableViewCell {
    
    static let identifier: String = "CreatePostPhotoTVC"
    var receiveImageList: [UIImage] = []
    let maxPhotoCount: Int = 6
    
    // MARK: UI Components
    let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "writeEmptyImage")
        imageView.layer.cornerRadius = 8
        
        return imageView
    }()
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let heigthRatio: CGFloat = 222/335
        let width: CGFloat = UIScreen.getDeviceWidth()-40
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: width, height: width*heigthRatio), collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setNotificationCenter()
        setImageGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
}

extension CreatePostPhotoTVC {
    
    // MARK:- Functions
    func setCollcetionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCustomXib(xibName: CreatePostPhotosCVC.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.reloadData()
    }
    
    func setImageGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap))
                                                
        emptyImageView.addGestureRecognizer(tapGesture)
        emptyImageView.isUserInteractionEnabled = true
    }
    
    func receiveImageListfromVC(image: [UIImage]){
        self.receiveImageList.append(contentsOf: image)
    }
    
    @objc
    func imageViewDidTap(){
        NotificationCenter.default.post(name: .callPhotoPicker, object: nil)
    }

    func setNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(addPhoto), name: .createPostAddPhotoClicked, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deletePhoto), name: .createPostDeletePhotoClicked, object: nil)
    }
    
    @objc
    func addPhoto(_ notification: Notification) {
        // notification to CreatePostVC
        NotificationCenter.default.post(name: .callPhotoPicker, object: nil)
    }

    @objc
    func deletePhoto(_ notification: Notification){
        receiveImageList.remove(at: notification.object as! Int) //선택한 이미지 삭제
        collectionView.reloadData()
    }
    
    // MARK:- Layout
    func emptyConfigureLayout(){
        addSubview(emptyImageView)
        
        emptyImageView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.bottom.equalTo(self.snp.bottom).inset(33)
        }
    }
    
    func photoConfigureLayout(){
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.bottom.equalTo(self.snp.bottom).inset(33)
        }
    }
    
   
}

extension CreatePostPhotoTVC : UICollectionViewDelegate {
    
}

extension CreatePostPhotoTVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if receiveImageList.count >= maxPhotoCount {
            return maxPhotoCount
        } else {
            return receiveImageList.count+1 // TODO: VC에 이미지 배열에서 받아와야함
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatePostPhotosCVC.identifier, for: indexPath) as? CreatePostPhotosCVC else {return UICollectionViewCell() }
        
        print("컬렉션 로드")
        print(receiveImageList.count)
        
        cell.deleteButton.tag = indexPath.row
        
        if receiveImageList.count >= maxPhotoCount { // image가 6개면 일반 셀만
            cell.configureLayout()
            cell.setImageView(image: receiveImageList[indexPath.row])
        } else {
            if indexPath.row == receiveImageList.count { // 마지막 셀은 플러스 버튼
                cell.plusViewConfigureLayout()
            } else {
                cell.configureLayout()
                cell.setImageView(image: receiveImageList[indexPath.row])
            }
        }
        
        return cell
    }
    
}

extension CreatePostPhotoTVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsize: CGFloat = (UIScreen.getDeviceWidth() - 54.0) / 3
        return CGSize(width: cellsize, height: cellsize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
