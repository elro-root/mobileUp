//
//  ViewController.swift
//  mobileUp
//
//  Created by Patrik Duksin on 22.08.2021.
//

import UIKit
import SwiftyVK

class LoginViewController: UIViewController {

    private var loginView: LoginView! {
        guard isViewLoaded else { return nil}
        guard let view = view as? LoginView else { return nil }
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.mobileUpLabel.text = "Mobile Up\nGallery"
        loginView.loginButton.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButton(_ sender: Any) {
        loginView.loginButton.animate(sender: sender as! UIButton)
        // swiftlint:disable:previous force_cast
        VK.sessions.default.logIn(
            onSuccess: { _ in
                DispatchQueue.main.async {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController =
                        storyBoard.instantiateViewController(identifier: "MainViewController") as! MainViewController
                    // swiftlint:disable:previous force_cast
                    let navigationViewController = UINavigationController(rootViewController: viewController)
                    navigationViewController.navigationBar.isHidden = true
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                        .setRootViewController(navigationViewController)
                }
            }, onError: { error in
                DispatchQueue.main.async {
                    let alert =
                        UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(
                        UIAlertAction(
                            title: NSLocalizedString("OK", comment: "Default action"),
                            style: .default,
                            handler: nil
                        )
                    )
                    self.present(alert, animated: true, completion: nil)
                }
            }
        )
    }
}
