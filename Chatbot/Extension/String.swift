//
//  String.swift
//  Chatbot
//
//  Created by neosoft on 22/04/22.
//

import Foundation

extension String {
    func ValidBotName() -> Bool {
        let phoneNumberRegex = "^[A-Za-z]\\w{2,}$"
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        let validatePhone = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = validatePhone.evaluate(with: trimmedString)
        return isValidPhone
    }
}
