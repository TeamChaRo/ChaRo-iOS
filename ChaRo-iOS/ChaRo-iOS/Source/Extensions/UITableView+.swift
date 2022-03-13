//
//  Extension+UITableView.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2021/06/29.
//

import UIKit

extension UITableView {
    
    public func registerCustomXib(xibName: String){
        let xib = UINib(nibName: xibName, bundle: nil)
        self.register(xib, forCellReuseIdentifier: xibName)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable Dequeue Reusable")
        }
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withType cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.className, for: indexPath) as? T else {
            fatalError("Could not find cell with reuseID \(T.className)")
        }
        return cell
    }
    
    func register<T>(cell: T.Type,
                     forCellReuseIdentifier reuseIdentifier: String = T.className) where T: UITableViewCell{
        register(cell, forCellReuseIdentifier: reuseIdentifier)
    }
    
    
//    func dismissKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer =
//            UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        self.addGestureRecognizer(tap)
//    }
//    
//    @objc func dismissKeyboard() {
//        self.endEditing(true)
//    }
    
}
