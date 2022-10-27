//
//  KeyboardHandler.swift
//  ifolorMVP
//
//  Created by Arthur Gerster on 27.10.22.
//

import UIKit

class KeyboardHandler {
    
    private var view: UIView
    private var viewBottomConstraint: NSLayoutConstraint
    private var defaultConstant: CGFloat
    private let minimumBottomSpace: CGFloat
    private let offset: CGFloat
    private let accountsSafeArea: Bool
    var shouldAnimate = true
    
    init(move constraint: NSLayoutConstraint, in view: UIView, minimumBottomSpace: CGFloat = 12, offset: CGFloat = 0, accountsSafeArea: Bool = false) {
        self.viewBottomConstraint = constraint
        self.minimumBottomSpace = minimumBottomSpace
        self.offset = offset
        self.accountsSafeArea = accountsSafeArea
        self.view = view
        self.defaultConstant = constraint.constant
        enable()
    }
    
    func disable() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func enable() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardChanged(_ notification: Notification) {
        guard let info = notification.userInfo, let keyboardRect:CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let windowRect = view.convert(view.bounds, to: nil)
        let actualHeight = windowRect.maxY - keyboardRect.origin.y
        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        self.adjustForKeyboard(height: actualHeight, animationDuration: duration, animationOptions: animationCurve)
    }
    
    private func adjustForKeyboard(height: CGFloat, animationDuration: TimeInterval, animationOptions: UIView.AnimationOptions) {
        let bottomHeight: CGFloat
        if height <= 0 {
            bottomHeight = defaultConstant
        } else {
            let additionalBottomSafeArea = accountsSafeArea ? view.safeAreaInsets.bottom : 0
            bottomHeight = height + minimumBottomSpace - additionalBottomSafeArea + offset
        }
        self.viewBottomConstraint.constant = bottomHeight
        
        if shouldAnimate {
            UIView.animate(withDuration: animationDuration, delay: 0, options: animationOptions, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.view.layoutIfNeeded()
        }
    }
}

