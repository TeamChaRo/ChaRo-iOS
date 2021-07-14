//
//  ThemePostVC.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/07.
//

import UIKit



class ThemePostVC: UIViewController {
    
    
    //MARK:- IBOutlet
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropDownTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    //MARK:- Variable
    static let identifier : String = "HomePostVC"
    var themeList: [String] = ["산", "바다", "호수", "강", "봄", "여름", "가을", "겨울", "해안도로", "벚꽃", "단풍", "여유", "스피드", "야경", "도심"]
    
    var ThemeDic: Dictionary = ["봄":"spring", "여름":"summer", "가을":"fall", "겨울":"winter", "산":"mountain", "바다":"sea", "호수":"lake", "강":"river", "해안도로":"oceanRoad", "벚꽃":"blossom", "단풍":"maple", "여유":"relax", "스피드":"speed", "야경":"nightView", "도심":"cityView"]
    
    var topTVCCell : ThemePostDetailTVC?
    var delegate : SetTopTitleDelegate?
    var isFirstLoaded = true
    var cellCount = 0
    private var selectedTheme = ""
    private var selectedDriveList: [Drive] = []
    
    //MARK:- Constraint
    
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        setTableView()
        setdropDownTableView()
        setTitleLabelUI()
        setShaow()
        setTableViewTag()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getThemeData(theme: selectedTheme)
    }
    
    //MARK:- IBAction
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    //MARK:- default Setting Function Part
    func setTableViewTag(){
        tableView.tag = 1
        dropDownTableView.tag = 2
    }
    
    func setTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCustomXib(xibName: "ThemePostThemeTVC")
        tableView.registerCustomXib(xibName: "ThemePostAllTVC")
        tableView.registerCustomXib(xibName: "ThemePostDetailTVC")
        
        
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        
    }
    
    func setShaow(){
        navigationView.getShadowView(color: UIColor.black.cgColor, masksToBounds: false, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8, shadowOpacity: 0.3)
    }
    
    func setdropDownTableView() {
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        dropDownTableView.isHidden = true
        dropDownTableView.registerCustomXib(xibName: HotDropDownTVC.identifier)
    }
    
    
    func setdropDownTableViewUI() {
        dropDownTableView.clipsToBounds = true
        dropDownTableView.layer.cornerRadius = 20
        dropDownTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        dropDownTableView.separatorStyle = .none
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
    func getThemeData(theme: String) {
        
        //문자열에서 # 제거
        let strimmedTheme = theme.trimmingCharacters(in: ["#"])
        
        //영어로 변환
        let themeNames = ThemeDic["\(strimmedTheme)"]!

        //서버에 통신 요청
        GetThemeDataService.shared.getThemeInfo(theme: themeNames) { (response) in
                    switch(response)
                    {
                    case .success(let driveData):
                        
                        if let object = driveData as? TotalDrive {
                            self.cellCount = object.totalCourse
                                                    
                            if let drive = object.drive as? [Drive] {
                                self.selectedDriveList = drive
                            }
                            
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
        
        if tableView.tag == 2 {
            return 2
        } else {
            return 3
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
                
        if tableView.tag == 2 {

            switch indexPath.row {
            
            case 0:
                let cell: HotDropDownTVC = dropDownTableView.dequeueReusableCell(for: indexPath)
                let bgColorView = UIView()
                bgColorView.backgroundColor = UIColor.mainBlue.withAlphaComponent(0.2)
                cell.selectedBackgroundView = bgColorView
                cell.setLabel()
                cell.setCellName(name: "인기순")
                cell.delegate = self
                
                return cell
                
            default:
                let cell: HotDropDownTVC = dropDownTableView.dequeueReusableCell(for: indexPath)
                let bgColorView = UIView()
                bgColorView.backgroundColor = UIColor.mainBlue.withAlphaComponent(0.2)
                cell.selectedBackgroundView = bgColorView
                cell.setCellName(name: "최신순")
                cell.delegate = self
                return cell
            }
            
        }
        
        if tableView.tag == 1 {
            
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
                cell.setPostCount(data: cellCount)
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
        }
        return UITableViewCell()
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 2 {
            
            let HotCell: HotDropDownTVC = (tableView.dequeueReusableCell(withIdentifier: HotDropDownTVC.identifier) as? HotDropDownTVC)!
            
            if indexPath.row == 0 {
                HotCell.setSelectedCell()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag == 2 {
            return 44
        }
        
        
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


extension ThemePostVC: MenuClickedDelegate{
    func menuClicked() {
        dropDownTableView.isHidden = false
    }
    
    
}

extension ThemePostVC: SetTitleDelegate {
    func setTitle(cell: HotDropDownTVC) {
        delegate?.setTopTitle(name: cell.name)
        dropDownTableView.isHidden = true
        topTVCCell?.setTitle(data: cell.name)
        
    }
    
}


extension ThemePostVC: ThemeNetworkDelegate {
    
    func setClickedThemeData(themeName: String) {
        
        getThemeData(theme: themeName)
    }
    
}

extension ThemePostVC: PostIdDelegate {
    
    func sendPostID(data: Int) {
        print(data)
    }
    
}
