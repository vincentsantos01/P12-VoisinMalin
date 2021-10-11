//
//  FirestoreDatabaseManager.swift
//  VoisinMalin
//
//  Created by vincent on 04/10/2021.
//

import Foundation
import Firebase

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
