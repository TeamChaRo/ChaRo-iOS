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

extension UITableViewCell {
    func getTableCellIndexPath() -> Int {
        if let superView = self.superview as? UITableView {
            return superView.indexPath(for: self)?.row ?? 0
        } else {
            return -1
        }
    }
    
    func getTableSectionIndexPath() -> Int {
        if let superView = self.superview as? UITableView {
            return superView.indexPath(for: self)?.section ?? 0
        } else {
            return -1
        }
    }
}

