//
//  User.swift
//  ifolorMVP
//
//  Created by Arthur Gerster on 27.10.22.
//

import Foundation

public struct User: Codable {
    var name: String = ""
    var email: String = ""
    var birthdate: Date = Date()
    
    var isValid: Bool {
        (name.cleanedFromWhitespacesOccurences.count > 0) && (email.isValidEmail) && (birthdate.isValidBirthdate)
    }
}

private extension String {
    var isValidEmail: Bool {
        let formatRegex = Strings.emailRegexPattern
        let predicate = NSPredicate(format: "SELF MATCHES %@", formatRegex)
        return predicate.evaluate(with: self)
    }
    
    var cleanedFromWhitespacesOccurences: String {
        self.components(separatedBy: .whitespaces).joined()
    }
}

private extension Date {
    var isValidBirthdate: Bool {
        guard let minimum = Date.date(with: 1, month: 1, year: 1900), let maximum = Date.date(with: 31, month: 12, year: 2019) else { return false }
        return (minimum <= self) && (self <= maximum)
    }
    
    static func date(with day: Int, month: Int, year: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return Calendar.current.date(from: dateComponents)
    }
}
