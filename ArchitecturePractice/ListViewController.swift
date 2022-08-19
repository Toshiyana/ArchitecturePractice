//
//  ListViewController.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/19.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    let data = ["1", "2", "3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ListCell.self)
    }
}
