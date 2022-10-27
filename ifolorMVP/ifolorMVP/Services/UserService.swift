//
//  UserService.swift
//  ifolorMVP
//
//  Created by Arthur Gerster on 27.10.22.
//

import Foundation

public enum RegistrationState: Codable {
    case notRegistered
    case registered(User)
}

public class UserService: UserServable {
    
    @Storing(.registrationState)
    public var registrationState: RegistrationState
    
    public func register(_ user: User) {
        registrationState = .registered(user)
    }
    
    public func unRegister() {
        registrationState = .notRegistered
    }
}

public protocol UserServable {
    func register(_ user: User)
    func unRegister()
    var registrationState: RegistrationState { get }
}
