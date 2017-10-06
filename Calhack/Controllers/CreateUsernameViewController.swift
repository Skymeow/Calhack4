//
//  CreateUsernameViewController.swift
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

class MainView: UIView {
    private(set) var nextButton = UIButton()
    private(set) var usernameTextField = UITextField()
    private(set) var userLabel = UILabel()
    
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
        addSubview(nextButton)
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = UIColor.green
        nextButton.layer.cornerRadius = 6
        addSubview(usernameTextField)
        addSubview(userLabel)
        userLabel.text = "userName"
        userLabel.textAlignment = NSTextAlignment.center
        userLabel.backgroundColor = UIColor(red:0.38, green:0.85, blue:0.88, alpha:1)
        usernameTextField.placeholder = "type in your username"
    }
    
    private func createConstraints(){
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(150)
            make.width.equalTo(66)
            make.height.equalTo(25)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview().inset(100)
            make.top.equalToSuperview().inset(100)
            make.width.equalTo(120)
            make.height.equalTo(25)
        }
        
        userLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().inset(-100)
            make.top.equalToSuperview().inset(100)
            make.width.equalTo(80)
            make.height.equalTo(25)
        }
    }
}


class CreateUsernameViewController: UIViewController {
    var contentView: MainView {
        return view as! MainView
    }
    
    override func loadView() {
        view = MainView()
        view.backgroundColor = UIColor.red
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.nextButton.addTarget(self, action: #selector(buttonWasTapped(button: )), for: .touchUpInside)
    }
    
    @objc func buttonWasTapped(button: UIButton){
        guard let firUser = Auth.auth().currentUser,
            let username = contentView.usernameTextField.text,
            !username.isEmpty else { return }
        
        UserService.create(firUser, username: username) { (user) in
            guard let user = user else {
                return
            }
            
            User.setCurrent(user, writeToUserDefaults: true)
            
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
    }
}

}
