import Foundation
import UIKit

struct settingDataModel{
    var isToggle: Bool = false
    var toggleData: Bool = false
    var isSubLabel: Bool = false
    var subLabelString: String = ""
    var titleString: String = ""
    var titleLabelColor: UIColor = UIColor.black
    var subLabelColor: UIColor = UIColor.white
    
    init() {
        
    }
    
    //토글 있는 부분 init
    init(titleString: String, isToggle: Bool, toggleData: Bool) {
        self.titleString = titleString
        self.isToggle = isToggle
        self.toggleData = toggleData
    }
    //좌측에 문구 있는 부분 init
    init(isSubLabel: Bool, subLabelString: String, subLabelColor: UIColor) {
        self.isSubLabel = isSubLabel
        self.subLabelString = subLabelString
        self.subLabelColor = subLabelColor
    }
    //기본 글씨 색상 변경 부분 init
    init(titleString: String, titleLabelColor: UIColor) {
        self.titleString = titleString
        self.titleLabelColor = titleLabelColor
    }
    //기본글씨 + 좌측 글씨 + 색상
    init(titleString: String, titleLabelColor: UIColor, isSubLabel: Bool, subLabelString: String, subLabelColor: UIColor) {
        self.titleString = titleString
        self.titleLabelColor = titleLabelColor
        self.isSubLabel = isSubLabel
        self.subLabelString = subLabelString
        self.subLabelColor = subLabelColor
    }

}
