//
//  ListViewController.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/19.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addButton: UIBarButtonItem!

    private let listModel = ListModel()
    private let authModel = AuthModel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModel()
        setupTableView()
        navigationItem.setHidesBackButton(true, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listModel.selectedSnapshot = nil
    }

    // MARK: - Helpers
    private func setupModel() {
        listModel.delegate = self
        listModel.read()
    }

    private func setupTableView() {
        tableView.register(ListCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPost" {
            guard let postVC = segue.destination as? PostViewController,
                  let snap = listModel.selectedSnapshot else {
                return
            }

            let postModel = PostModel(with: Post(id: snap.documentID, content: snap["content"] as! String))

            postVC.postModel = postModel
        }
    }

    private func goToPost() {
        performSegue(withIdentifier: "goToPost", sender: self)
    }

    // MARK: - Actions
    @IBAction private func addButtonPressed() {
        goToPost()
    }

    @IBAction private func logoutButtonPressed() {
        // TODO:
    }
}

extension ListViewController: ListModelDelegate {
    func listDidChnage() {
        tableView.reloadData()
    }

    func errorDidOccur(error: Error) {
        print(error.localizedDescription)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.snapList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ListCell

        let snap = listModel.snapList[indexPath.row]
        let listData = List(snap: snap)
        cell.configure(title: listData.content, date: listData.timestamp.dateValue())
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listModel.selectedSnapshot = listModel.snapList[indexPath.row]
        goToPost()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listModel.delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
