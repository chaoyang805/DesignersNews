//
//  CommentsTableViewController.swift
//  DesignersNews
//
//  Created by chaoyang805 on 16/5/17.
//  Copyright © 2016年 chaoyang805. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController, CommentTableViewCellDelegate, StoryTableViewCellDelegate, ReplyViewControllerDelegate {
    var story: JSON!
    var comments: [JSON]!
    var transitionManager = TransitionManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        comments = self.flattenComments(story["comments"].array ?? [])
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    @IBAction func shareButtonDidTouch(sender: UIBarButtonItem) {
        let url = story["url"].string ?? ""
        let title = story["title"].string ?? ""
        
        let activityViewController = UIActivityViewController(activityItems: [title, url], applicationActivities: nil)
        activityViewController.setValue(title, forKey: "subject")
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop]
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func reloadStory() {
        self.view.showLoading()
        let storyId = story["id"].int!
        DesignerNewsService.storyForId(storyId) { (JSON) in
            self.view.hideLoading()
            self.story = JSON["story"]
            self.comments = self.flattenComments(JSON["story"]["comments"].array ?? [])
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            
        }
    }
    
    // MARK: - tableViewControllerDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = indexPath.row == 0 ? "StoryCell" : "CommentCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)!
        if let storyCell = cell as? StoryTableViewCell {
            storyCell.delegate = self
            storyCell.configureWithStory(story)
        }
        
        if let commentCell = cell as? CommentTableViewCell {
            let comment = comments[indexPath.row - 1]
            commentCell.delegate = self
            commentCell.configureWithComment(comment)
        }
        
        return cell
    }
    
    // MARK: CommentTableViewCellDelegate
    func commentTableViewCellDidTouchUpvote(cell: CommentTableViewCell) {
        guard let token = LocalStore.getToken() else {
            performSegueWithIdentifier("LoginSegue", sender: self)
            return
        }
        guard let indexPath = tableView.indexPathForCell(cell) else { return }
        let comment = comments[indexPath.row - 1]
        guard let commentId = comment["id"].int else { return }
        
        DesignerNewsService.upvoteCommentWithId(commentId, token: token) { (successful) in
            
        }
        LocalStore.saveUpvotedComment(commentId)
        cell.configureWithComment(comment)
        
    }
    
    func commentTableViewCellDidTouchComment(cell: CommentTableViewCell) {
        if LocalStore.getToken() == nil {
            performSegueWithIdentifier("LoginSegue", sender: self)
        } else {
            performSegueWithIdentifier("ReplySegue", sender: cell)
        }
    }
    
    // MARK: StoryTableViewCellDelegate
    func storyTableViewCell(cell: StoryTableViewCell, didTouchUpvote sender: AnyObject) {
        guard let token = LocalStore.getToken() else {
            performSegueWithIdentifier("LoginSegue", sender: self)
            return
        }
        guard let storyId = story["id"].int else { return }
        DesignerNewsService.upvoteStoryWithId(storyId, token: token) { (successful) in
            
        }
        LocalStore.saveUpvotedStory(storyId)
        cell.configureWithStory(story)
    }
    
    func storyTableViewCell(cell: StoryTableViewCell, didTouchComment sender: AnyObject) {
        if LocalStore.getToken() == nil {
            performSegueWithIdentifier("LoginSegue", sender: self)
        } else {
            performSegueWithIdentifier("ReplySegue", sender: cell)
        }
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReplySegue" {
            let toView = segue.destinationViewController as? ReplyViewController
            if let _ = sender as? StoryTableViewCell {
                toView?.story = story
            }
            
            if let cell = sender as? CommentTableViewCell {
                let indexPath = tableView.indexPathForCell(cell)!
                toView?.comment = comments[indexPath.row - 1]
            }
            toView?.delegate = self
            toView?.transitioningDelegate = transitionManager
        }
    }
    
    // MARK: ReplyViewControllerDelegate
    func replyViewControllerDidSend(controller: ReplyViewController) {
        // TODO next
        reloadStory()
    }
    
    // MARK: Helper
    func flattenComments(comments: [JSON]) -> [JSON] {
        let flattenedComments = comments.map(commentsForComment).reduce([],combine: +)
        return flattenedComments
    }
    
    func commentsForComment(comment: JSON) -> [JSON] {
        let comments = comment["comments"].array ?? []
        return comments.reduce([comment]) { acc, x in
            acc + self.commentsForComment(x)
        }
    }
    
}
