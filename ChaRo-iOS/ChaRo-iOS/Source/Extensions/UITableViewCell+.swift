//
//  Extension+UITableViewCell.swift
//  ChaRo-iOS
//
//  Created by JEN Lee on 2021/07/04.
//

import Foundation
import UIKit

protocol ReusableTableViewCell {
    static var reuseIdentifier: String { get }
}
extension ReusableTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
extension UITableViewCell: ReusableTableViewCell { }

extension UITableViewCell{
    
    func getTableCellIndexPath() -> Int {
        var indexPath = 0
        
        guard let superView = self.superview as? UITableView else {
            return -1
        }
        indexPath = superView.indexPath(for: self)!.row

        return indexPath
    }
    
    func getTableSectionIndexPath() -> Int {
        var indexPath = 0
        
        guard let superView = self.superview as? UITableView else {
            return -1
        }
        indexPath = superView.indexPath(for: self)!.section

        return indexPath
    }
    
}

