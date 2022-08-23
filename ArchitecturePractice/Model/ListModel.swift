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

protocol ListModelDelegate: AnyObject {
    func listDidChnage()
    func errorDidOccur(error: Error)
}

class ListModel {
    private let db: Firestore = Firestore.firestore()

    var snapList: [DocumentSnapshot] = []
    var selectedSnapshot: DocumentSnapshot?

    private var listener: ListenerRegistration?

    weak var delegate: ListModelDelegate?

    func read() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        self.listener = db.collection("posts")
            .whereField("uid", isEqualTo: uid)
            //            .order(by: "timestamp") // whereFieldは同じtimestampじゃないと機能しない
            .addSnapshotListener(includeMetadataChanges: true, listener: { [unowned self] snapshot, error in
                guard let snap = snapshot else {
                    print("Error fetching document: \(error!)")
                    self.delegate?.errorDidOccur(error: error!)
                    return
                }

                for diff in snap.documentChanges {
                    if diff.type == .added {
                        print("New data: \(diff.document.data())")
                    }
                }
                print("Current data: \(snap)")
                self.reload(with: snap)
            })
    }

    func delete(at index: Int) {
        db.collection("posts")
            .document(snapList[index].documentID)
            .delete()

        snapList.remove(at: index)
    }

    private func reload(with snap: QuerySnapshot) {
        if !snap.isEmpty {
            snapList.removeAll()
            for item in snap.documents {
                snapList.append(item)
            }
            delegate?.listDidChnage()
        }
    }
}
