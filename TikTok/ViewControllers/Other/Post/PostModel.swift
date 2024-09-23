//
//  PostModel.swift
//  TikTok
//
//  Created by Влад Тимчук on 06.07.2024.
//

import Foundation

struct PostModel {
    let id: String
    let user: User
    var fileName: String = ""
    var caption: String = ""
    var isLikedByCurrentUser = false
    /// Represents database child path for this post in a given user node
    var videoChildPath: String {
        return "videos/\(user.name.lowercased())/\(fileName)"
    }
    
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(id: UUID().uuidString, user: User(id: UUID().uuidString, name: "kanyewest", profilePictureURL: nil))
            posts.append(post)
        }
        return posts
    }
    
    
}
