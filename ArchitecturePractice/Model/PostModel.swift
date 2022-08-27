//
//  Post.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/20.
//

import FirebaseAuth
import FirebaseFirestore

struct Post {
    var id: String
    var content: String
}

class PostModel {
    private let db: Firestore
    let selectedPost: Post?

    init(with selectedPost: Post? = nil) {
        self.selectedPost = selectedPost
        db = Firestore.firestore()
        db.settings.isPersistenceEnabled = true // オフラインの永続性を有効化（default）
    }

    func addNewPost(with content: String, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: Current user isn't exist.")
            return
        }

        // idは勝手に割り振られる
        db.collection("posts")
            .addDocument(data: [
                "uid": uid,
                "content": content,
                "timestamp": Timestamp(date: Date())
            ], completion: completion)
    }

    func updatePost(with content: String, completion: @escaping(Error?) -> Void) {
        if let post = selectedPost {
            db.collection("posts").document(post.id)
                .updateData([
                    "content": content,
                    "timestamp": Timestamp(date: Date())
                ], completion: completion)
        }
    }
}
