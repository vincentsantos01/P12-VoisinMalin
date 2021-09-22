//
//  LoginViewController.swift
//  VoisinMalin
//
//  Created by vincent on 23/07/2021.
//

import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginMailTexfield: UITextField!
    @IBOutlet weak var loginPasswordTextfield: UITextField!
    @IBOutlet weak var LoginViewButton: UIButton!
    @IBOutlet weak var noAccountButton: UIButton!
    
    private let authService: AuthService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        styles()
        setupTextFieldManager()
        
    }
    func styles() {
        LoginViewButton.layer.cornerRadius = 30
        LoginViewButton.layer.borderWidth = 3
        LoginViewButton.layer.borderColor = UIColor.black.cgColor
    }
    func setupTextFieldManager() {
        loginMailTexfield.delegate = self
        loginPasswordTextfield.delegate = self
    }
    
    
    @IBAction func loginViewPressButton(_ sender: UIButton) {
        
        
        guard let login = loginMailTexfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = loginPasswordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        authService.signIn(email: login, password: password) { isSuccess in
            if isSuccess {
                self.dismiss(animated: true)
            } else {
                self.presentAlert(titre: "Erreur", message: "Mail ou mot de passe invalide")
            }
        }
    }
    
    @IBAction private func unwindToSignInViewController(_ segue: UIStoryboardSegue) { dismiss(animated: false) }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
