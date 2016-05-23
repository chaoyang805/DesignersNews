//
//  MenuViewController.swift
//  DesignersNews
//
//  Created by chaoyang805 on 16/5/9.
//  Copyright © 2016年 chaoyang805. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var dialogView: DesignableView!
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        dialogView.animation = "fall"
        dialogView.animate()
    }

}
