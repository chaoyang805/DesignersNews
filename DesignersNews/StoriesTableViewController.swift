//
//  StoriesTableViewController.swift
//  DesignersNews
//
//  Created by chaoyang805 on 16/5/9.
//  Copyright © 2016年 chaoyang805. All rights reserved.
//

import UIKit

class StoriesTableViewController: UITableViewController, StoryTableViewCellDelegate, MenuViewControllerDelegate, LoginViewControllerDelegate {

    let transitionManager = TransitionManager()
    var stories: JSON = []
    var isFirstTime = true
    var section = ""
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    func loadStories(section: String, page: Int) {
        DesignerNewsService.storiesForSection(section, page: page) { (JSON) in
            self.stories = JSON["stories"]
            self.tableView.reloadData()
            self.view.hideLoading()
            self.refreshControl?.endRefreshing()
        }
        
        if LocalStore.getToken() == nil {
            loginButton.title = "Login"
            loginButton.enabled = true
        } else {
            loginButton.title = ""
            loginButton.enabled = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadStories("", page: 1)
        refreshControl?.addTarget(self, action: #selector(StoriesTableViewController.refreshStories), forControlEvents: .ValueChanged)
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!], forState: .Normal)
        loginButton.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "Avenir Next", size: 18)!], forState: .Normal)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstTime {
            view.showLoading()
            isFirstTime = false
        }
    }
    
    func refreshStories() {
        SoundPlayer().playSound("refresh.wav")
        loadStories(section, page: 1)
    }
    
    
    @IBAction func menuButtonDidTouch(sender: UIBarButtonItem) {
        performSegueWithIdentifier("MenuSegue", sender: self)
    }
    
    @IBAction func loginButtonDidTouch(sender: UIBarButtonItem) {
        performSegueWithIdentifier("LoginSegue", sender: self)
    }
    
    // MARK: - StoryTableViewCellDelegate
    
    func storyTableViewCell(cell: StoryTableViewCell, didTouchUpvote sender: AnyObject) {
        guard let token = LocalStore.getToken() else {
            performSegueWithIdentifier("LoginSegue", sender: self)
            return
        }
        guard let indexPath = tableView.indexPathForCell(cell) else { return }
        let story = stories[indexPath.row]
        guard let storyId = story["id"].int else { return }
        DesignerNewsService.upvoteStoryWithId(storyId, token: token) { (successful) in
            NSLog("upvote success \(successful)")
        }
        LocalStore.saveUpvotedStory(storyId)
        cell.configureWithStory(story)
    }
    
    func storyTableViewCell(cell: StoryTableViewCell, didTouchComment sender: AnyObject) {
        performSegueWithIdentifier("CommentsSegue", sender: cell)
    }
    
    // MARK: - MenuViewControllerDelegate
    
    func menuViewControllerDidTouchTop(controller: MenuViewController) {
        view.showLoading()
        loadStories("", page: 1)
        navigationItem.title = "Top Stories"
        section = ""
    }
    
    func menuViewControllerDidTouchRecent(controller: MenuViewController) {
        view.showLoading()
        loadStories("recent", page: 1)
        navigationItem.title = "Recent Stories"
        section = "recent"
    }
    
    func menuViewControllerDidTouchLogout(controller: MenuViewController) {
        loadStories("", page: 1)
        view.showLoading()
    }
    
    // MARK: - Misc
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentsSegue" {
            let toView = segue.destinationViewController as? CommentsTableViewController
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            toView?.story = stories[indexPath.row]
        }
        
        if segue.identifier == "WebSegue" {
            guard let toView = segue.destinationViewController as? WebViewController, indexPath = sender as? NSIndexPath else { return }
            
            let url = stories[indexPath.row]["url"].string
            toView.url = url
            toView.transitioningDelegate = transitionManager
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
        }
        
        if segue.identifier == "MenuSegue" {
            guard let toView = segue.destinationViewController as? MenuViewController else { return }
            toView.delegate = self
        }
        
        if segue.identifier == "LoginSegue" {
            guard let toView = segue.destinationViewController as? LoginViewController else { return }
            toView.delegate = self
        }
    }
    
    // MARK: - LoginViewControllerDelegate
    func loginViewControllerDidLogin(controller: LoginViewController) {
        loadStories("", page: 1)
        view.showLoading()
    }
    
    // MARK: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryCell") as! StoryTableViewCell
        let story = stories[indexPath.row]
        cell.configureWithStory(story)
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("WebSegue", sender: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

}
