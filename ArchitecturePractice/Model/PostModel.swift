//
//  Post.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct Post {
    var id: String
    var user: String
    var content: String
    var date: Date
}

protocol PostModelDelegate: AnyObject {
    func didPost()
    func errorDidOccur(error: Error)
}

class PostModel {
    private let db: Firestore
    private let selectedPost: Post?

    weak var delegate: PostModelDelegate?

    init(with selectedPost: Post? = nil) {
        self.selectedPost = selectedPost
        db = Firestore.firestore()
        db.settings.isPersistenceEnabled = true // オフラインの永続性を有効化（default）
    }

    func post(with content: String) {
        if let post = selectedPost {
            db.collection("posts").document(post.id)
                .updateData([
                    "content": content,
                    "date": Date()
                ]) { [weak self] error in
                    guard let strongSelf = self else { return }
                    if let error = error {
                        strongSelf.delegate?.errorDidOccur(error: error)
                        return
                    }
                    strongSelf.delegate?.didPost()
                }
        } else {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }

            // idは勝手に割り振られる
            db.collection("posts")
                .addDocument(data: [
                    "user": uid,
                    "content": content,
                    "date": Date()
                ]) { [weak self] error in
                    guard let strongSelf = self else { return }
                    if let error = error {
                        strongSelf.delegate?.errorDidOccur(error: error)
                        return
                    }
                    strongSelf.delegate?.didPost()
                }
        }
    }
}
