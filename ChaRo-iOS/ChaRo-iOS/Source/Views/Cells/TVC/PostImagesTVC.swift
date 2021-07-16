//
//  PostImagesTVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/06.
//

import UIKit
import Kingfisher

class PostImagesTVC: UITableViewCell {
    
    static let identifier: String = "PostImagesTVC"

    // MARK: - Outlet Variables
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - images
    // ToDo: - 일단 지금은 더미데이터로 넣고, 추후 서버 통신으로 리스트 append 예정
    var images: [String] = []
    var postImageView = [UIImageView]()
    let imageHeightRate: CGFloat = 222 / UIScreen.main.bounds.height
    let ImageViewWidth: CGFloat = UIScreen.main.bounds.width
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configureScrollView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func configureScrollView(){
        scrollView.delegate = self
    }
    
    // MARK: - IBActions
    @IBAction func pageChanged(_ sender: Any) {
        setPageArrowButton()
    }
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
        if pageController.currentPage < images.count-1 {
            UIImageView.animate(withDuration: 0.4, animations: { [self] in
                self.scrollView.contentOffset.x += UIScreen.main.bounds.width
            })
            let value = scrollView.contentOffset.x/scrollView.frame.size.width
            setPageControlSelectedPage(currentPage: Int(round(value)))
            setPageArrowButton()
        }
    }
    
    @IBAction func previousButtonDidTap(_ sender: Any) {
        if pageController.currentPage > 0 {
            UIImageView.animate(withDuration: 0.4, animations: {
                self.scrollView.contentOffset.x -= UIScreen.main.bounds.width
            })
            let value = scrollView.contentOffset.x/scrollView.frame.size.width
            setPageControlSelectedPage(currentPage: Int(round(value)))
            setPageArrowButton()
        }
    }
    
}

extension PostImagesTVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))
    }
}

// MARK: - functions
extension PostImagesTVC {

    func setImage(_ imgNames: [String]){
        images = imgNames
        initImagePage()
        initScrollView()
        addImageView()
    }
    
    func setImageAtConfirmView(imageList: [UIImage]){
        var strArr :[String] = []
        
        for item in imageList {
            strArr.append("")
        }
        images = strArr
        initImagePage()
        initScrollView()
        addImageView(imageList: imageList)
    }
    
    
    
    func initImagePage(){
        pageController.numberOfPages = images.count
        pageController.currentPage = 0 // 시작은 첫 페이지
        pageController.isHidden = true
        setPageArrowButton()
    }
    
    func initScrollView(){
        scrollView.frame = UIScreen.main.bounds
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(images.count), height: UIScreen.main.bounds.height * imageHeightRate)
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
    }
    
    func setPageControlSelectedPage(currentPage:Int) {
        pageController.currentPage = currentPage
        setPageArrowButton()
    }
    
    func addImageView(){
        for i in 0..<images.count{
            let imageView = UIImageView()
            let xPos = UIScreen.main.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * imageHeightRate)
            imageView.contentMode = .scaleAspectFill
            imageView.kf.setImage(with: URL(string: images[i]))
            scrollView.addSubview(imageView)
            scrollView.contentSize.width = imageView.frame.width * CGFloat(i+1)
        }
    }
    
    func addImageView(imageList: [UIImage]){
        for i in 0..<imageList.count{
            let imageView = UIImageView()
            let xPos = UIScreen.main.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * imageHeightRate)
            imageView.contentMode = .scaleAspectFill
            imageView.image = imageList[i]
            scrollView.addSubview(imageView)
            scrollView.contentSize.width = imageView.frame.width * CGFloat(i+1)
        }
    }
    
    func setPageArrowButton(){
        print("image!!!!! \(images.count)")
        if pageController.currentPage == images.count-1 { // 마지막 페이지
            nextButton.isHidden = true
            previousButton.isHidden = false
        } else if pageController.currentPage == 0 && images.count != 1 { // 첫 페이지
            nextButton.isHidden = false
            previousButton.isHidden = true
        } else { // 그 외 페이지
            nextButton.isHidden = false
            previousButton.isHidden = false
        }
    }
    
}
