//
//  AuthModel.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/22.
//

import FirebaseAuth

typealias FirestoreCompletion = ((AuthDataResult?, Error?) -> Void)

// escapingを使う必要ない気がする。escapingを使うとclosureを保持するためにメモリを消費するので、パフォーマンスの観点から不要な場合はつけない方がよいっぽい
class AuthModel {
    static var isUserVerified: Bool {
        return (Auth.auth().currentUser != nil) ? true : false
    }

    static func signup(with email: String, and password: String, completion: @escaping(FirestoreCompletion)) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }

    static func login(with email: String, and password: String, completion: @escaping(FirestoreCompletion)) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }

    static func logout(completion: @escaping(Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
