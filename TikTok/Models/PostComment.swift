//
//  PostComment.swift
//  TikTok
//
//  Created by Влад Тимчук on 11.07.2024.
//

import Foundation

struct PostComment {
    let text: String
    let user: User
    let date: Date
    
    static func mockComments() -> [PostComment] {
        let user = User(id: UUID().uuidString, name: "kanyewest", profilePictureURL: nil)
        var comments = [PostComment]()
        
        let text = ["This is cool!", "This is rad", "I'm learning so much!", "This is awesome post!", "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text "]
        
        for comment in text {
            comments.append(PostComment(text: comment, user: user, date: Date()))
        }
        return comments
    }
}
