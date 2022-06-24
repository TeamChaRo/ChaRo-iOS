//
//  PostLikeListVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/03/02.
//

import UIKit
import SnapKit
import Then
import RxSwift

class PostLikeListVC: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var viewModel: PostLikeListViewModel
    private let transionYOffsetSubject = PublishSubject<(CGFloat, Bool)>()
    
    private var animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut)
    private let backgroundView = UIView().then {
        $0.backgroundColor = .mainBlack.withAlphaComponent(0.8)
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    private lazy var tableView = UITableView().then {
        $0.register(cell: FollowFollowingTVC.self)
        $0.separatorStyle = .none
    }
    private let xmarkButton = UIButton().then {
        $0.setBackgroundImage(ImageLiterals.icClose, for: .normal)
    }
    private let titleLabel = UILabel().then {
        $0.text = "좋아요"
        $0.font = .notoSansMediumFont(ofSize: 17)
    }
    
    init(postId: Int) {
        self.viewModel = PostLikeListViewModel(postId: postId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        configureUI()
        setupPanGesture()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatebackgroundView()
        animatePresentContainer()
    }
    
    private func setupConstraints() {
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
    
    private func configureUI() {
        view.backgroundColor = .clear
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc
    private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let transionY = gesture.translation(in: self.view).y
        switch gesture.state {
        case .changed:
            transionYOffsetSubject.onNext((transionY, true))
        case .ended:
            transionYOffsetSubject.onNext((transionY, false))
        default:
            break
        }
    }
    
    private func updateContainerView(height: CGFloat) {
        containerView.snp.updateConstraints{
            $0.height.equalTo(height)
        }
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(form: PostLikeListViewModel.Input(transionYOffsetSubject: transionYOffsetSubject), disposeBag: disposeBag)
        output.newHeightSubject
            .bind(onNext: { [weak self] newHeight, isEnded in
                if newHeight == -1 {
                    self?.animateDismissView()
                }
                isEnded ? self?.animateContainerView(height: newHeight)
                : self?.updateContainerView(height: newHeight)
            })
            .disposed(by: disposeBag)

        output.postLikeListSubject
            .bind(to: tableView.rx.items(cellIdentifier: FollowFollowingTVC.className,
                                         cellType: FollowFollowingTVC.self)) { row, element, cell in
                cell.setData(data: element)
                cell.changeUIStyleAtPostListList()
                }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Follow.self)
            .bind(onNext: { [weak self] follow in
                let otherVC = OtherMyPageVC()
                otherVC.setOtherUserID(userID: follow.userEmail)
                self?.present(otherVC, animated: true)
            }).disposed(by: disposeBag)
        
        xmarkButton.rx.tap
            .asDriver()
            .drive(onNext:{[weak self] in
                self?.animateDismissView()
            }).disposed(by: disposeBag)
    }
}

//MARK: - Animation
extension PostLikeListVC{
    private func animatePresentContainer() {
        animator.addAnimations {
            self.updateContainerView(height: self.viewModel.defaultHeight)
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    private func animatebackgroundView() {
        backgroundView.alpha = 0
        animator.addAnimations {
            self.backgroundView.alpha = self.viewModel.maxBackgroundAlpha
        }
        animator.startAnimation()
    }
    
    private func animateContainerView(height: CGFloat) {
        animator.addAnimations {
            self.updateContainerView(height: height)
            self.view.layoutIfNeeded()
        }
        viewModel.currentContainerHeight = height
        animator.startAnimation()
    }
    
    private func animateDismissView() {
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
