//
//  Dependency.swift
//  ifolorMVP
//
//  Created by Arthur Gerster on 27.10.22.
//

import Foundation

final class Dependency {
    private(set) var userService: UserServable
    
    private init() {
        userService = UserService()
    }
    
    public static var manager = Dependency()
}
