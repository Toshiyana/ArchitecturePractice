//
//  NibLodableView.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/20.
//

import UIKit

protocol NibLodableView: AnyObject {}

extension NibLodableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UITableViewCell: NibLodableView {}
extension UICollectionViewCell: NibLodableView {}
