//
//  ConfirmationOverviewPresenter.swift
//  ifolorMVP
//
//  Created by Arthur Gerster on 27.10.22.
//  
//
//  MVP Template by Boris Grankin
//

import Foundation

enum ConfirmationOverviewPresenterInstruction {
    case setup(User)
}

protocol ConfirmationOverviewPresentable: AnyObject {
    var screen: ConfirmationOverviewScreenInput { get }
    var ui: ConfirmationOverviewUserInterfaceInput? { get }
}

final class ConfirmationOverviewPresenter: ConfirmationOverviewPresentable {
    
    // ConfirmationOverviewPresenter
    weak var ui: ConfirmationOverviewUserInterfaceInput?
    let screen: ConfirmationOverviewScreenInput
    
    let registeredUser: User
    
    init(screen: ConfirmationOverviewScreenInput, user: User) {
        self.screen = screen
        self.registeredUser = user
    }
}

// MARK: - UI -> Presenter
@MainActor
protocol ConfirmationOverviewPresenterInput: AnyObject {
    func viewAction(_ action: ConfirmationOverviewViewControllerAction)
}

extension ConfirmationOverviewPresenter: ConfirmationOverviewPresenterInput {
    @MainActor
    func viewAction(_ action: ConfirmationOverviewViewControllerAction) {
        switch action {
        case .willAppear, .didDisappear:
            break
        case .didLoad:
            ui?.instruct(.setup(registeredUser))
        case .unRegisterSelected:
            screen.sendAction(.unRegister)
        }
    }
}

// MARK: - Screen -> Presenter
protocol ConfirmationOverviewScreenOutput: AnyObject {
}

extension ConfirmationOverviewPresenter: ConfirmationOverviewScreenOutput {
}
