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
        authModel.login(with: email, and: password) { [weak self] _, error in
            if let error = error {
                print(error.localizedDescription)
                self?.showAlertView(withTitle: "ログインエラー", andMessage: "ログインできませんでした。")
                return
            }

            self?.goToList()
        }
    }

    @IBAction private func signupButtonPressed() {
        let signupVC = UIStoryboard(name: "SignupViewController", bundle: nil).instantiateInitialViewController() as! SignupViewController
        guard let nav = navigationController else {
            fatalError("NavigationController doesn't exist.")
        }
        nav.pushViewController(signupVC, animated: true)
    }

    // MARK: - Segue
    private func goToList() {
        dismiss(animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
