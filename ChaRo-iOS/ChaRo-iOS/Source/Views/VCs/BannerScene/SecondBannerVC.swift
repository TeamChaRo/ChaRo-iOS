//
//  Second.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/05/10.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa


final class SecondBannerVC: BannerVC {

    private lazy var tableView = UITableView().then {
        $0.tableHeaderView = SecondBannerHeaderView(frame: CGRect(x: 0, y: 0,
                                                                  width: UIScreen.getDeviceWidth(),
                                                                  height: 746 * viewRetio + 16))
        $0.register(cell: PlayListTVC.self)
        $0.separatorStyle = .none
    }
    
    private var playList: [Song] = []
    
    struct Song {
        let albumImage: UIImage?
        let title: String
        let link: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToTableView()
    }
    
    override func setConstraints() {
        super.setConstraints()
        scrollView.removeFromSuperview()
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(9)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bind() {
        super.bind()
        guard let headerView = tableView.tableHeaderView as? SecondBannerHeaderView else { return }
        headerView.confirmButton.rx.tap
            .asDriver()
            .drive(onNext: {
                print("지금 눌린 부분 전체 링크 보기!!!")
            }).disposed(by: disposeBag)
    }
    
    private func bindToTableView() {
        initPlayListData()
        Observable.just(playList)
            .bind(to: tableView.rx.items(cellIdentifier: PlayListTVC.className,
                                         cellType: PlayListTVC.self)) { row, element, cell in
                cell.setContent(albumImage: element.albumImage, title: element.title)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                print("현재 눌린 indexPath = \(indexPath)")
        }).disposed(by: disposeBag)
    }
    
    private func initPlayListData() {
        playList.append(contentsOf: [ Song(albumImage: ImageLiterals.imgAlbumByBaynk, title: "Baynk - Poolside",
                                           link: "https://www.youtube.com/watch?v=xm-AhIVL_h0&list=TLPQMjkwMzIwMjL7krhnOXW4sA&index=1"),
                                      Song(albumImage: ImageLiterals.imgAlbumByJosefSalvat, title: "Josef Salvat - Open Season",
                                           link: "https://www.youtube.com/watch?v=AXiMS5XW6kA"),
                                      Song(albumImage: ImageLiterals.imgAlbumByGreenDay, title: "Green Day - Last Night On Earth",
                                           link: "https://www.youtube.com/watch?v=xg_Y7Or_hWM"),
                                      Song(albumImage: ImageLiterals.imgAlbumByVirginia, title: "Virginia To Vegas & NOTD  - Malibu",
                                           link: "https://www.youtube.com/watch?v=aLa0bFGF9SY"),
                                      Song(albumImage: ImageLiterals.imgAlbumByOliver, title: "Oliver Nelson - Ain't A Thing",
                                           link: "https://www.youtube.com/watch?v=3nc-qD-6Rn0"),
                                      Song(albumImage: ImageLiterals.imgAlbumByBrahny, title: "Brahny - Pride",
                                           link: "https://www.youtube.com/watch?v=d5ITypP0dZk"),
                                      Song(albumImage: ImageLiterals.imgAlbumByAnt, title: "Ant Saunders - Yellow Hearts",
                                           link: "https://www.youtube.com/watch?v=FDWTP4_5eps"),
                                      Song(albumImage: ImageLiterals.imgAlbumByJames, title: "James Arthur - Say You Won’t Let Go",
                                           link: "https://www.youtube.com/watch?v=0yW7w8F2TVA"),
                                      Song(albumImage: ImageLiterals.imgAlbumByLoote, title: "Loote - tomorrow tonight",
                                           link: "https://www.youtube.com/watch?v=OfG97e-4YXE"),
                                      Song(albumImage: ImageLiterals.imgAlbumByDanShay, title: "Dan&Shay - Speechless",
                                           link: "https://www.youtube.com/watch?v=7UoP9ABJXGE"),
                                      Song(albumImage: ImageLiterals.imgAlbumByEtham, title: "Etham - 12:45",
                                           link: "https://www.youtube.com/watch?v=GhWnG7YhcEE"),
                                      Song(albumImage: ImageLiterals.imgAlbumByLany, title: "LANY - Thick And Thin",
                                           link: "https://www.youtube.com/watch?v=ZpUxgAXCK2E"),
                                      Song(albumImage: ImageLiterals.imgAlbumByHonne, title: " HONNE & Izzy Bizu  -  Someone That Loves You ",
                                           link: "https://www.youtube.com/watch?v=LQC3dBWS_FE"),
                                      Song(albumImage: ImageLiterals.imgAlbumByLanyILYSB, title: "Lany - ILYSB",
                                           link: "https://www.youtube.com/watch?v=SSTp0rknOgA"),
                                      Song(albumImage: ImageLiterals.imgAlbumByPale, title: "Pale Waves - Noises",
                                           link: "https://www.youtube.com/watch?v=-nQessUrdk0")])
    }
    
}
