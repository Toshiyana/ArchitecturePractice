//
//  UIViewController+Extensions.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/23.
//

import UIKit

extension UIViewController {
    func showAlertView(withTitle title: String?, andMessage message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
