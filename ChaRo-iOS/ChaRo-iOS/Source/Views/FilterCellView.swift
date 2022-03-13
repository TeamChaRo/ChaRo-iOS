import Foundation
import UIKit
import Then
import SnapKit

enum FilterCellType{
    case newOrderCell
    case populationOrderCell
}


class FilterCellView: UIView {
    private var orderLabel = UILabel().then{
        $0.font = UIFont.notoSansRegularFont(ofSize: 14)
        $0.textColor = UIColor.gray40
    }
    private let checkImageView = UIImageView().then{
        $0.image = ImageLiterals.icBlueCheck
    }
    private let bottomLineView = UIView().then{
        $0.backgroundColor = UIColor.gray20
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(type: FilterCellType){
        super.init(frame: .zero)
        setCellType(type: type)
    }
    func resetCellColor () {
        orderLabel.textColor = UIColor.gray40
        backgroundColor = UIColor.white
        checkImageView.isHidden = true
    }
    
    func selectCellColor () {
        orderLabel.textColor = UIColor.mainBlue
        checkImageView.isHidden = false
        backgroundColor = UIColor.mainBlue.withAlphaComponent(0.2)
    }
    
    private func setCellType(type: FilterCellType){
        setCellLayout()
        switch type {
        case .newOrderCell:
            orderLabel.text = "최신순"
            checkImageView.isHidden = true
        default:
            orderLabel.text = "인기순"
            orderLabel.textColor = UIColor.mainBlue
            backgroundColor = UIColor.mainBlue.withAlphaComponent(0.2)
        }
    }
    private func setCellLayout(){
        addSubviews([orderLabel, checkImageView, bottomLineView])
        orderLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(22)
            $0.width.equalTo(39)
        }
        checkImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(22)
        }
        bottomLineView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().offset(1)
        }
    }
    
    
   

}
