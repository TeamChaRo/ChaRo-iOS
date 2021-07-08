//
//  ThemePostThemeTVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/08.
//

import UIKit

class ThemePostThemeTVC: UITableViewCell {
    
    //MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Variable
    private var seperatorBar : UIView = {
        let view = UIView()
        view.backgroundColor = .gray20
        return view
    }()
    
    private var highlightBar : UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        return view
    }()
    
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionView()
        setSeperatorBarConstraints()
        
        //첫번째 셀을 클릭
        let firstIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .right)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    //MARK:- default Setting Function Part
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerCustomXib(xibName: "HomeThemeCVC")
        collectionView.showsHorizontalScrollIndicator = false
    }
    

    private func setSeperatorBarConstraints() {
        self.addSubview(seperatorBar)

        seperatorBar.snp.makeConstraints{ make in
            make.top.equalTo(collectionView.snp.bottom).offset(0.5)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom).offset(0.5)
        }
    }

    
    //MARK:- Function
    
}



//MARK:- extension
extension ThemePostThemeTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeThemeCVC", for: indexPath) as? HomeThemeCVC else { return UICollectionViewCell() }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 64, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeThemeCVC
        else { return }

        
    
    }
}
