import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    //MARK:- properties
    //sticky(스크롤 되어도 상위 고정) 되어야 할 item의 index
    var stickyIndexPath: IndexPath? {
        didSet {
            invalidateLayout()
        }
    }
    
    //MARK:- init
    required init(stickyIndexPath: IndexPath?) {
        super.init()
        self.stickyIndexPath = stickyIndexPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- override func
    // 스크롤 할 때마다 layout 재설정
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        if let stickyAttributes = getStickyAttributes(at: stickyIndexPath) {
            layoutAttributes?.append(stickyAttributes)
        }
        
        return layoutAttributes
    }
    
    //MARK:- private func
    private func getStickyAttributes(at indexPath: IndexPath?) -> UICollectionViewLayoutAttributes? {
        //stickyIndex에 해당하는 item의 layoutAttributes을 받음
        guard let collectionView = collectionView,
              let stickyIndexPath = indexPath,
              let stickyAttributes = layoutAttributesForItem(at: stickyIndexPath)?.copy() as? UICollectionViewLayoutAttributes
              else {
            return nil
        }
        
        // 받아온 layoutAttributes의 minY 값보다 더 scroll 된다면,
        // 1. 해당 attribute의 y값 조정을 통해 collectionView의 상위에 sticky 되어있는 것처럼 보이게하고,
        // 2. zIndex 조절을 통해 z축 상위로 올림.
        if collectionView.contentOffset.y > stickyAttributes.frame.minY {
            var frame = stickyAttributes.frame
            frame.origin.y = collectionView.contentOffset.y
            stickyAttributes.frame = frame
            stickyAttributes.zIndex = 1
            return stickyAttributes
        }
        return nil
    }
}
