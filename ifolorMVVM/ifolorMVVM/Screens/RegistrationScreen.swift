//
//  RegistrationScreen.swift
//  ifolorMVVM
//
//  Created by Arthur Gerster on 26.10.22.
//

import UIKit
import Combine

//enum RegistrationAction {
//    case register(RegistrationViewModel)
//}

final class RegistrationScreen: UIViewController {
    
    let viewModel: RegistrationViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    private let navigate: ((NavigationAction) -> Void)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameTitleLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailTitleLabel: UILabel!
    
    @IBOutlet weak var birthdateDatePicker: UIDatePicker!
    @IBOutlet weak var birthdateTitleLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    var keyboardHandler: KeyboardHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = Strings.introductionTitle
        nameTitleLabel.text = Strings.registrationOverviewName
        emailTitleLabel.text = Strings.registrationOverviewEmail
        birthdateTitleLabel.text = Strings.registrationOverviewBirthdate
        nameTextField.delegate = self
        emailTextField.delegate = self
        
        keyboardHandler = KeyboardHandler(move: containerViewBottomConstraint, in: view)
        
        nameTextField.textPublisher
            .sink { [weak self] name in
                self?.viewModel.name = name
            }
            .store(in: &cancellables)

        emailTextField.textPublisher
            .sink { [weak self] email in
                self?.viewModel.email = email
            }
            .store(in: &cancellables)
        
        birthdateDatePicker.publisher(for: .valueChanged)
            .sink { [weak self] datePicker in
                self?.viewModel.birthdate = datePicker.date
            }
            .store(in: &cancellables)
        
        viewModel.$isValid
            .sink { [weak self] enabled in
                self?.registerButton.isEnabled = enabled
            }
            .store(in: &cancellables)
        
        viewModel.$isRegistered
            .sink { [weak self] registered in
                guard let registeredViewModel = self?.viewModel, registered else { return }
                self?.navigate(.confirmation(registeredViewModel))
            }
            .store(in: &cancellables)
        
        registerButton.publisher(for: .primaryActionTriggered)
            .sink { [weak self] _ in
                self?.viewModel.register()
            }
            .store(in: &cancellables)
        
        registerButton.setTitle(Strings.registrationAction, for: .normal)
    }
    
    static func create(with viewModel: RegistrationViewModel, navigation: @escaping ((NavigationAction) -> Void)) -> Self {
        UIStoryboard(name: String(describing: Self.self), bundle: Bundle(for: Self.self)).instantiateInitialViewController(creator: { coder in
            Self(viewModel: viewModel, navigation: navigation, coder: coder)
        })!
    }
    
    init?(viewModel: RegistrationViewModel, navigation: @escaping ((NavigationAction) -> Void), coder: NSCoder) {
        self.viewModel = viewModel
        self.navigate = navigation
        super.init(coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RegistrationScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
