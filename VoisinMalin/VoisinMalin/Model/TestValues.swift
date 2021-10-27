//
//  TestValues.swift
//  VoisinMalin
//
//  Created by vincent on 05/10/2021.
//

import Foundation
import UIKit

class TestValues {
/// Check if email is valid
   static func validEmailAdress(emailAdressString: String?) -> Bool {
        guard emailAdressString != nil else { return false }
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAdressString! as NSString
            let results = regex.matches(in: emailAdressString!, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0 {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return returnValue
    }
/// Check if pasword is valid
    static func isValidPassword(password: String?) -> Bool {
        // at least one uppercase
        // at least one digit
        // at least one lowercase
        // 8 characters total
        guard password != nil else { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: password)
    }
}
