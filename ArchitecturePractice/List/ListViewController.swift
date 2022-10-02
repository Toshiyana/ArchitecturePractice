//
//  ListViewController.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/19.
//

import UIKit

final class ListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addButton: UIBarButtonItem!

    private var presenter: ListPresenterInput!
    func inject(presenter: ListPresenterInput) {
        self.presenter = presenter
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.checkUserVerification()
        setupTableView()
        navigationItem.setHidesBackButton(true, animated: true)
        presenter.readPost()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    // MARK: - Helpers
    private func setupTableView() {
        tableView.register(ListCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func goToPost() {
        // 新規で追加する時。postVCのpresenterはnil。
        let postVC = UIStoryboard(name: "PostViewController", bundle: nil).instantiateInitialViewController() as! PostViewController
        let nav = UINavigationController(rootViewController: postVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

    // MARK: - Actions
    @IBAction private func addButtonPressed() {
        presenter.addButtonPressed()
    }

    @IBAction private func logoutButtonPressed() {
        presenter.didLogOut()
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfPosts
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ListCell
        let listData = presenter.post(forRow: indexPath.row)
        cell.configure(title: listData.content,
                       date: listData.timestamp.dateValue())
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deletePost(at: indexPath)
        }
    }
}

extension ListViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("DEBUG: modal was dismissed")
    }
}

extension ListViewController: ListPresenterOutput {
    func transitionToPost(postModel: PostModel?) {
        let postVC = UIStoryboard(name: "PostViewController", bundle: nil).instantiateInitialViewController() as! PostViewController

        let presenter = PostPresenter(view: postVC,
                                      model: postModel)
        postVC.inject(presenter: presenter)

        let nav = UINavigationController(rootViewController: postVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

    func transitionToLogin() {
        let loginVC = UIStoryboard(name: "LoginViewController", bundle: nil).instantiateInitialViewController() as! LoginViewController
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

    func showAlert(withTitle: String, andMessage: String) {
        showAlertView(withTitle: withTitle, andMessage: andMessage)
    }

    func reloadTableData() {
        tableView.reloadData()
    }

    func deleteRows(at indexPaths: [IndexPath]) {
        tableView.deleteRows(at: indexPaths, with: .fade)
    }
}
