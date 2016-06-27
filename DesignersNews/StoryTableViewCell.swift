//
//  StoryTableViewCell.swift
//  DesignersNews
//
//  Created by chaoyang805 on 16/5/10.
//  Copyright © 2016年 chaoyang805. All rights reserved.
//

import UIKit

protocol StoryTableViewCellDelegate: class {
    func storyTableViewCell(cell: StoryTableViewCell, didTouchUpvote sender: AnyObject)
    func storyTableViewCell(cell: StoryTableViewCell, didTouchComment sender: AnyObject)
}

class StoryTableViewCell: UITableViewCell {

    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var commentTextView: AutoTextView!
    
    weak var delegate: StoryTableViewCellDelegate?
    @IBAction func upvoteButtonDidTouch(sender: SpringButton) {
        sender.animation = "pop"
        sender.force = 3
        sender.animate()
        
        delegate?.storyTableViewCell(self, didTouchUpvote: sender)
    }
    
    @IBAction func commentButtonDidTouch(sender: SpringButton) {
        sender.animation = "pop"
        sender.force = 3
        sender.animate()
        
        delegate?.storyTableViewCell(self, didTouchComment: sender)
    }
    
    func configureWithStory(story: JSON) {
        let title = story["title"].string ?? ""
        let badge = story["badge"].string ?? ""
        let userPortraitUrl = story["user_portrait_url"].string
        let userDisplayName = story["user_display_name"].string ?? ""
        let userJob = story["user_job"].string ?? ""
        let createAt = story["created_at"].string ?? ""
        let voteCount = story["vote_count"].int ?? 0
        let commentCount = story["comment_count"].int ?? 0
        let comment = story["comment"].string ?? ""
//        let commentHTML = story["comment_html"].string ?? ""
        
        titleLabel.text = title
        badgeImageView.image = UIImage(named: "badge-\(badge)")
        avatarImageView.url = userPortraitUrl?.toURL()
        avatarImageView.placeholderImage = UIImage(named: "content-avatar-default")
        authorLabel.text = "\(userDisplayName), \(userJob)"
        timeLabel.text = timeAgoSinceDate(dateFromString(createAt, format: "yyyy-MM-dd'T'HH:mm:ssZ"), numericDates: true)
        upvoteButton.setTitle("\(voteCount)", forState: .Normal)
        commentButton.setTitle("\(commentCount)", forState: .Normal)
        if let commentTextView = commentTextView {
            commentTextView.text = comment
//            commentTextView.attributedText = htmlToAttributedString(commentHTML + "<style>*{font-family: \"Avenir Next\"; font-size: 16px; line-height: 20px}img{max-width: 300px}</style>")
        }
        let storyId = story["id"].int!
        if LocalStore.isStoryUpvoted(storyId) {
            upvoteButton.setImage(UIImage(named: "icon-upvote-active"), forState: .Normal)
            upvoteButton.setTitle(String(voteCount + 1), forState: .Normal)
        } else {
            upvoteButton.setImage(UIImage(named: "icon-upvote"), forState: .Normal)
            upvoteButton.setTitle(String(voteCount), forState: .Normal)
        }
        
    }
}
