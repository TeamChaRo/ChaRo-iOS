import Foundation
import UIKit
import Then
import SnapKit

class FilterCellView: UIView {
    private let olderLabel = UILabel().then{
        $0.font = UIFont.notoSansRegularFont(ofSize: 14)
        $0.textColor = UIColor.black
    }
    private let checkImageView = UIImageView().then{
        $0.image = UIImage(named: "")
    }
    
    private func setLayout(){
        addSubview(olderLabel)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(olderText: String){
        super.init(frame: .zero)
        
    }

}
