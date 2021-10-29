//
//  TabBarController.swift
//  VoisinMalin
//
//  Created by vincent on 05/08/2021.
//


import UIKit

final class TabBarController: UITabBarController {
   
    private let authService: AuthService = AuthService()
/// Check if user is log
    override func viewDidLoad() {
        super.viewDidLoad()
        print("")
        authService.isUserConnected { isConnected in
            if !isConnected {
                print("PAS CONNECTE")
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Authentification", bundle: nil)
                    let loginViewController = storyboard.instantiateViewController(identifier: "loginViewController")
                    loginViewController.modalPresentationStyle = .fullScreen
                    self.present(loginViewController, animated: true)
                }
            }
        }
    }
    
    
}
