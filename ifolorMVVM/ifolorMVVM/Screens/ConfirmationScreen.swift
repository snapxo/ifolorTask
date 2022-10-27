//
//  ConfirmationScreen.swift
//  ifolorMVVM
//
//  Created by Arthur Gerster on 26.10.22.
//

import UIKit
import Combine


final class ConfirmationScreen: UIViewController {
    
    let registeredViewModel: RegistrationViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    private let navigate: ((NavigationAction) -> Void)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var unRegisterButton: UIButton!
    
    override func viewDidLoad() {
        nameLabel.text = registeredViewModel.name
        titleLabel.text = Strings.confirmationTitle
        detailsLabel.text = Strings.confirmationDetails
        
        unRegisterButton.setTitle(Strings.confirmationAction, for: .normal)
        
        registeredViewModel.$isRegistered
            .sink { [weak self] registered in
                guard !registered else { return }
                self?.navigate(.registration)
            }
            .store(in: &cancellables)
        
        unRegisterButton.publisher(for: .primaryActionTriggered)
            .sink { [weak self] _ in
                self?.registeredViewModel.isRegistered = false
            }
            .store(in: &cancellables)
    }
    
    static func create(with viewModel: RegistrationViewModel, navigation: @escaping ((NavigationAction) -> Void)) -> Self {
        UIStoryboard(name: String(describing: Self.self), bundle: Bundle(for: Self.self)).instantiateInitialViewController(creator: { coder in
            Self(viewModel: viewModel, navigation: navigation, coder: coder)
        })!
    }
    
    init?(viewModel: RegistrationViewModel, navigation: @escaping ((NavigationAction) -> Void), coder: NSCoder) {
        self.registeredViewModel = viewModel
        self.navigate = navigation
        super.init(coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
