//
//  ListCell.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/19.
//

import UIKit

class ListCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    func configure(title: String, date: String) {
        titleLabel.text = title
        dateLabel.text = date
    }
}
