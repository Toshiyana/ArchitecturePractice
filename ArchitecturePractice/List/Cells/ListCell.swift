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

    func configure(title: String, date: Date) {
        titleLabel.text = title
        dateLabel.text = getString(from: date)
    }

    private func getString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
}
