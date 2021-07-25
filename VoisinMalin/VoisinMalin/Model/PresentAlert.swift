//
//  PresentAlert.swift
//  VoisinMalin
//
//  Created by vincent on 25/07/2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAlert(titre: String, message: String) {
        let alertVC = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

