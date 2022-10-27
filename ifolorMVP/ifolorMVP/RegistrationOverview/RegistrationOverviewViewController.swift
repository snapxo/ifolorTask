//
//  RegistrationOverviewViewController.swift
//  ifolorMVP
//
//  Created by Arthur Gerster on 26.10.22.
//  
//
//  MVP Template by Boris Grankin
//

import UIKit

enum RegistrationOverviewViewControllerAction {
    case didLoad
    case willAppear
    case didDisappear
    case nameChanged(String?)
    case emailChanged(String?)
    case birthdateChanged(Date)
    case registerSelected
}

protocol RegistrationOverviewUserInterface: AnyObject {
    var presenter: RegistrationOverviewPresenterInput { get }
}

final class RegistrationOverviewViewController: UIViewController, RegistrationOverviewUserInterface {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameTitleLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailTitleLabel: UILabel!
    
    @IBOutlet weak var birthdateDatePicker: UIDatePicker!
    @IBOutlet weak var birthdateTitleLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    // RegistrationOverviewViewController
    let presenter: RegistrationOverviewPresenterInput
    
    var keyboardHandler: KeyboardHandler?
    
    init?(presenter: RegistrationOverviewPresenterInput, coder: NSCoder) {
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
        
        titleLabel.text = Strings.introductionTitle
        nameTitleLabel.text = Strings.registrationOverviewName
        emailTitleLabel.text = Strings.registrationOverviewEmail
        birthdateTitleLabel.text = Strings.registrationOverviewBirthdate
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        
        keyboardHandler = KeyboardHandler(move: containerViewBottomConstraint, in: view)
        
        registerButton.setTitle(Strings.registrationAction, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewAction(.willAppear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewAction(.didDisappear)
    }
    
    
    @IBAction func nameDidChange(_ sender: UITextField) {
        presenter.viewAction(.nameChanged(sender.text))
    }
    
    @IBAction func emailDidChange(_ sender: UITextField) {
        presenter.viewAction(.emailChanged(sender.text))
    }
    
    @IBAction func birthdateDidChange(_ sender: UIDatePicker) {
        presenter.viewAction(.birthdateChanged(sender.date))
    }
    
    @IBAction func didSelectRegister(_ sender: Any) {
        presenter.viewAction(.registerSelected)
    }
}

// MARK: - Presenter -> UI
protocol RegistrationOverviewUserInterfaceInput: AnyObject {
    func instruct(_ instruction: RegistrationOverviewPresenterInstruction)
}

extension RegistrationOverviewViewController: RegistrationOverviewUserInterfaceInput {
    func instruct(_ instruction: RegistrationOverviewPresenterInstruction) {
        switch instruction {
        case .enableRegister(let enabled):
            registerButton.isEnabled = enabled
        }
    }
}

extension RegistrationOverviewViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

