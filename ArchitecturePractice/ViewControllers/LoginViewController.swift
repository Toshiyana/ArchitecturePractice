//
//  LoginViewController.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/22.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!

    private let authModel = AuthModel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        authModel.delegate = self
        setupUI()
    }

    // MARK: - Helpers
    private func setupUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    }

    // MARK: - Actions
    @IBAction private func loginButtonPressed() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        authModel.login(with: email, and: password)
    }

    // MARK: - Segue
    private func goToList() {
        performSegue(withIdentifier: "goToList", sender: self)
    }
}

extension LoginViewController: AuthModelDelegate {
    func didLogin() {
        goToList()
    }

    func errorDidOccur(error: Error) {
        print("Login error: \(error.localizedDescription)")
        showAlertView(withTitle: "ログインエラー", andMessage: "ログインできませんでした。")
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
