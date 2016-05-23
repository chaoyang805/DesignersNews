//
//  LoginViewController.swift
//  DesignersNews
//
//  Created by chaoyang805 on 16/4/28.
//  Copyright © 2016年 chaoyang805. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var dialogView: DesignableView!
    
    @IBAction func loginButtonDidTouch(sender: DesignableButton) {
        dialogView.animation = "shake"
        dialogView.animate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
