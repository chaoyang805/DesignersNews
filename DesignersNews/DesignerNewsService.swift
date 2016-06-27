//
//  DesignerNewsService.swift
//  DesignersNews
//
//  Created by chaoyang805 on 16/5/28.
//  Copyright © 2016年 chaoyang805. All rights reserved.
//

import Foundation
import Alamofire

struct DesignerNewsService {
//    private static let BaseURL = "http://gank.io"
    private static let BaseURL = "https://www.designernews.co"
    private static let clientID = "750ab22aac78be1c6d4bbe584f0e3477064f646720f327c5464bc127100a1a6d"
    private static let clientSecret = "53e3822c49287190768e009a8f8e55d09041c5bf26d0ef982693f215c72d87da"

    private enum ResourcePath: CustomStringConvertible {
        
        case Login
        case Stories
        case StoryId(storyId: Int)
        case StoryReply(storyId: Int)
        case StoryUpvote(storyId: Int)
        case CommentUpvote(commentId: Int)
        case CommentReply(commentId: Int)

        var description: String {
            switch self {
            case .Login:
                return "/oauth/token"
            case .Stories:
                return "/api/v1/stories"
            case .StoryId(let storyId):
                return "/api/v1/stories/\(storyId)"
            case .StoryUpvote(let storyId):
                return "/api/v1/stories/\(storyId)/upvote"
            case .StoryReply(let storyId):
                return "/api/v1/stories/\(storyId)/reply"
            case .CommentUpvote(let commentId):
                return "/api/v1/stories/\(commentId)/upvote"
            case .CommentReply(let commentId):
                return "/api/v1/stories/\(commentId)/reply"
            }
        }
        
    }
    
    static func storiesForSection(section: String, page: Int, response: (JSON) -> Void) {
        let urlString = BaseURL + ResourcePath.Stories.description + "/\(section)"
        let parameters = [
            "page" : "\(page)",
            "client_id" : clientID
        ]
        
        Alamofire.request(.GET, urlString, parameters: parameters).responseJSON { (aResponse: Response<AnyObject, NSError>) in
            
            let stories = JSON(aResponse.result.value ?? [])
            response(stories)
        }
    }
    
    static func storyForId(storyId: Int, response: (JSON) -> Void) {
        let urlString = BaseURL + ResourcePath.StoryId(storyId: storyId).description
        
        let parameters = [
            "client_id" : clientID
        ]
        Alamofire.request(.GET, urlString, parameters: parameters).responseJSON { (aResponse) in
            let data = aResponse.result.value
            let story = JSON(data ?? [])
            response(story)
            
        }
    }
    
    static func loginWithEmail(email: String, password: String, response: (token: String?) -> Void) {
        
        let urlString = BaseURL + ResourcePath.Login.description
        let parameters = [
            "grant_type": "password",
            "user_name": email,
            "password": password,
            "client_id": clientID,
            "client_secret": clientSecret
        ]
        Alamofire.request(.POST, urlString, parameters: parameters).responseJSON { (aResponse: Response<AnyObject, NSError>) in
            
            let json = JSON(aResponse.result.value ?? [])
            let token = json["access_token"].string
            response(token: token)
        }
    }
    
    static func upvoteStoryWithId(storyId: Int, token: String, response: (successful: Bool) -> Void) {
        let urlString = BaseURL + ResourcePath.StoryUpvote(storyId: storyId).description
        upvoteWithUrlString(urlString, token: token, response: response)
    }
    
    static func upvoteCommentWithId(commentId: Int, token: String, response: (successful: Bool) -> Void) {
        let urlString = BaseURL + ResourcePath.CommentUpvote(commentId: commentId).description
        upvoteWithUrlString(urlString, token: token, response: response)
    }
    
    static func replyWithStoryId(storyId: Int, token: String, body: String, response: (successful: Bool) -> Void) {
        let urlString = BaseURL + ResourcePath.StoryReply(storyId: storyId).description
        replyWithUrlString(urlString, token: token, body: body, response: response)
    }
    
    static func replyWithCommentId(commentId: Int, token: String, body: String, response: (successful: Bool) -> Void) {
        let urlString = BaseURL + ResourcePath.CommentReply(commentId: commentId).description
        replyWithUrlString(urlString, token: token, body: body, response: response)
    }
    
    private static func upvoteWithUrlString(urlString: String, token: String, response: (successful: Bool) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).response { (_, urlResponse, _, _) in
            let successful = urlResponse?.statusCode == 200
            response(successful: successful)
        }
    }
    
    private static func replyWithUrlString(urlString: String, token: String, body: String, response: (successful: Bool) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.HTTPBody = "comment[body]=\(body)".dataUsingEncoding(NSUTF8StringEncoding)
        
        Alamofire.request(request).responseJSON { (aResponse) in
            guard let data = aResponse.result.value else {
                
                response(successful: false)
                return
            }
            let json = JSON(data)
            if let _ = json["comment"].string {
                response(successful: true)
            } else {
                response(successful: false)
            }
        }
    }
    
}