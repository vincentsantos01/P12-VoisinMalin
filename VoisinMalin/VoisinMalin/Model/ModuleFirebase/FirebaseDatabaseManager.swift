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

    func getUserData(with uid: String, callback: @escaping (Result<[String: Any], Error>) -> Void) {
        database.getUserData(with: uid, callback: callback)
    }
}
protocol DatabaseType {
    func getUserData(with uid: String, callback: @escaping (Result<[String: Any], Error>) -> Void)
}

final class FirestoreDatabase: DatabaseType {
    
    func getUserData(with uid: String, callback: @escaping (Result<[String: Any], Error>) -> Void) {
        Firestore.firestore().collection("users").whereField("uid", isEqualTo: uid).getDocuments { querySnapshot, error in
            guard let data = querySnapshot?.documents.first?.data() else {
                return
                
            }
            callback(.success(data))
        }
    }
}
