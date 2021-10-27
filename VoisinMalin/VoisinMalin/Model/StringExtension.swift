//
//  StringExtension.swift
//  VoisinMalin
//
//  Created by vincent on 31/08/2021.
//

import Foundation

extension String {
    
/// Check no space in textfield
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespaces) == String() ? true : false
    }
/// Check no number in textfield
    var isNumeric: Bool {
        return self.trimmingCharacters(in: .letters) == String() ? true : false
    }
}
