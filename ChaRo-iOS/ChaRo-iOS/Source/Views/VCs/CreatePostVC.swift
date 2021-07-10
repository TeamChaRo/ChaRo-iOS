//
//  CreatePostVC.swift
//  ChaRo-iOS
//
//  Created by 최인정 on 2021/07/11.
//

import UIKit
import SnapKit

class CreatePostVC: UIViewController {
    
    static let identifier: String = "CreatePostVC"

    //MARK: - components
    let tableView: UITableView = UITableView()
    let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let xButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "close"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 17)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "작성하기"
        label.textAlignment = .center
        label.font = .notoSansMediumFont(ofSize: 17)
        label.textColor = .subBlack
        return label
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setMainViewLayout()
        configureConponentLayout()
    }
    
}

// MARK: - functions
extension CreatePostVC {
    // MARK: Setting function
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Layout
    func setMainViewLayout(){
        view.addSubviews([titleView,tableView])
        
        let titleRatio: CGFloat = 58/375
        
        titleView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(UIScreen.getDeviceWidth()*titleRatio)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(UIScreen.getDeviceWidth()*titleRatio)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureConponentLayout(){
        titleView.addSubviews([titleLabel, xButton, nextButton])
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(titleView.snp.top).offset(14)
            $0.width.equalTo(150) // 크게 넣기
            $0.centerX.equalTo(titleView.snp.centerX)
            $0.height.equalTo(21)
        }
        
        xButton.snp.makeConstraints{
            $0.leading.equalTo(titleView.snp.leading).offset(7)
            $0.width.equalTo(48)
            $0.height.equalTo(xButton.snp.width)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        nextButton.snp.makeConstraints{
            $0.trailing.equalTo(titleView.snp.trailing).offset(-20)
            $0.height.equalTo(22)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
    
}

extension CreatePostVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
