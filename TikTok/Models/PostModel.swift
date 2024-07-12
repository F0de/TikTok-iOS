//
//  PostModel.swift
//  TikTok
//
//  Created by Влад Тимчук on 06.07.2024.
//

import Foundation

struct PostModel {
    let id: String
    
    var isLikedByCurrentUser = false
    
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(id: UUID().uuidString)
            posts.append(post)
        }
        return posts
    }
}
