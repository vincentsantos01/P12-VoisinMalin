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

