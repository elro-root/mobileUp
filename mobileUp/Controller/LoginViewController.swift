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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        VK.sessions.default.logIn { _ in
            print("all good")
        } onError: { error in
            print(error)
            print(VK.sessions.default.state)
//            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//                NSLog("The \"OK\" alert occured.")
//            }))
//            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

