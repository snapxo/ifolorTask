//
//  ConfirmationOverviewScreen.swift
//  ifolorMVP
//
//  Created by Arthur Gerster on 27.10.22.
//  
//
//  MVP Template by Boris Grankin
//

import UIKit

private protocol ConfirmationOverviewScreenSetup {
    var screenOutput: ConfirmationOverviewScreenOutput? { get }
}

public final class ConfirmationOverviewScreen: ConfirmationOverviewScreenSetup {
    public enum ConfirmationAction {
        case unRegister
    }
    
    // MARK: - Public interface
    public fileprivate(set) weak var viewController: UIViewController!
    fileprivate weak var screenOutput: ConfirmationOverviewScreenOutput?
    
    @MainActor
    private let actionBlock: (ConfirmationAction, ConfirmationOverviewScreen) -> Void
    
    public init(user: User, actionBlock: @escaping (ConfirmationAction, ConfirmationOverviewScreen) -> Void) {
        self.actionBlock = actionBlock
        let presenter = ConfirmationOverviewPresenter(screen: self, user: user)
        let userInterface = UIStoryboard(name: "ConfirmationOverview", bundle: Bundle(for: Self.self)).instantiateInitialViewController(creator: { coder in
            ConfirmationOverviewViewController(presenter: presenter, coder: coder)
        })
        presenter.ui = userInterface
        viewController = userInterface
        screenOutput = presenter
    }
}

// MARK: - Presenter -> Screen
protocol ConfirmationOverviewScreenInput: AnyObject {
    @MainActor
    func sendAction(_ action: ConfirmationOverviewScreen.ConfirmationAction)
}

extension ConfirmationOverviewScreen: ConfirmationOverviewScreenInput {
    @MainActor
    func sendAction(_ action: ConfirmationAction) {
        actionBlock(action, self)
    }
}
