//
//  SignupViewController.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/22.
//

import UIKit

// MVC architecture
class SignupViewController: UIViewController {
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
    @IBAction private func signupButtonPressed() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        authModel.signup(with: email, and: password) { [weak self] _, error in
            if let error = error {
                print(error.localizedDescription)
                self?.showAlertView(withTitle: "サインアップエラー", andMessage: "サインアップできませんでした。")
                return
            }

            self?.goToLogin()
        }
    }

    @IBAction private func loginButtonPressed() {
        goToLogin()
    }

    // MARK: - Segue
    private func goToLogin() {
        navigationController?.popViewController(animated: true)
    }

    private func goToList() {
        let listVC = UIStoryboard(name: "ListViewController", bundle: nil).instantiateInitialViewController() as! ListViewController
        guard let nav = navigationController else {
            fatalError("NavigationController doesn't exist.")
        }
        nav.pushViewController(listVC, animated: true)
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
