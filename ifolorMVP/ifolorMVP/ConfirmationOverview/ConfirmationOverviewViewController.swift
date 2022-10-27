//
//  ConfirmationOverviewViewController.swift
//  ifolorMVP
//
//  Created by Arthur Gerster on 27.10.22.
//  
//
//  MVP Template by Boris Grankin
//

import UIKit

enum ConfirmationOverviewViewControllerAction {
    case didLoad
    case willAppear
    case didDisappear
    case unRegisterSelected
}

protocol ConfirmationOverviewUserInterface: AnyObject {
    var presenter: ConfirmationOverviewPresenterInput { get }
}

final class ConfirmationOverviewViewController: UIViewController, ConfirmationOverviewUserInterface {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var unRegisterButton: UIButton!
    
    // ConfirmationOverviewViewController
    let presenter: ConfirmationOverviewPresenterInput
    
    init?(presenter: ConfirmationOverviewPresenterInput, coder: NSCoder) {
        self.presenter = presenter
        super.init(coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(presenter:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewAction(.didLoad)
        
        titleLabel.text = Strings.confirmationTitle
        detailsLabel.text = Strings.confirmationDetails
        
        unRegisterButton.setTitle(Strings.confirmationAction, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewAction(.willAppear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewAction(.didDisappear)
    }
    
    @IBAction func didSelectUnRegister(_ sender: Any) {
        presenter.viewAction(.unRegisterSelected)
    }
}

// MARK: - Presenter -> UI
protocol ConfirmationOverviewUserInterfaceInput: AnyObject {
    func instruct(_ instruction: ConfirmationOverviewPresenterInstruction)
}

extension ConfirmationOverviewViewController: ConfirmationOverviewUserInterfaceInput {
    func instruct(_ instruction: ConfirmationOverviewPresenterInstruction) {
        switch instruction {
        case .setup(let user):
            nameLabel.text = user.name
        }
    }
}

