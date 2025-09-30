//
//  LoginValidator.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import Foundation

protocol LoginValidatorProtocol {
    func ismobileNumberValid(_ mobileNumber: String) -> Bool
    func isCodeValid(enteredCode: Int, expectedCode: Int) -> Bool
    func isFullNameValid(_ fullName: String) -> Bool
    func isEmailValid(_ email: String) -> Bool
}

class LoginValidator: LoginValidatorProtocol {
    func ismobileNumberValid(_ mobileNumber: String) -> Bool {
        
        let trimmedNumber = mobileNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmedNumber.count >= LoginConstants.minMobileNumberLength,
              trimmedNumber.count <= LoginConstants.maxMobileNumberLength else {
            return false
        }
        
        let digitSet = CharacterSet.decimalDigits
        
        return trimmedNumber.rangeOfCharacter(from: digitSet.inverted) == nil
    }
    
    func isCodeValid(enteredCode: Int, expectedCode: Int) -> Bool {
        enteredCode == expectedCode
    }
    
    func isFullNameValid(_ fullName: String) -> Bool {
        let trimmed = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count >= 5 && trimmed.count <= 99
    }
    
    func isEmailValid(_ email: String) -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: trimmed)
    }
}
