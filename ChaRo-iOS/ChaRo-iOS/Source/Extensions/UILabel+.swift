import UIKit

extension UILabel {
    func maxNumberOfLines(width: CGFloat) -> Int {
        print(width, "cellFrame")
        let maxSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
