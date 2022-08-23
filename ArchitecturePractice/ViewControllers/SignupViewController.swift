//
//  SignupViewController.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/22.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!

    private let authModel = AuthModel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        authModel.delegate = self
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //        if authModel.isUserVerified { goToList() }
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
        authModel.signup(with: email, and: password)
    }

    @IBAction private func loginButtonPressed() {
        goToLogin()
    }

    // MARK: - Segue
    private func goToLogin() {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }

    private func goToList() {
        performSegue(withIdentifier: "goToList", sender: self)
    }
}

extension SignupViewController: AuthModelDelegate {
    func emailVerificationDidSend() {
        // After checking a user is registered, segue to login
        goToLogin()
    }

    func errorDidOccur(error: Error) {
        print(error.localizedDescription)
        showAlertView(withTitle: "サインアップエラー", andMessage: "サインアップできませんでした。")
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
