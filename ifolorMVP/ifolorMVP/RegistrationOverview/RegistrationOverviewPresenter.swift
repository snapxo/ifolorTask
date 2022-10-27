//
//  RegistrationOverviewPresenter.swift
//  ifolorMVP
//
//  Created by Arthur Gerster on 26.10.22.
//  
//
//  MVP Template by Boris Grankin
//

import Foundation

enum RegistrationOverviewPresenterInstruction {
    case enableRegister(Bool)
}

protocol RegistrationOverviewPresentable: AnyObject {
    var screen: RegistrationOverviewScreenInput { get }
    var ui: RegistrationOverviewUserInterfaceInput? { get }
}

final class RegistrationOverviewPresenter: RegistrationOverviewPresentable {
    
    // RegistrationOverviewPresenter
    weak var ui: RegistrationOverviewUserInterfaceInput?
    let screen: RegistrationOverviewScreenInput
    
    var user: User = User()
    
    func validate() {
        ui?.instruct(.enableRegister(user.isValid))
    }
    
    init(screen: RegistrationOverviewScreenInput) {
        self.screen = screen
    }
}

// MARK: - UI -> Presenter
@MainActor
protocol RegistrationOverviewPresenterInput: AnyObject {
    func viewAction(_ action: RegistrationOverviewViewControllerAction)
}

extension RegistrationOverviewPresenter: RegistrationOverviewPresenterInput {
    @MainActor
    func viewAction(_ action: RegistrationOverviewViewControllerAction) {
        switch action {
        case .willAppear, .didDisappear:
            break
        case .didLoad:
            ui?.instruct(.enableRegister(false))
        case .nameChanged(let name):
            guard let name = name else { return }
            user.name = name
            validate()
        case .emailChanged(let email):
            guard let email = email else { return }
            user.email = email
            validate()
        case .birthdateChanged(let birthdate):
            user.birthdate = birthdate
            validate()
        case .registerSelected:
            guard user.isValid else { return }
            screen.sendAction(.register(user))
        }
    }
}

// MARK: - Screen -> Presenter
protocol RegistrationOverviewScreenOutput: AnyObject {
}

extension RegistrationOverviewPresenter: RegistrationOverviewScreenOutput {
}
