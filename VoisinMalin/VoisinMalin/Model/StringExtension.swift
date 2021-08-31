//
//  StringExtension.swift
//  VoisinMalin
//
//  Created by vincent on 31/08/2021.
//

import Foundation

extension String {
    
    /// Parametre qui permets de ne pas pouvoir mettre d'espaces dans le textfield
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespaces) == String() ? true : false
    }
    /// Parametre qui permets de ne pas pouvoir mettre de nombres dans le textfield
    var isNumeric: Bool {
        return self.trimmingCharacters(in: .letters) == String() ? true : false
    }
}
