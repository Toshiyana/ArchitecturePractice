//
//  ReusableView.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/20.
//

import UIKit

protocol ReusableView: AnyObject {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
extension UICollectionViewCell: ReusableView {}
