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
    private let navigationTitleLabel = NavigationTitleLabel(title: "드라이브 맞춥 겸색 결과",
                                                            color: .mainBlack)
    
    private var tableView = UITableView()
    

    public var resultList: [String] = []
    
    private let closeLabel: UILabel = {
        let label = UILabel()
        label.text = "닫기"
        label.font = .notoSansMediumFont(ofSize: 17)
        label.textColor = .mainBlue
        return label
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
        button.layer.cornerRadius = 8
        button.backgroundColor = .mainBlue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraint()
        setContentViewConstraint()
        configureTableView()
    }
    
    public func setFilterTagList(list: [String]){
        resultList = list
    }

    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
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
        view.addSubviews([navigationView])
        
        navigationView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(58)
        }
        setConstraintsInNavigaitionView()
    }
    
    
    private func setConstraintsInNavigaitionView(){
        navigationView.addSubviews([backButton,
                                    navigationTitleLabel
                                    ,closeLabel])
        
        backButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(1)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-9)
        }
        
        navigationTitleLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
        closeLabel.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(backButton.snp.centerY)
        }
    }
    
    private func setContentViewConstraint(){
        if resultList.count == 0{
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
        }
    }
    
    private func setResultViewConstraint(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom)
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
        stackView.spacing = 10
    
        stackView.backgroundColor = .red
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints{
            $0.top.equalTo(view.snp.top).offset(15)
            $0.leading.equalTo(view.snp.leading).offset(20)
            //$0.trailing.equalTo(view.snp.trailing).offset(-20)
            $0.height.equalTo(34)
            
        }
        
        return view
    }
    
    private func makeTagLabelList() -> [UIButton] {
        var list: [UIButton] = []
        for text in resultList {
            print(text)
            if text == "" {
                continue
            }
            let button = UIButton()
            button.titleEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            button.setTitle("#\(text)", for: .normal)
            button.setTitleColor(.mainBlue, for: .normal)
            button.titleLabel?.font = .notoSansRegularFont(ofSize: 12)
            button.layer.cornerRadius = 20
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.mainlightBlue.cgColor
            list.append(button)
        }
        
        if list.count == 4 {
            let title = list[3].titleLabel?.text ?? ""
            list[3].setTitle("\(title)X", for: .normal)
            list[3].setTitleColor(.gray30, for: .normal)
            list[3].layer.borderColor = UIColor.gray30.cgColor
        }
        
        return list
    }
}



