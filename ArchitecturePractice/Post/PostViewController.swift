//
//  PostViewController.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/21.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet private weak var textField: UITextField!

    private var presenter: PostPresenterInput!
    func inject(presenter: PostPresenterInput) {
        self.presenter = presenter
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.getSelectedPost()
    }

    private func setupUI() {
        textField.delegate = self
    }

    // MARK: - Actions
    @IBAction private func postButtonPressed() {
        guard let content = textField.text else { return }
        presenter.addPost(content: content)
    }

    @IBAction private func cancelButtonPressed() {
        dismiss(animated: true)
    }
}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension PostViewController: PostPresenterOutput {
    func showAlert(withTitle: String, andMessage: String) {
        showAlertView(withTitle: withTitle, andMessage: andMessage)
    }

    func showSelectedPost(text: String?) {
        textField.text = text
    }

    func dismiss() {
        dismiss(animated: true)
    }
}
