//
//  PostLikeListVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/02.
//

import UIKit
import RxSwift
import Alamofire

class PostLikeListVC: UIViewController{
    
    private let disposeBag = DisposeBag()
    private let viewModel = PostLikeListViewModel()
    private let transionYOffsetSubject = PublishSubject<(CGFloat, Bool)>()
    
    //MARK: - Properties
    var postId: Int = -1
    private var animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut)
    private let backgroundView = UIView().then{
        $0.backgroundColor = .mainBlack.withAlphaComponent(0.8)
    }
    
    private let containerView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    private lazy var tableView = UITableView().then{
        $0.register(cell: FollowFollowingTVC.self)
        $0.separatorStyle = .none
    }
    
    private let xmarkButton = UIButton().then{
        $0.setBackgroundImage(ImageLiterals.icClose, for: .normal)
    }
    private let titleLabel = UILabel().then{
        $0.text = "좋아요"
        $0.font = .notoSansMediumFont(ofSize: 17)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        configureUI()
        setupPanGesture()
        bind()
        viewModel.getPostLikeList(postId: postId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatebackgroundView()
        animatePresentContainer()
    }
    
    private func setupConstraints(){
        view.addSubviews([backgroundView, containerView])
        backgroundView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        containerView.addSubviews([xmarkButton, titleLabel, tableView])
        xmarkButton.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(7)
            $0.width.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().inset(19)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(xmarkButton.snp.bottom).inset(4)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureUI(){
        view.backgroundColor = .clear
    }
    
    private func setupPanGesture(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc
    func handlePanGesture(gesture: UIPanGestureRecognizer){
        let transionY = gesture.translation(in: self.view).y
        switch gesture.state{
        case .changed:
            transionYOffsetSubject.onNext((transionY, true))
        case .ended:
            transionYOffsetSubject.onNext((transionY, false))
        default:
            break
        }
    }
    
    private func updateContainerView(height: CGFloat){
        containerView.snp.updateConstraints{
            $0.height.equalTo(height)
        }
    }
    
    private func bindViewModel(){
        let output = viewModel.transform(form: PostLikeListViewModel.Input(transionYOffsetSubject: transionYOffsetSubject))
        output.newHeightSubject
            .bind(onNext: { [weak self] newHeight, isEnded in
                isEnded ? self?.animateContainerView(height: newHeight)
                : self?.updateContainerView(height: newHeight)
            })
            .disposed(by: disposeBag)
        
        output.postLikeListSubject
            .bind(to: tableView.rx.items(cellIdentifier: FollowFollowingTVC.className,
                                         cellType: FollowFollowingTVC.self)){ row, element, cell in
                cell.setData(image: element.image,
                             userName: element.nickname,
                             isFollow: element.isFollow,
                             userEmail: element.userEmail)
                cell.changeUIStyleAtPostListList()
                }.disposed(by: disposeBag)
        
        xmarkButton.rx.tap
            .asDriver()
            .drive(onNext:{[weak self] in
                self?.animateDismissView()
            }).disposed(by: disposeBag)
    }
}

//MARK: - Animation
extension PostLikeListVC{
    func animatePresentContainer() {
        animator.addAnimations {
            self.updateContainerView(height: self.viewModel.defaultHeight)
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    func animatebackgroundView() {
        backgroundView.alpha = 0
        animator.addAnimations {
            self.backgroundView.alpha = self.viewModel.maxBackgroundAlpha
        }
        animator.startAnimation()
    }
    
    func animateContainerView(height: CGFloat) {
        animator.addAnimations {
            self.updateContainerView(height: height)
            self.view.layoutIfNeeded()
        }
        viewModel.currentContainerHeight = height
        animator.startAnimation()
    }
    
    func animateDismissView() {
        backgroundView.alpha = viewModel.maxBackgroundAlpha
        animator.addAnimations {
            self.backgroundView.alpha = 0
            self.updateContainerView(height: 0)
            self.view.layoutIfNeeded()
        }
        animator.addCompletion { _ in
            self.dismiss(animated: false)
        }
        animator.startAnimation()
    }
}
