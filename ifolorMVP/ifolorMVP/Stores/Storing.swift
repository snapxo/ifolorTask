//
//  Storing.swift
//  ifolorMVP
//
//  Created by Arthur Gerster on 27.10.22.
//

import Foundation

@propertyWrapper
public struct Storing<T: Codable> {
    let keyString: String
    let fallbackValue: T
    let storage = UserDefaults.standard
    var encoder = { JSONEncoder() }()
    var decoder = { JSONDecoder() }()
    
    init(keyString: String, fallbackValue: T, isCaching: Bool = false) {
        self.keyString = keyString
        self.fallbackValue = fallbackValue
        self.isCaching = isCaching
    }
    
    init(storingKey: StoringKey, fallbackValue: T, isCaching: Bool = false) {
        self.keyString = storingKey.rawValue
        self.fallbackValue = fallbackValue
        self.isCaching = isCaching
    }
    
    init(_ config: StoringConfiguration<T>, isCaching: Bool = false) {
        self.keyString = config.key.rawValue
        self.isCaching = isCaching
        self.fallbackValue = config.fallbackValue
    }
    
    private let isCaching: Bool
    private var cachedValue: T?

    /// tries to save and read a value as Data and encode or decode it.
    /// Up to iOS 12 the Coders don't support fragments. If the type is a fragment (mainly enums) it is stored and read as an array with one element.
    public var wrappedValue: T {
        mutating get {
            if let cachedValue = cachedValue {
                return cachedValue
            }
            guard let savedObject = storage.object(forKey: keyString) as? Data else { return fallbackValue }
            
            do {
                let savedValue = try decoder.decode(T.self, from: savedObject)
                self.cachedValue = savedValue
                return savedValue
            } catch let initialError {
                do {
                    let savedValue = try decoder.decode([T].self, from: savedObject).first
                    self.cachedValue = savedValue
                    return savedValue ?? fallbackValue
                } catch {
                    debugPrint(initialError.localizedDescription)
                    return fallbackValue
                }
            }
        }
        set {
            if let encodedValue = (try? encoder.encode(newValue)) ?? (try? encoder.encode([newValue])) {
                storage.set(encodedValue, forKey: keyString)
                cachedValue = isCaching ? newValue : nil
            } else {
                storage.set(newValue, forKey: keyString)
            }
        }
    }
}

enum StoringKey: String {
    case registrationState
}

struct StoringConfiguration<T: Codable> {
    fileprivate let key: StoringKey
    let fallbackValue: T
}

extension StoringConfiguration where T == RegistrationState {
    static let registrationState = Self.init(key: .registrationState, fallbackValue: .notRegistered)
}



