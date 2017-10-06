//
//  ViewController.swift
//  Calhack
//
//  Created by Sky Xu on 10/6/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase
import SnapKit

typealias FIRUser = FirebaseAuth.User

class LoginView: UIView {
    private(set) var loginButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.zero
        self.initializeUI()
        self.createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = CGRect.zero
        self.initializeUI()
        self.createConstraints()
    }
    
    private func initializeUI() {
        addSubview(loginButton)
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.green
        
    }
    
    private func createConstraints(){
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.width.equalTo(66)
            make.height.equalTo(25)
        }
    }
    
    
}


class LoginViewController: UIViewController {
    var contentView: LoginView {
        return view as! LoginView
    }
    
    override func loadView() {
        view = LoginView()
        view.backgroundColor = UIColor.red
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.loginButton.addTarget(self, action: #selector(buttonWasTapped(button: )), for: .touchUpInside)
     }
    
    @objc func buttonWasTapped(button: UIButton){
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        authUI.delegate = self as? FUIAuthDelegate
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
}
extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
        }
        
        guard let user = user
            else {  return  }
        
        UserService.show(forUID: user.uid) { (user) in
            if let user = user {
                // handle existing user
                User.setCurrent(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            } else {
                // handle new user
                self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
            }
         }
    }
}

