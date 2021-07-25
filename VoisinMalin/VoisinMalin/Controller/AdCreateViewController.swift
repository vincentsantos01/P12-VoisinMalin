//
//  AdCreateViewController.swift
//  VoisinMalin
//
//  Created by vincent on 25/07/2021.
//
import Foundation
import UIKit

class AdCreateViewController: UIViewController {

    
    @IBOutlet weak var uploadImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func uploadPressButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
}
extension AdCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")]as? UIImage {
            uploadImage.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
