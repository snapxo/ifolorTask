//
//  RegistrationOverviewScreen.swift
//  ifolorMVP
//
//  Created by Arthur Gerster on 26.10.22.
//  
//
//  MVP Template by Boris Grankin
//

import UIKit

private protocol RegistrationOverviewScreenSetup {
    var screenOutput: RegistrationOverviewScreenOutput? { get }
}

public final class RegistrationOverviewScreen: RegistrationOverviewScreenSetup {
    public enum RegistrationAction {
        case register(User)
    }
    
    // MARK: - Public interface
    public fileprivate(set) weak var viewController: UIViewController!
    fileprivate weak var screenOutput: RegistrationOverviewScreenOutput?
    
    @MainActor
    private let actionBlock: (RegistrationAction, RegistrationOverviewScreen) -> Void
    
    public init(actionBlock: @escaping (RegistrationAction, RegistrationOverviewScreen) -> Void) {
        self.actionBlock = actionBlock
        let presenter = RegistrationOverviewPresenter(screen: self)
        let userInterface = UIStoryboard(name: "RegistrationOverview", bundle: Bundle(for: Self.self)).instantiateInitialViewController(creator: { coder in
            RegistrationOverviewViewController(presenter: presenter, coder: coder)
        })
        presenter.ui = userInterface
        viewController = userInterface
        screenOutput = presenter
    }
}

// MARK: - Presenter -> Screen
protocol RegistrationOverviewScreenInput: AnyObject {
    @MainActor
    func sendAction(_ action: RegistrationOverviewScreen.RegistrationAction)
}

extension RegistrationOverviewScreen: RegistrationOverviewScreenInput {
    @MainActor
    func sendAction(_ action: RegistrationAction) {
        actionBlock(action, self)
    }
}
