//
//  StoriesTableViewController.swift
//  DesignersNews
//
//  Created by chaoyang805 on 16/5/9.
//  Copyright © 2016年 chaoyang805. All rights reserved.
//

import UIKit

class StoriesTableViewController: UITableViewController, StoryTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    @IBAction func menuButtonDidTouch(sender: UIBarButtonItem) {
        performSegueWithIdentifier("MenuSegue", sender: self)
    }
    
    @IBAction func loginButtonDidTouch(sender: UIBarButtonItem) {
        performSegueWithIdentifier("LoginSegue", sender: self)
    }
    
    // MARK: - StoryTableViewCellDelegate
    
    func storyTableViewCell(cell: StoryTableViewCell, didTouchUpvote sender: AnyObject) {
        // TODO
    }
    
    func storyTableViewCell(cell: StoryTableViewCell, didTouchComment sender: AnyObject) {
        performSegueWithIdentifier("CommentsSegue", sender: cell)
    }
    
    // MARK: - Misc
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentsSegue" {
            let toView = segue.destinationViewController as? CommentsTableViewController
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            toView?.story = data[indexPath.row]
        }
    }
    
    // MARK: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryCell") as! StoryTableViewCell
        let story = data[indexPath.row]
        cell.configureWithStory(story)
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("WebSegue", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
//    func configureCell(cell: StoryTableViewCell) {
//        
//        cell.titleLabel.text = "Learn iOS Design and Xcode"
//        cell.badgeImageView.image = UIImage(named: "badge-apple")
//        cell.avatarImageView.image = UIImage(named: "content-avatar-default")
//        cell.authorLabel.text = "Meng To"
//        cell.timeLabel.text = "5m"
//        cell.upvoteButton.setTitle("59", forState: .Normal)
//        cell.commentButton.setTitle("32", forState: .Normal)
//        cell.delegate = self
//    }
}
