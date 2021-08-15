//
//  ConnectionViewController.swift
//  VoisinMalin
//
//  Created by vincent on 23/07/2021.
//

import UIKit

class AuthentificationViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    private let authService: AuthService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styles()
        setupTextFieldManager()
    }
    
    
    func styles() {
        signUpButton.layer.cornerRadius = 30
        signUpButton.layer.borderWidth = 3
        signUpButton.layer.borderColor = UIColor.black.cgColor
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    func setupTextFieldManager() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        mailTextField.delegate = self
    }
    
    @IBAction func signupPressButton(_ sender: UIButton) {
        
        
        guard let userName = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let email = mailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        authService.signUp(userName: userName, email: email, password: password) { isSuccess in
            if isSuccess {
                self.performSegue(withIdentifier: "UnwindToSignInViewController", sender: nil)
            } else {
                self.presentAlert(titre: "Erreur", message: "Compte non creer")
            }
            
        }
    }
}
extension AuthentificationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
