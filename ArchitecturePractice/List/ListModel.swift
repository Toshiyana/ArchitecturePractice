//
//  ListModel.swift
//  ArchitecturePractice
//
//  Created by Toshiyana on 2022/08/21.
//

import FirebaseFirestore
import FirebaseAuth

struct List {
    var content: String
    var timestamp: Timestamp

    init(snap: DocumentSnapshot) {
        content = snap["content"] as! String
        timestamp = snap["timestamp"] as! Timestamp
    }
}

protocol ListModelInput {
    var snapList: [DocumentSnapshot] { get }
    var selectedSnapshot: DocumentSnapshot? { get set }
    func read(completion: @escaping(Error?) -> Void)
    func delete(at index: Int, completion: @escaping(Error?) -> Void)
}

class ListModel: ListModelInput {
    private let db: Firestore = Firestore.firestore()

    var snapList: [DocumentSnapshot] = []
    var selectedSnapshot: DocumentSnapshot?

    private var listener: ListenerRegistration?

    func read(completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        self.listener = db.collection("posts")
            .whereField("uid", isEqualTo: uid)
            //            .order(by: "timestamp") // whereFieldは同じtimestampじゃないと機能しない
            .addSnapshotListener(includeMetadataChanges: true, listener: { [weak self] snapshot, error in
                guard let snap = snapshot else {
                    print("DEBUG: Error fetching document:: \(error!)")
                    completion(error)
                    return
                }

                for diff in snap.documentChanges {
                    if diff.type == .added {
                        print("DEBUG: New data:: \(diff.document.data())")
                    }
                }
                self?.reload(with: snap)
                completion(nil)
            })
    }

    func delete(at index: Int, completion: @escaping(Error?) -> Void) {
        db.collection("posts")
            .document(snapList[index].documentID)
            .delete { [weak self] error in
                if let error = error {
                    completion(error)
                } else {
                    self?.snapList.remove(at: index) // TODO: Index out of rangeのエラー出た
                    completion(nil)
                }
            }
    }

    private func reload(with snap: QuerySnapshot) {
        if !snap.isEmpty {
            snapList.removeAll()
            for item in snap.documents {
                snapList.append(item)
            }
        }
    }
}
