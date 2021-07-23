//
//  LoginViewController.swift
//  VoisinMalin
//
//  Created by vincent on 23/07/2021.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginMailTexfield: UITextField!
    @IBOutlet weak var loginPasswordTextfield: UITextField!
    @IBOutlet weak var LoginViewButton: UIButton!
    
    

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
        Auth.auth().signIn(withEmail: loginMailTexfield.text!, password: loginPasswordTextfield.text!) { authResult, error in
            if error != nil {
                print(error.debugDescription)
            } else {
                self.performSegue(withIdentifier: "goHomeConnected", sender: self)
            }
        }
    }
    
    
    
    
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
