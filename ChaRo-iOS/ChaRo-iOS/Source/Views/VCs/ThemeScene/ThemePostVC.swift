//
//  ThemePostVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/07.
//

import UIKit
import Then
import SnapKit

class ThemePostVC: UIViewController {
    
    
    //MARK:- IBOutlet
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fromBottomToTitle: NSLayoutConstraint!
    
    let filterView = FilterView()
    
    
    //MARK:- Variable
    static let identifier: String = "HomePostVC"
    var themeList: [String] = ["산", "바다", "호수", "강", "봄", "여름", "가을", "겨울", "해안도로", "벚꽃", "단풍", "여유", "스피드", "야경", "도심"]
    
    var ThemeDic: Dictionary = ["봄":"spring", "여름":"summer", "가을":"fall", "겨울":"winter", "산":"mountain", "바다":"sea", "호수":"lake", "강":"river", "해안도로":"oceanRoad", "벚꽃":"blossom", "단풍":"maple", "여유":"relax", "스피드":"speed", "야경":"nightView", "도심":"cityView"]
    
    var topTVCCell : ThemePostDetailTVC?
    var isFirstLoaded = true
    var cellCount = 0
    var currentState: String = "인기순"
    private var selectedTheme = ""
    private var selectedDriveList: [DriveElement] = []
    private var isLogin: Bool = UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.isLogin)
    
    //MARK:- Constraint
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        setTableView()
        setTitleLabelUI()
        filterViewCompletion()
        filterViewLayout()
        dismissDropDownWhenTappedAround()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getThemeData(theme: selectedTheme, filter: Filter.like)
    }
    
    //MARK:- IBAction
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }

    
    //MARK:- default Setting Function Part
    func setTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCustomXib(xibName: ThemePostThemeTVC.className)
        tableView.registerCustomXib(xibName: ThemePostAllTVC.className)
        tableView.registerCustomXib(xibName: ThemePostDetailTVC.className)
        
        
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        
    }
    
    func filterViewCompletion() {
        filterView.touchCellCompletion = { index in
            switch index{
            case 0:
                self.currentState = "인기순"
                self.getThemeData(theme: self.selectedTheme, filter: .like)
                self.tableView.reloadData()
                self.filterView.isHidden = true
            case 1:
                self.currentState = "최신순"
                self.getThemeData(theme: self.selectedTheme, filter: .new)
                self.tableView.reloadData()
                self.filterView.isHidden = true
            default:
                print("Error")
            }
            return index
        }
    }
    
    func filterViewLayout() {
        self.view.addSubview(filterView)
        filterView.isHidden = true
        filterView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom).offset(168)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(97)
            $0.width.equalTo(180)
        }
    }
    
    func setHeaderBottomView() {
        let bottomView = UIView().then{
            $0.backgroundColor = UIColor.gray20
        }
        navigationView.addSubview(bottomView)
        bottomView.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(1)
        }
    }
    
    func setTitleLabel(name: String) {
        titleLabel.text = name
    }
    
    func setTitleLabelUI() {
        titleLabel.font = .notoSansMediumFont(ofSize: 17)
    }
    
    func setSelectedTheme(name: String) {
        selectedTheme = name
    }

    
    //MARK:- Function
    
    
    //MARK: - 테마 서버 통신
    func getThemeData(theme: String, filter: Filter) {
        
        //문자열에서 # 제거
        let strimmedTheme = theme.trimmingCharacters(in: ["#"])
        
        //영어로 변환
        let themeNames = ThemeDic["\(strimmedTheme)"]!

        //서버에 통신 요청
        GetThemeDataService.shared.getThemeInfo(theme: themeNames, filter: filter) { (response) in
                    switch(response)
                    {
                    case .success(let driveData):
                        if let object = driveData as? Drive {
                            self.cellCount = object.drive.count
                            self.selectedDriveList = object.drive
                            
                            self.tableView.reloadData()
                        }
                        
                    case .requestErr(let message) :
                        print("requestERR",message)
                    case .pathErr :
                        print("pathERR")
                    case .serverErr:
                        print("serverERR")
                    case .networkFail:
                        print("networkFail")
                    }
                }
        
        
    }
    
}


//MARK:- extension

extension ThemePostVC: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 3
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
            switch indexPath.row {
            case 0:
                let cell: ThemePostThemeTVC = tableView.dequeueReusableCell(for: indexPath)
                
                cell.setTVCHeight(height: Double(UIScreen.main.bounds.height) * 0.1434)
                cell.selectionStyle = .none
                cell.setFirstTheme(name: selectedTheme)
                cell.themeDelegate = self
                
                return cell
                
            case 1:
                let cell: ThemePostDetailTVC = tableView.dequeueReusableCell(for: indexPath)

                //첫 텍스트 설정
                cell.delegate = self
                if isFirstLoaded {
                    isFirstLoaded = false
                    topTVCCell = cell
                }

                cell.selectionStyle = .none
                cell.setTitle(data: currentState)
                cell.setLabel()

                return cell
                
            case 2:
                let cell: ThemePostAllTVC = tableView.dequeueReusableCell(for: indexPath)
                cell.selectedDriveList = self.selectedDriveList
                cell.setCellCount(num: cellCount)
                cell.collectionView.reloadData()
                cell.postDelegate = self
                return cell
                
            default:
                return UITableViewCell()
            }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var topBarHeight = 100
        let factor = UIScreen.main.bounds.width / 375
        
        switch indexPath.row {
        
        case 0:
            return 118 * factor
        case 1:
            return 50
        case 2:
            //탭바 높이 알아오기
            return UIScreen.main.bounds.height - 100 - 118 * factor - 120
        default:
            return 118
        }
        
    }
    
    
}


extension ThemePostVC: MenuClickedDelegate {
    func menuClicked() {
        filterView.isHidden = false
    }
}

extension ThemePostVC: ThemeNetworkDelegate {
    func setClickedThemeData(themeName: String) {
        getThemeData(theme: themeName, filter: Filter.new)
    }
    
}

extension ThemePostVC: PostIdDelegate {
    func sendPostDetail(with postId: Int) {
        if isLogin {
            let nextVC = PostDetailVC(postId: postId)
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            makeRequestAlert(title: "로그인이 필요해요", message: "", okTitle: "로그인하기", okAction: { [weak self] _ in
                self?.presentToSignNC()
            }, cancelTitle: "취소")
        }
    }
}

extension ThemePostVC{
    
    func dismissDropDownWhenTappedAround() {
        let tap: UITapGestureRecognizer =
        UITapGestureRecognizer(target: self, action: #selector(dismissDropDown))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissDropDown() {
        self.filterView.isHidden = true
    }
}
