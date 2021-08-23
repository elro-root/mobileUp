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
        loginView.loginButton.layer.cornerRadius = 16
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        VK.sessions.default.logIn(
            onSuccess: { _ in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                DispatchQueue.main.async {
                    let viewController = storyboard.instantiateViewController(identifier: "main") as! UINavigationController
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(viewController)
                }
            }, onError: { error in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        )
    }
}
