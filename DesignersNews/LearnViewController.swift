//
//  LearnViewController.swift
//  DesignersNews
//
//  Created by chaoyang805 on 16/5/2.
//  Copyright © 2016年 chaoyang805. All rights reserved.
//

import UIKit

class LearnViewController: UIViewController {

    @IBOutlet weak var dialogView: DesignableView!
    @IBOutlet weak var bookImageView: DesignableImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dialogView.animate()
    }
    @IBAction func learnButtonDidTouch(sender: UIButton) {
        bookImageView.animation = "pop"
        bookImageView.animate()
        openURL("http://designcode.io")
    }
    
    @IBAction func closeButtonDidTouch(sender: UIButton) {
        dialogView.animation = "fall"
        dialogView.animateNext { 
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func twitterButtonDidTouch(sender: UIButton) {
        openURL("http://twitter.com")
    }
    
    func openURL(url: String) {
        guard let targetURL = NSURL(string: url) else { return }
        UIApplication.sharedApplication().openURL(targetURL)
    }
}
