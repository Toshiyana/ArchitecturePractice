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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let post = postModel.selectedPost {
            textField.text = post.content
        }
    }

    // MARK: - Helpers
    private func setupModel() {
        if postModel == nil {
            // In adding post for the first time
            postModel = PostModel()
        }
        postModel.delegate = self
    }

    private func setupUI() {
        textField.delegate = self
    }

    // MARK: - Actions
    @IBAction private func postButtonPressed() {
        guard let content = textField.text else { return }
        postModel.post(with: content)
    }
}

extension PostViewController: PostModelDelegate {
    func didPost() {
        print("Document added")
        dismiss(animated: true)
    }

    func errorDidOccur(error: Error) {
        print(error.localizedDescription)
    }
}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
