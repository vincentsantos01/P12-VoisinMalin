//
//  ConnectionViewController.swift
//  VoisinMalin
//
//  Created by vincent on 23/07/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ConnectionViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        styles()
        setupTextFieldManager()
       // if Auth.auth().currentUser?.email != nil {
           // print("connecté")
           // performSegue(withIdentifier: "goHome", sender: self)
       // }


    }
    
    func styles() {
        loginButton.layer.cornerRadius = 30
        loginButton.layer.borderWidth = 3
        loginButton.layer.borderColor = UIColor.white.cgColor
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
        let cleanedPassword = PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if Password.isPasswordValid(cleanedPassword!) == false {
            return presentAlert(titre: "error", message: "Merci de retren un mot de plasse qui contien 8 caracteres, un caractere special et un chiffre.")
        }
            
            
            Auth.auth().createUser(withEmail: mailTextField.text!, password: PasswordTextField.text!) { authResult, error in
                if error != nil {
                    print(error.debugDescription)
                    self.presentAlert(titre: "Mail invalide", message: "Veuillez entrer un mail de type exemple@monmail.com")
                } else {
                    print("Inscription de \(self.userNameTextField.text ?? "no name")")
                    
                    let ref = Database.database(url: "https://p12voisinmalin-default-rtdb.europe-west1.firebasedatabase.app").reference()
                    let userid = Auth.auth().currentUser?.uid
                    ref.child("users").child(userid!).setValue(["username": self.userNameTextField.text!])
                    
                    self.performSegue(withIdentifier: "goLunch", sender: self)
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
