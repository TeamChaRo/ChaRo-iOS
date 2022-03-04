//
//  NewHotFilterView.swift
//  ChaRo-iOS
//
//  Created by 박익범 on 2021/10/11.
//

import Foundation
import UIKit
import SnapKit
import Then

protocol NewHotFilterClickedDelegate{
    func filterClicked(row: Int)
}


class NewHotFilterView: UIView{
    var delegate: MenuClickedDelegate?
    var clickDelegate: NewHotFilterClickedDelegate?
    private let tableView = UITableView()
    private let backgroundView = UIView().then{
        $0.backgroundColor = UIColor.white
    }
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    private func setView(){
        backgroundView.frame = CGRect(x: 0, y: 0, width: 180, height: 97)
        tableView.frame = CGRect(x: 0, y: 0, width: 180, height: 82)
        addSubview(backgroundView)
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomXib(xibName: "HotDropDownTVC")
        
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 15
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 15
        
        tableView.snp.makeConstraints{
            $0.leading.equalTo(backgroundView).offset(0)
            $0.trailing.equalTo(backgroundView).offset(0)
            $0.top.equalTo(backgroundView).offset(11)
            $0.bottom.equalTo(backgroundView).offset(0)
        }
    }

}

extension NewHotFilterView: UITableViewDelegate{
    
}
extension NewHotFilterView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickDelegate?.filterClicked(row: indexPath.row)
        print(indexPath.row, "를 클릭하셨습니다.")
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withType: HotDropDownTVC.self, for: indexPath)
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.mainBlue.withAlphaComponent(0.2)
        cell.selectedBackgroundView = bgColorView
        cell.setLabel()
        cell.setCellName(name: indexPath.row == 0 ? "인기순" : "최신순")
        return cell
    }
    
}
