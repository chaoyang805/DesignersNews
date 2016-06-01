//
//  CommentTableViewCell.swift
//  DesignersNews
//
//  Created by chaoyang805 on 16/5/18.
//  Copyright © 2016年 chaoyang805. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var replyButton: SpringButton!
    @IBOutlet weak var commentTextView: AutoTextView!
    
    @IBAction func upvoteButtonDidTouch(sender: AnyObject) {
        
    }
    
    @IBAction func replyButtonDidTouch(sender: AnyObject) {
        
    }
    
    func configureWithComment(comment: JSON) {
        let userPortraitUrl = comment["user_portrait_url"].string
        let userDisplayName = comment["user_display_name"].string ?? ""
        let userJob = comment["user_job"].string ?? ""
        let createAt = comment["created_at"].string ?? ""
        let voteCount = comment["vote_count"].int ?? 0
        let body = comment["body"].string ?? ""
        let bodyHTML = comment["body_html"].string ?? ""
        
        avatarImageView.url = userPortraitUrl?.toURL()
        avatarImageView.placeholderImage = UIImage(named: "content-avatar-default")
        authorLabel.text = "\(userDisplayName), \(userJob)"
        timeLabel.text = timeAgoSinceDate(dateFromString(createAt, format: "yyyy-MM-dd'T'HH:mm:ssZ"), numericDates: true)
        upvoteButton.setTitle("\(voteCount)", forState: .Normal)
        commentTextView.text = body
        commentTextView.attributedText = htmlToAttributedString(bodyHTML + "<style>*{font-family: \"Avenir Next\"; font-size: 16px; line-height: 20px}img{max-width: 300px}</style>")
    }
}
