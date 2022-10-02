//
//  AuthModel.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/22.
//

import FirebaseAuth

typealias FirestoreCompletion = ((AuthDataResult?, Error?) -> Void)

protocol AuthModelInput {
    var isUserVerified: Bool { get }
    func signup(with email: String, and password: String, completion: @escaping(FirestoreCompletion))
    func login(with email: String, and password: String, completion: @escaping(FirestoreCompletion))
    func logout(completion: @escaping(Error?) -> Void)
}

// escapingを使う必要ない気がする。escapingを使うとclosureを保持するためにメモリを消費するので、パフォーマンスの観点から不要な場合はつけない方がよいっぽい
final class AuthModel: AuthModelInput {
    var isUserVerified: Bool {
        return (Auth.auth().currentUser != nil) ? true : false
    }

    func signup(with email: String, and password: String, completion: @escaping(FirestoreCompletion)) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }

    func login(with email: String, and password: String, completion: @escaping(FirestoreCompletion)) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }

    func logout(completion: @escaping(Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
