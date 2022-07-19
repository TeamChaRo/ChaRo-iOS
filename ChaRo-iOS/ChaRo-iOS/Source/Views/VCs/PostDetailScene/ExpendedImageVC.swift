//
//  ExpendedImageVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/06/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class ExpendedImageVC: UIViewController {
    
    // MARK: - properties
    private let disposeBag = DisposeBag()
    private let imageList: [String]
    private let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut)
    private let scrolledOffsetSubject = PublishSubject<CGFloat>()
    private let photoSubject = ReplaySubject<[String]>.create(bufferSize: 1)
    private var currentIndex: Int = 0
    
    private let xmarkButton = UIButton().then {
        $0.setImage(ImageLiterals.icCloseWhite, for: .normal)
    }
    
    private let photoNumberButton = UIButton().then {
        $0.titleLabel?.font = .notoSansMediumFont(ofSize: 15)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 25.0 / 2.0
        $0.backgroundColor = .gray30
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: screenWidth, height: UIScreen.main.bounds.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        $0.setCollectionViewLayout(layout, animated: true)
        $0.tintColor = .clear
        $0.backgroundColor = .clear
        $0.register(cell: PostPhotoCVC.self)
        $0.rx.setDelegate(self)
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let viewModel: ExpendedImageViewModel
    
    init(imageList: [String], currentIndex: Int) {
        self.imageList = imageList
        self.photoSubject.onNext(imageList)
        self.viewModel = ExpendedImageViewModel()
        self.currentIndex = currentIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        render()
        configUI()
    }
    
    private func render() {
        view.addSubviews([collectionView, xmarkButton, photoNumberButton])
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        xmarkButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(11)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(50)
        }
        
        photoNumberButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.width.equalTo(61)
            $0.height.equalTo(25)
        }
    }
    
    private func configUI() {
        view.backgroundColor = .black.withAlphaComponent(0.9)
        setupPanGesture()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.scrollToItem(at: IndexPath(row: self.currentIndex, section: 0),
                                              at: .left, animated: false)
            self.collectionView.isPagingEnabled = true
            self.photoNumberButton.setTitle("\(self.currentIndex + 1) / \(self.imageList.count)", for: .normal)
        }
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }

    @objc
    private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let transtionY = gesture.translation(in: view).y
        switch gesture.state{
        case .changed:
            scrolledOffsetSubject.onNext(transtionY)
        case .ended:
            animateContainerView(yOffset: 0)
        default:
            break
        }
    }
    
    private func animateContainerView(yOffset: CGFloat) {
        collectionView.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(yOffset)
        }
    }
    
    private func animateDismissView() {
        animator.addAnimations {
            self.view.backgroundColor = .clear
            self.collectionView.alpha = 0
        }
        animator.addCompletion { _ in
            self.dismiss(animated: false)
        }
        animator.startAnimation()
    }
    
    private func bind() {
        photoSubject
            .bind(to: collectionView.rx.items(cellIdentifier: PostPhotoCVC.className,
                                                     cellType: PostPhotoCVC.self)) { row, element, cell in
                cell.imageView.contentMode = .scaleAspectFit
                cell.setImage(to: element)
        }.disposed(by: disposeBag)
        
        xmarkButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        bindToViewModel()
    }
    
    private func bindToViewModel() {
        let output = viewModel.transform(to: ExpendedImageViewModel.Input(scrolledOffsetSubject: scrolledOffsetSubject), disposeBag: disposeBag)
        output.newHeightSubject
            .filter { $0 != nil }
            .bind(onNext: { yoffset in
                yoffset == -1 ? self.animateDismissView() : self.animateContainerView(yOffset: yoffset ?? 0)
            }).disposed(by: disposeBag)
    }
}

extension ExpendedImageVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ExpendedImageVC: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        photoNumberButton.setTitle("\(currentPage + 1) / \(imageList.count)", for: .normal)
    }
}

