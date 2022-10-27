//
//  RegistrationViewModel.swift
//  ifolorMVVM
//
//  Created by Arthur Gerster on 27.10.22.
//

import Foundation

final class RegistrationViewModel: ObservableObject, Codable {
    @Published var name: String = "" {
        didSet {
            validate()
        }
    }
    
    @Published var email: String = "" {
        didSet {
            validate()
        }
    }
    
    @Published var birthdate: Date = Date() {
        didSet {
            validate()
        }
    }
    
    @Published var isValid: Bool = false
    
    @Published var isRegistered: Bool = false
    
    func register() {
        guard isValid else { return }
        isRegistered = true
    }
    
    private func validate() {
        isValid = (name.cleanedFromWhitespacesOccurences.count > 0) && (email.isValidEmail) && (birthdate.isValidBirthdate)
    }

    enum RegistrationViewModelCodingKeys: String, CodingKey {
        case name
        case email
        case birthdate
        case isValid
        case isRegistered
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RegistrationViewModelCodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(birthdate, forKey: .birthdate)
        try container.encode(isValid, forKey: .isValid)
        try container.encode(isRegistered, forKey: .isRegistered)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RegistrationViewModelCodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        birthdate = try container.decode(Date.self, forKey: .birthdate)
        isValid = try container.decode(Bool.self, forKey: .isValid)
        isRegistered = try container.decode(Bool.self, forKey: .isRegistered)
    }
    
    public init() {}
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
