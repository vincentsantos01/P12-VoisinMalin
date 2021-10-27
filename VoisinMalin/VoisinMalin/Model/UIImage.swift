//
//  UIImage.swift
//  VoisinMalin
//
//  Created by vincent on 21/07/2021.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
