//
//  SearchResultVC.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/07/11.
//

import UIKit

class SearchResultVC: UIViewController {

    static let identifier = "SearchResultVC"
    
    private let navigationView = UIView()
    private lazy var backButton = LeftBackButton(toPop: self)
    private let navigationTitleLabel = NavigationTitleLabel(title: "드라이브 맞춤 겸색 결과",
                                                            color: .mainBlack)
    
    private var tableView = UITableView()
    public var filterfilterResultList: [String] = []
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.titleLabel?.font = .notoSansMediumFont(ofSize: 17)
        button.setTitleColor(.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: Result non view
    private let searchNoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "searchNoImage"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let searchNoLabel :UILabel = {
        let label = UILabel()
        label.text = "검색하신 드라이브 코스가 아직 없습니다\n직접 나만의 드라이브 코스를\n만들어보는 것은 어떠신가요?"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .notoSansRegularFont(ofSize: 14)
        label.textColor = .gray50
        return label
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("드라이브 코스 작성하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .notoSansBoldFont(ofSize: 16)
        button.layer.cornerRadius = 8
        button.backgroundColor = .mainBlue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraint()
        setContentViewConstraint()
        configureTableView()
        //setShadowInNavigationView()
    }
    
    public func setFilterTagList(list: [String]){
        filterfilterResultList = list
    }

    @objc func dismissAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setShadowInNavigationView(){
        navigationView.backgroundColor = .white

        navigationView.layer.shadowOpacity = 0.05
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 0)
        navigationView.layer.shadowRadius = 6

        navigationView.layer.masksToBounds = false
        navigationView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0,
                                                                           width: UIScreen.getDeviceWidth(),
                                                                           height: UIScreen.getNotchHeight()+58),
                                                       cornerRadius: navigationView.layer.cornerRadius).cgPath
//
//
//        navigationView.getShadowView(color: UIColor.black.cgColor,
//                                     masksToBounds: false,
//                                     shadowOffset: CGSize(width: 0, height: 2),
//                                     shadowRadius: 8,
//                                     shadowOpacity: 0.3)
    }
    
}

extension SearchResultVC: UITableViewDelegate{
    
    
}

extension SearchResultVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension SearchResultVC{
    
    private func setConstraint(){
        view.addSubview(navigationView)
    
        navigationView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view)
            $0.height.equalTo(UIScreen.getNotchHeight() + 58)
        }
        
        
        setShadowInNavigationView()
        setConstraintsInNavigaitionView()
    }
    
    
    private func setConstraintsInNavigaitionView(){
        navigationView.addSubviews([backButton,
                                    navigationTitleLabel
                                    ,closeButton])
        
        backButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(UIScreen.getNotchHeight() + 1)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-9)
        }
        
        navigationTitleLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
        closeButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(backButton.snp.centerY)
        }
    }
    
    private func setContentViewConstraint(){
        if filterfilterResultList.isEmpty{
            setEmptyViewConstraint()
        }else{
            setResultViewConstraint()
        }
    }
    
    private func setEmptyViewConstraint(){
        view.addSubviews([searchNoImageView,
                          searchNoLabel,
                          searchButton])
        
        searchNoImageView.snp.makeConstraints{
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(navigationView.snp.bottom).offset(28)
        }
        
        searchNoLabel.snp.makeConstraints{
            $0.top.equalTo(searchNoImageView.snp.bottom).offset(19)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        searchButton.snp.makeConstraints{
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(48)
        }
    }
    
    private func setResultViewConstraint(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.tableHeaderView = setTableHearderView()
    }
    
    
    private func setTableHearderView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0,
                                        width: UIScreen.getDeviceWidth(),
                                        height: 65))
        
        let stackView = UIStackView(arrangedSubviews: makeTagLabelList())
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints{
            $0.top.equalTo(view.snp.top).offset(0)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.height.equalTo(34)
        }
        return view
    }
    
    private func makeTagLabelList() -> [UIButton] {
        var list: [UIButton] = []
        for index in 0..<filterfilterResultList.count {
           
            if filterfilterResultList[index] == "" || filterfilterResultList[index] == "선택안함"{
                continue
            }
            
            let button = UIButton()
            button.titleLabel?.font = .notoSansRegularFont(ofSize: 14)
            button.layer.cornerRadius = 17
            button.layer.borderWidth = 1
            
            if index == 3 {
                button.setTitle(" #\(filterfilterResultList[index])X ", for: .normal)
                button.setTitleColor(.gray30, for: .normal)
                button.layer.borderColor = UIColor.gray30.cgColor
            }else{
                button.setTitle(" #\(filterfilterResultList[index]) ", for: .normal)
                button.setTitleColor(.mainBlue, for: .normal)
                button.layer.borderColor = UIColor.mainlightBlue.cgColor
            }
            
            list.append(button)
            
            //button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
        
        return list
    }
}



