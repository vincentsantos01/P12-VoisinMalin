//
//  FirebaseAuthServiceManager.swift
//  VoisinMalin
//
//  Created by vincent on 04/10/2021.
//

import Foundation

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
