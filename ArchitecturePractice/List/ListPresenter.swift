//
//  ListPresenter.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/27.
//

import Foundation

protocol ListPresenterInput {
    var posts: [List] { get }
    var numberOfPosts: Int { get }
    func post(forRow row: Int) -> List
    func didSelectRow(at indexPath: IndexPath)
    func readPost()
    func deletePost(at indexPath: IndexPath)
    func viewWillAppear()
    func addButtonPressed()
    func didLogOut()
    func checkUserVerification()
}

protocol ListPresenterOutput: AnyObject {
    func transitionToPost(postModel: PostModel?)
    func transitionToLogin()
    func showAlert(withTitle: String, andMessage: String)
    func reloadTableData()
    func deleteRows(at indexPaths: [IndexPath])
}

final class ListPresenter: ListPresenterInput {
    private weak var view: ListPresenterOutput!
    private var model: ListModelInput?
    private var authModel: AuthModelInput

    init(view: ListPresenterOutput, model: ListModelInput, authModel: AuthModelInput) {
        self.view = view
        self.model = model
        self.authModel = authModel
    }

    //    var isUserVerified: Bool {
    //        authModel.isUserVerified
    //    }

    private(set) var posts: [List] = []

    var numberOfPosts: Int {
        return posts.count
    }

    func post(forRow row: Int) -> List {
        return posts[row]
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard let modelForSnap = model else { return }
        let snapList = modelForSnap.snapList[indexPath.row]
        model?.selectedSnapshot = snapList
        guard let selectedSnap = modelForSnap.selectedSnapshot else { return }
        let postModel = PostModel(with: Post(id: selectedSnap.documentID, content: selectedSnap["content"] as! String))
        view.transitionToPost(postModel: postModel)
    }

    func readPost() {
        model?.read { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                self?.view.showAlert(withTitle: "データの読み込みエラー", andMessage: "データを読み込めませんでした。")
            } else {
                self?.posts = self?.model?.snapList.map { List(snap: $0) } ?? []
                self?.view.reloadTableData()
            }
        }
    }

    func deletePost(at indexPath: IndexPath) {
        model?.delete(at: indexPath.row, completion: { [weak self] error in
            if let error = error {
                // snapshotListenerを用いているので、オフラインでも削除できるので基本的にエラーになることはない気がするのでこのエラーハンドリングは必要か？
                // <- オフラインからオンラインになったときにデータが同期される?
                print(error.localizedDescription)
                self?.view.showAlert(withTitle: "データの削除エラー", andMessage: "データを削除できませんでした。")
            } else {
                //                self?.view.deleteRows(at: [indexPath]) // TODO: アニメーションつけたいが、Index out of rangeのエラー出る
                self?.view.reloadTableData()
            }
        })
    }

    func viewWillAppear() {
        if model == nil {
            // After Logout, Login
            model = ListModel() // initialization
            readPost()
        } else {
            // After Posting (login status, listModel != nil)
            model?.selectedSnapshot = nil // これが実行されていない
        }
    }

    func addButtonPressed() {
        // add new post
        view.transitionToPost(postModel: nil)
    }

    func didLogOut() {
        authModel.logout { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                print(error.localizedDescription)
                strongSelf.view.showAlert(withTitle: "ログアウトエラー", andMessage: "ログアウトできませんでした。")
            }
            strongSelf.model = nil
            strongSelf.view.transitionToLogin()
        }
    }

    func checkUserVerification() {
        if !authModel.isUserVerified {
            view.transitionToLogin()
        }
    }
}
