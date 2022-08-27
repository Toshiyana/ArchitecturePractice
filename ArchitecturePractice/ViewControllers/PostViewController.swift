//
//  PostViewController.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/21.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet private weak var textField: UITextField!

    var postModel: PostModel!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModel()
        setupUI()

        if let post = postModel.selectedPost {
            textField.text = post.content
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Helpers
    private func setupModel() {
        if postModel == nil {
            // In adding post for the first time
            postModel = PostModel()
        }
    }

    private func setupUI() {
        textField.delegate = self
    }

    // MARK: - Actions
    @IBAction private func postButtonPressed() {
        guard let content = textField.text else { return }

        if postModel.selectedPost == nil {
            addNewPost(content: content)
        } else {
            updatePost(content: content)
        }
    }

    @IBAction private func cancelButtonPressed() {
        dismiss(animated: true)
    }

    // MARK: - API
    private func addNewPost(content: String) {
        postModel.addNewPost(with: content) { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                self?.showAlertView(withTitle: "追加エラー", andMessage: "追加に失敗しました。")
            } else {
                self?.dismiss(animated: true)
            }
        }
    }

    private func updatePost(content: String) {
        postModel.updatePost(with: content) { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
                self?.showAlertView(withTitle: "更新エラー", andMessage: "更新に失敗しました。")
            } else {
                self?.dismiss(animated: true)
            }
        }
    }
}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
