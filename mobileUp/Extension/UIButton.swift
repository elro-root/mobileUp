//
//  UIButton.swift
//  mobileUp
//
//  Created by Patrik Duksin on 25.08.2021.
//

import UIKit

extension UIButton {
    func animate(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: CGFloat(1),
            initialSpringVelocity: CGFloat(4),
            options: UIView.AnimationOptions.allowUserInteraction,
            animations: {
                sender.transform = CGAffineTransform.identity
            }
        )
    }
}
