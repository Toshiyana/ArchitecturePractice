//
//  AuthModel.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/22.
//

import FirebaseAuth

@objc protocol AuthModelDelegate: AnyObject {
    @objc optional func didLogin()
    @objc optional func didLogout()
    @objc optional func emailVerificationDidSend()
    func errorDidOccur(error: Error)
}

class AuthModel {
    weak var delegate: AuthModelDelegate?

    var isUserVerified: Bool {
        return (Auth.auth().currentUser == nil) ? false : true
    }

    func signup(with email: String, and password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.delegate?.errorDidOccur(error: error)
                return
            }
            guard let user = result?.user else { return }
            // check registering new user in firebase db
            self.sendEmailVerification(to: user)
        }
    }

    func login(with email: String, and password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] (_, error) in
            if let error = error {
                self.delegate?.errorDidOccur(error: error)
            }
            self.delegate?.didLogin?()
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            delegate?.didLogin?()
        } catch {
            print("Failed to log out. \(error.localizedDescription)")
            delegate?.errorDidOccur(error: error)
        }
    }

    private func sendEmailVerification(to user: User) {
        user.sendEmailVerification { [unowned self] error in
            if let error = error {
                self.delegate?.errorDidOccur(error: error)
                return
            }
            self.delegate?.emailVerificationDidSend?()
        }
    }
}
