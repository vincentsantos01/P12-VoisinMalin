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
        
        let isValidEmail = TestValues.validEmailAdress(emailAdressString: mailTextField.text!.trimmingCharacters(in: .whitespaces))
        let isValidPassword = TestValues.isValidPassword(password: passwordTextField.text?.trimmingCharacters(in: .whitespaces))

        print(isValidEmail)
        print(isValidPassword)
        
        if isValidEmail == false && isValidPassword == false {
            presentAlert(titre: "error", message: "Mail et mot de passe incorecte")
        }
        if isValidEmail == false {
            presentAlert(titre: "error", message: "Mail incorecte")
        }
        if isValidPassword == false {
            presentAlert(titre: "error", message: "Mot de passe incorecte")
        }
        if isValidEmail == true && isValidPassword == true {
            signUp()
        }
    }
    
    
    private func signUp() {
        if let email = mailTextField.text, let password = passwordTextField.text, let userName = usernameTextField.text {
            authService.signUp(userName: userName, email: email, password: password) { success in
                if success {
                    self.performSegue(withIdentifier: "UnwindToSignInViewController", sender: nil)
                } else {
                    self.presentAlert(titre: "Erreur", message: "Compte non creer")
                }
            }
        }
    }
    
    private func fieldIsNotEmpty(_ textField: [UITextField]) -> Bool {
        for item in textField {
            guard !item.text!.isEmpty else {
                return false
            }
        }
        return true
    }
}
extension AuthentificationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
