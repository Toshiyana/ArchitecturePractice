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

    private var listModel: ListModel?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if !AuthModel.isUserVerified { goToLogin() }
        setupModel()
        setupTableView()
        navigationItem.setHidesBackButton(true, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if listModel == nil {
            // After Logout, Login
            setupModel()
        } else {
            // After Posting (login status, listModel != nil)
            listModel?.selectedSnapshot = nil // これが実行されていない
        }
    }

    // MARK: - Helpers
    private func setupModel() {
        listModel = ListModel()
        listModel?.read { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                self?.showAlertView(withTitle: "データの読み込みエラー", andMessage: "データを読み込めませんでした。")
            } else {
                self?.tableView.reloadData()
            }
        }
    }

    private func setupTableView() {
        tableView.register(ListCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func goToPost() {
        let postVC = UIStoryboard(name: "PostViewController", bundle: nil).instantiateInitialViewController() as! PostViewController

        if let selectedSnap = listModel?.selectedSnapshot {
            let postModel = PostModel(with: Post(id: selectedSnap.documentID, content: selectedSnap["content"] as! String))

            postVC.postModel = postModel
        }

        let nav = UINavigationController(rootViewController: postVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

    private func goToLogin() {
        let loginVC = UIStoryboard(name: "LoginViewController", bundle: nil).instantiateInitialViewController() as! LoginViewController
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

    // MARK: - Actions
    @IBAction private func addButtonPressed() {
        goToPost()
    }

    @IBAction private func logoutButtonPressed() {
        AuthModel.logout { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                self?.showAlertView(withTitle: "ログアウトエラー", andMessage: "ログアウトできませんでした。")
            }
            self?.listModel = nil
            self?.goToLogin()
        }
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel?.snapList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ListCell

        if let snap = listModel?.snapList[indexPath.row] {
            print("DEBUG: snap:: \(snap)")
            let listData = List(snap: snap)
            cell.configure(title: listData.content, date: listData.timestamp.dateValue())
        }
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let listModel = listModel else { return }
        listModel.selectedSnapshot = listModel.snapList[indexPath.row]
        goToPost()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let listModel = listModel else { return }
        if editingStyle == .delete {
            listModel.delete(at: indexPath.row) { [weak self] error in
                if let error = error {
                    // snapshotListenerを用いているので、オフラインでも削除できるので基本的にエラーになることはない気がするのでこのエラーハンドリングは必要か？
                    // <- オフラインからオンラインになったときにデータが同期される?
                    print(error.localizedDescription)
                    self?.showAlertView(withTitle: "データの削除エラー", andMessage: "データを削除できませんでした。")
                } else {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
}

extension ListViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("DEBUG: modal was dismissed")
    }
}
