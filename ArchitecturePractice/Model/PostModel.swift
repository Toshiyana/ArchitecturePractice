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
    //    var user: String
    var content: String
}

protocol PostModelDelegate: AnyObject {
    func didPost()
    func errorDidOccur(error: Error)
}

class PostModel {
    private let db: Firestore
    let selectedPost: Post?

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
                    "timestamp": Timestamp(date: Date())
                ]) { [unowned self] error in
                    if let error = error {
                        self.delegate?.errorDidOccur(error: error)
                        return
                    }
                    self.delegate?.didPost()
                }
        } else {
            //            guard let uid = Auth.auth().currentUser?.uid else {
            //                print("DEBUG: Current user isn't exist.")
            //                return
            //            }

            // idは勝手に割り振られる
            db.collection("posts")
                .addDocument(data: [
                    //                    "user": uid,
                    "content": content,
                    "timestamp": Timestamp(date: Date())
                ]) { [unowned self] error in
                    if let error = error {
                        self.delegate?.errorDidOccur(error: error)
                        return
                    }
                    self.delegate?.didPost()
                }
        }
    }
}
