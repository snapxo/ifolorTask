//
//  UITextFieldPublisher.swift
//  ifolorMVVM
//
//  Created by Arthur Gerster on 26.10.22.
//

import UIKit
import Combine

extension UITextField {
    
    func bind(to stringPublisher: inout Published<String>.Publisher, storeIn cancellables: inout Set<AnyCancellable>) {
        textPublisher
            .assign(to: &stringPublisher)
        
        stringPublisher.sink { [weak self] string in
            if self?.text != string {
                self?.text = string
            }
        }.store(in: &cancellables)
    }

    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .compactMap {
            ($0.object as? Self)?.text
        }
        .eraseToAnyPublisher()
    }
}
