//
//  MainRouter.swift
//  ifolorMVVM
//
//  Created by Arthur Gerster on 26.10.22.
//

import UIKit
import Combine

enum NavigationAction {
    case registration
    case confirmation(RegistrationViewModel)
}

@MainActor
final class MainRouter: NSObject {
    
    private let navigationController: UINavigationController
    private let window: UIWindow
    var rootViewController: UIViewController {
        navigationController
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Storing(.registeredUser)
    private var registeredUser: RegistrationViewModel
    
    private var confirmationScreen: ConfirmationScreen?
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
        super.init()
        Task {
            await showRegistration()
            if registeredUser.isRegistered {
                await MainActor.run { showConfirmation(with: registeredUser) }
            }
        }
    }
    
    func showRegistration() async {
        await MainActor.run {
            if let confirmation = confirmationScreen {
                confirmation.dismiss(animated: true)
                confirmationScreen = nil
            } else {
                let registrationViewModel = RegistrationViewModel()
                let registration = RegistrationScreen.create(with: registrationViewModel) { [weak self] action in
                    self?.navigate(for: action)
                }
                navigationController.pushViewController(registration, animated: false)
            }
        }
    }
    
    func showConfirmation(with viewModel: RegistrationViewModel) {
        registeredUser = viewModel
        let confirmation = ConfirmationScreen.create(with: viewModel) { [weak self] action in
            self?.navigate(for: action)
        }
        confirmation.modalPresentationStyle = .overFullScreen
        confirmation.modalTransitionStyle = .crossDissolve
        confirmationScreen = confirmation
        navigationController.present(confirmation, animated: true)
    }
    
    private func navigate(for action: NavigationAction) {
        switch action {
        case .registration:
            registeredUser = RegistrationViewModel()
            Task { await showRegistration() }
        case .confirmation(let registrationViewModel):
            registeredUser = registrationViewModel
            registeredUser.isRegistered = true
            showConfirmation(with: registeredUser)
        }
    }
}
