//
//  LocalStore.swift
//  DesignersNews
//
//  Created by chaoyang805 on 16/5/31.
//  Copyright © 2016年 chaoyang805. All rights reserved.
//

import UIKit

struct LocalStore {
    static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    static func saveToken(token: String) {
        userDefaults.setObject(token, forKey: "tokenKey")
    }
    
    static func getToken() -> String? {
        return userDefaults.stringForKey("tokenKey")
    }
    
    static func deleteToken() {
        userDefaults.removeObjectForKey("tokenKey")
    }
    
    static func saveUpvotedStory(storyId: Int) {
        appendId(storyId, toKey: "upvotedStoriesKey")
    }
    
    static func saveUpvotedComment(commentId: Int) {
        appendId(commentId, toKey: "upvotedCommentsKey")
    }
    
    static func isStoryUpvoted(storyId: Int) -> Bool {
        return arrayForKey("upvotedStoriesKey", containsId: storyId)
    }
    
    static func isCommentUpvoted(commentId: Int) -> Bool {
        return arrayForKey("upvotedCommentsKey", containsId: commentId)
    }
    // MARK: Helper
    private static func arrayForKey(key: String, containsId id: Int ) -> Bool {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        return elements.contains(id)
    }
    
    private static func appendId(id: Int, toKey key: String) {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        if !elements.contains(id) {
            userDefaults.setObject(elements + [id], forKey: key)
        }
    }
}
