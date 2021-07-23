//
//  ConnectionViewController.swift
//  VoisinMalin
//
//  Created by vincent on 23/07/2021.
//

import UIKit
import FirebaseAuth

class ConnectionViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var alreadyAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        styles()
        setupTextFieldManager()


    }
    
    func styles() {
        loginButton.layer.cornerRadius = 30
        loginButton.layer.borderWidth = 3
        loginButton.layer.borderColor = UIColor.white.cgColor
        alreadyAccountButton.layer.cornerRadius = 20
        alreadyAccountButton.layer.borderWidth = 3
        alreadyAccountButton.layer.borderColor = UIColor.white.cgColor
        signupButton.layer.cornerRadius = 30
        signupButton.layer.borderWidth = 3
        signupButton.layer.borderColor = UIColor.black.cgColor
    }
    func setupTextFieldManager() {
        userNameTextField.delegate = self
        PasswordTextField.delegate = self
        mailTextField.delegate = self
    }
    
    @IBAction func signupPressButton(_ sender: UIButton) {
        if userNameTextField.text != "" && mailTextField.text != "" && PasswordTextField.text != "" {
            
            
            Auth.auth().createUser(withEmail: mailTextField.text!, password: PasswordTextField.text!) { authResult, error in
                if error != nil {
                    print(error.debugDescription)
                } else {
                    print("Inscription de \(self.userNameTextField.text ?? "no name")")
                    self.performSegue(withIdentifier: "goHome", sender: self)
                }
            }
            
        } else {
            print("Error")
        }
    }
    @IBAction func alreadyPressButton(_ sender: UIButton) {
    }
    @IBAction func loginPressButton(_ sender: UIButton) {
        print("redirection login")
    }
    
    
    
    
    
    
}
extension ConnectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
