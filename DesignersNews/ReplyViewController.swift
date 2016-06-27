//
//  ReplyViewController.swift
//  DesignersNews
//
//  Created by chaoyang805 on 16/6/4.
//  Copyright © 2016年 chaoyang805. All rights reserved.
//

import UIKit
protocol ReplyViewControllerDelegate: class {
    func replyViewControllerDidSend(controller: ReplyViewController)
}
class ReplyViewController: UIViewController {

    var story: JSON = []
    var comment: JSON = []
    weak var delegate: ReplyViewControllerDelegate?
    
    @IBOutlet weak var replyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replyTextView.becomeFirstResponder()
    }
    
    @IBAction func sendButtonDidTouch(sender: UIBarButtonItem) {
        view.showLoading()
        
        let token = LocalStore.getToken()!
        let body = replyTextView.text
        
        if let storyId = story["id"].int {
            DesignerNewsService.replyWithStoryId(storyId, token: token, body: body, response: { (successful) in
                self.view.hideLoading()
                if successful {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.replyViewControllerDidSend(self)
                } else {
                    self.showAlert()
                }
            })
        }
        
        if let commentId = comment["id"].int {
            DesignerNewsService.replyWithCommentId(commentId, token: token, body: body, response: { (successful) in
                self.view.hideLoading()
                if successful {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.replyViewControllerDidSend(self)
                } else {
                    self.showAlert()
                }
            })
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Oh noes", message: "Something went wrong. Your message wasn't sent. Please try again and save your text just in case.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
