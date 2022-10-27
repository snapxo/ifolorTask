//
//  MainRouter.swift
//  ifolorMVP
//
//  Created by Arthur Gerster on 27.10.22.
//

import UIKit

@MainActor
final class MainRouter: NSObject {
    
    private let navigationController: UINavigationController
    private let window: UIWindow
    private let services: Dependency
    var rootViewController: UIViewController {
        navigationController
    }
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
        self.services = Dependency.manager
        super.init()
        Task {
            await showRegistration()
            if case .registered(let user) = services.userService.registrationState {
                await MainActor.run { showConfirmation(for: user) }
            }
        }
    }
    
    func showRegistration() async {
        let registration = RegistrationOverviewScreen { [weak self] action, screen in
            switch action {
            case .register(let user):
                self?.services.userService.register(user)
                self?.showConfirmation(for: user)
            }
        }
        navigationController.pushViewController(registration.viewController, animated: false)
    }
    
    func showConfirmation(for user: User) {
        let confirmation = ConfirmationOverviewScreen(user: user) { [weak self] action, screen in
            switch action {
            case .unRegister:
                self?.services.userService.unRegister()
                screen.viewController.dismiss(animated: true)
            }
        }
        confirmation.viewController.modalPresentationStyle = .overFullScreen
        confirmation.viewController.modalTransitionStyle = .crossDissolve
        navigationController.present(confirmation.viewController, animated: true)
    }
}
