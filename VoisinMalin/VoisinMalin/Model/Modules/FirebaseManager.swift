//
//  FirebaseManager.swift
//  VoisinMalin
//
//  Created by vincent on 29/07/2021.
//

import Foundation

import Firebase
import FirebaseStorage

protocol AuthType {
    var currentUID: String? { get }
    var userMail: String? { get }
    func signIn(email: String, password: String, callback: @escaping (Bool) -> Void)
    func signUp(userName: String, email: String, password: String, callback: @escaping (Bool) -> Void)
    func signOut(callback: @escaping (Bool) -> Void)
    func isUserConnected(callback: @escaping (Bool) -> Void)
}

protocol DatabaseType {
    func getUserData(with uid: String, callback: @escaping (Result<[String: Any], Error>) -> Void)
}

final class FirestoreDatabase: DatabaseType {

    func getUserData(with uid: String, callback: @escaping (Result<[String: Any], Error>) -> Void) {
        Firestore.firestore().collection("users").whereField("uid", isEqualTo: uid).getDocuments { querySnapshot, error in
            guard let data = querySnapshot?.documents.first?.data() else {
               // callback(.failure(error!))
                return
                
            }
            callback(.success(data))
        }
    }
}

final class AuthFirestore: AuthType {

    var currentUID: String? {
        return Auth.auth().currentUser?.uid
    }
    var userMail: String? {
        return Auth.auth().currentUser?.email
    }
    let db = Firestore.firestore()

    func signIn(email: String, password: String, callback: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            guard (authDataResult != nil), error == nil else {
                callback(false)
                return
            }
            callback(true)
        }
    }

    func signUp(userName: String, email: String, password: String, callback: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            guard let authDataResult = authDataResult, error == nil else {
                callback(false)
                return
            }
            let userInfo: [String: Any] = ["uid": authDataResult.user.uid, "username": userName]
            Firestore.firestore().collection("users").addDocument(data: userInfo)
            callback(true)
        }
    }

    func signOut(callback: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            callback(true)
        } catch {
            callback(false)
        }
    }

    func isUserConnected(callback: @escaping (Bool) -> Void) {
        _ = Auth.auth().addStateDidChangeListener { _, user in
            guard (user != nil) else {
                callback(false)
                return
            }
            callback(true)
        }
    }
}

final class AuthService {

    private let auth: AuthType
    var currentUID: String? { return auth.currentUID }
    var userMail: String? { return auth.userMail }

    init(auth: AuthType = AuthFirestore()) {
        self.auth = auth
    }

    func signIn(email: String, password: String, callback: @escaping (Bool) -> Void) {
        auth.signIn(email: email, password: password, callback: callback)
    }

    func signUp(userName: String, email: String, password: String, callback: @escaping (Bool) -> Void) {
        auth.signUp(userName: userName, email: email, password: password, callback: callback)
    }

    func signOut(callback: @escaping (Bool) -> Void) {
        auth.signOut(callback: callback)
    }

    func isUserConnected(callback: @escaping (Bool) -> Void) {
        auth.isUserConnected(callback: callback)
    }
    
}
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

