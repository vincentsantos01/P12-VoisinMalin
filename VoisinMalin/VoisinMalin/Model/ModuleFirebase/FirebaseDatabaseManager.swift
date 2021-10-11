//
//  FirebaseDatabaseManager.swift
//  VoisinMalin
//
//  Created by vincent on 04/10/2021.
//

import Foundation
import Firebase
import FirebaseStorage


final class DatabaseManager {
    
    
    private let database: DatabaseType
    private let databaseRef = Database.database(url: "https://p12voisinmalin-default-rtdb.europe-west1.firebasedatabase.app").reference().child("ads")
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    init(database: DatabaseType = FirestoreDatabase()) {
        self.database = database
    }
    
    func deleteDoc(document: String) {
        let ref = db.collection("ads").document()
        let idCurrentAd = ref.documentID
        db.collection("ads").document(idCurrentAd).delete() { err in
            if let err = err {
                print("error \(err)")
            } else {
                print("ok")
            }
        }
    }
    
    func getUserData(with uid: String, callback: @escaping (Result<[String: Any], Error>) -> Void) {
        database.getUserData(with: uid, callback: callback)
    }
}
