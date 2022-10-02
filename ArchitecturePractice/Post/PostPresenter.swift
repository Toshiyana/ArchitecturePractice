//
//  PostPresenter.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/09/30.
//

import Foundation

protocol PostPresenterInput {
    func getSelectedPost()
    func addPost(content: String)
}

protocol PostPresenterOutput: AnyObject {
    func showAlert(withTitle: String, andMessage: String)
    func showSelectedPost(text: String?)
    func dismiss()
}

final class PostPresenter: PostPresenterInput {
    private weak var view: PostPresenterOutput!
    private var model: PostModelInput? // 新規追加の時は最初nil

    init(view: PostPresenterOutput, model: PostModelInput?) {
        self.view = view
        self.model = model
    }

    func getSelectedPost() {
        if let model = model {
            view.showSelectedPost(text: model.selectedPost?.content)
        } else {
            // 新規で追加する時
            model = PostModel()
        }
    }

    func addPost(content: String) {
        if model?.selectedPost == nil {
            addNewPost(content: content)
        } else {
            updatePost(content: content)
        }
    }

    private func addNewPost(content: String) {
        model?.addNewPost(with: content) { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                self?.view.showAlert(withTitle: "追加エラー", andMessage: "追加に失敗しました。")
            } else {
                self?.view.dismiss()
            }
        }
    }

    private func updatePost(content: String) {
        model?.updatePost(with: content) { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                self?.view.showAlert(withTitle: "更新エラー", andMessage: "更新に失敗しました。")
            } else {
                self?.view.dismiss()
            }
        }
    }
}
