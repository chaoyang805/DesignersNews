//
//  LoginViewController.swift
//  DesignersNews
//
//  Created by chaoyang805 on 16/4/28.
//  Copyright © 2016年 chaoyang805. All rights reserved.
//

import UIKit
protocol LoginViewControllerDelegate: class {
    func loginViewControllerDidLogin(controller: LoginViewController)
}
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dialogView: DesignableView!
    @IBOutlet weak var emailTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    @IBOutlet weak var passwordImageView: SpringImageView!
    @IBOutlet weak var emailImageView: SpringImageView!
    
    weak var delegate: LoginViewControllerDelegate?
    
    @IBAction func loginButtonDidTouch(sender: DesignableButton) {
        guard let email = emailTextField.text, password = passwordTextField.text else {
            self.dialogView.animation = "shake"
            self.dialogView.animate()
            return
        }
        DesignerNewsService.loginWithEmail(email, password: password) { (token) in
            if let token = token {
                NSLog(token)
                LocalStore.saveToken(token)
                self.delegate?.loginViewControllerDidLogin(self)
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.dialogView.animation = "shake"
                self.dialogView.animate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == emailTextField {
            emailImageView.image = UIImage(named: "icon-mail-active")
            emailImageView.animate()
        } else {
            emailImageView.image = UIImage(named: "icon-mail")
        }
        
        if textField == passwordTextField {
            passwordImageView.image = UIImage(named: "icon-password-active")
            passwordImageView.animate()
        } else {
            passwordImageView.image = UIImage(named: "icon-password")
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        emailImageView.image = UIImage(named: "icon-mail")
        passwordImageView.image = UIImage(named: "icon-password")
    }
    
}
