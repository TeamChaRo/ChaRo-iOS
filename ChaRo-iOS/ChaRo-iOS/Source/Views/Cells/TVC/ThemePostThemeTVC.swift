//
//  ThemePostThemeTVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/08.
//

import UIKit

protocol ThemeNetworkDelegate {
    func setClickedThemeData(themeName: String)
}


class ThemePostThemeTVC: UITableViewCell {
    
    //MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Variable
    static let identifier = "ThemePostThemeTVC"
    var themeList: [String] = ["산", "바다", "호수", "강", "봄", "여름", "가을", "겨울", "해안도로", "벚꽃", "단풍", "여유", "스피드", "야경", "도심"]
    var ThemeDic: Dictionary = ["봄":"spring", "여름":"summer", "가을":"fall", "겨울":"winter", "산":"mountain", "바다":"sea", "호수":"lake", "강":"river", "해안도로":"oceanRoad", "벚꽃":"blossom", "단풍":"maple", "여유":"relax", "스피드":"speed", "야경":"nightView", "도심":"cityView"]
    
    public var tvcHeight : CGFloat = 100
    var themeDelegate: ThemeNetworkDelegate?
    private var firstTheme = ""
    
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
        setSelected()
        
        
    }
    
    
    //MARK:- default Setting Function Part
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerCustomXib(xibName: HomeThemeCVC.identifier)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    
    private func setSeperatorBarConstraints() {
        self.addSubview(seperatorBar)
        
        seperatorBar.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.height.equalTo(1)
        }
        
    }
    
    private func setSelected() {
        let firstIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .right)
    }
    
    public func setTVCHeight(height: Double) {
        tvcHeight = CGFloat(height)
    }
    
    public func setFirstTheme(name: String) {
        firstTheme = name
        swapArray()
    }
    
    
    //MARK:- Function
    
    
    //초기 선택된 테마를 위해 배열의 순서를 바꿉니다. 선택된 테마가 인덱스 0으로 올 수 있도록!
    private func swapArray() {
        
        for (index, element) in themeList.enumerated() {
            if "#\(element)" == firstTheme {
                themeList.swapAt(0, index)
            }
        }
        
    }
    
}



//MARK:- extension
extension ThemePostThemeTVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? HomeThemeCVC
        let themeName = (cell?.themeLabel.text)!
        
        //Delegate 로 서버 통신, reload 다시
        themeDelegate?.setClickedThemeData(themeName: themeName)
        
    }
}

extension ThemePostThemeTVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeThemeCVC.identifier, for: indexPath) as? HomeThemeCVC else { return UICollectionViewCell() }
        
        //테마 이름, 이미지 설정
        let themeName = themeList[indexPath.row]
        cell.themeLabel.text = "#\(themeName)"
        cell.themeImageView.image = UIImage(named: ThemeDic[themeName] ?? "gear")
        cell.location = .ThemeTopTVC
        
        if indexPath.row == 0 {
            cell.isSelected = true
        }else{
            cell.isSelected = false
        }
        
        return cell
        
    }
}

extension ThemePostThemeTVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 64, height: self.tvcHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        UIEdgeInsets(top: 16, left: 21, bottom: 0, right: 21)
        
    }
    
    
}
