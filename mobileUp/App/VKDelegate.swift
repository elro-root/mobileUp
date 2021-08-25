//
//  VKDelegate.swift
//  mobileUp
//
//  Created by Patrik Duksin on 22.08.2021.
//

import SwiftyVK
import UIKit

final class VKDelegate: SwiftyVKDelegate {

    let appId = "7932464"
    let scopes: Scopes = [.email, .offline]

    init() {
        VK.setUp(appId: appId, delegate: self)
    }

    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }

    func vkNeedToPresent(viewController: VKViewController) {
        // This code works only for simplest cases and one screen applications
        // If you have application with two or more screens, you should use different implementation
        // HINT: google it - get top most UIViewController
        if let rootController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
            rootController.present(viewController, animated: true)
        }
    }

    func vkTokenCreated(for sessionId: String, info: [String: String]) {
        print("token created in session \(sessionId) with info \(info)")
    }

    func vkTokenUpdated(for sessionId: String, info: [String: String]) {
        print("token updated in session \(sessionId) with info \(info)")
    }

    func vkTokenRemoved(for sessionId: String) {
        print("token removed in session \(sessionId)")
    }
}
